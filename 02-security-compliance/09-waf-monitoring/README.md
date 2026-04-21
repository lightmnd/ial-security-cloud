# 📘 Lezione 9 – WAF e Monitoraggio

**�� Data:** Lunedì 29/06/2025  
**🗂️ Modulo:** Modulo 2 – Sicurezza & Compliance  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Configurare AWS WAF v2 con regole gestite e personalizzate
- Implementare rate limiting per proteggersi da DDoS e brute force
- Creare allarmi CloudWatch per rilevare attacchi in corso
- Analizzare i log WAF per identificare pattern di attacco

## 📚 Concetti Chiave

### AWS WAF (Web Application Firewall)
WAF filtra il traffico HTTP/HTTPS prima che raggiunga la tua applicazione. Opera a livello 7 (Application Layer) — conosce il contenuto delle richieste HTTP.

**Cosa protegge WAF:**
- SQL Injection: tentativi di manipolare query al database
- Cross-Site Scripting (XSS): iniezione di script malevoli
- Remote Code Execution: esecuzione di codice arbitrario
- Rate-based attacks: DDoS, credential stuffing, brute force

**Dove si integra WAF:**
- CloudFront (edge globale)
- Application Load Balancer (regionale)
- API Gateway (API REST)
- Cognito User Pools (autenticazione)
- AppSync (GraphQL)

### Componenti WAF v2
- **WebACL**: l'insieme di regole (Access Control List). Si associa a un ALB o CloudFront.
- **Rule**: condizione + azione. Può matchare su: IP, header, URI, body, query string, metodo HTTP.
- **Rule Group**: insieme riutilizzabile di regole. AWS fornisce Managed Rule Groups aggiornati automaticamente.
- **Action**: Allow, Block, Count (monitora senza bloccare — utile per testing).

### Managed Rule Groups AWS
AWS fornisce rule groups gestiti e aggiornati:
- `AWSManagedRulesCommonRuleSet`: protezione generale (OWASP Top 10)
- `AWSManagedRulesSQLiRuleSet`: protezione specifica SQL injection
- `AWSManagedRulesKnownBadInputsRuleSet`: input malevoli noti
- `AWSManagedRulesAmazonIpReputationList`: IP con reputazione negativa
- `AWSManagedRulesAnonymousIpList`: proxy/Tor/VPN

## 🛠️ Hands-on: Configurare WAF per il Gestionale

### Prerequisiti
- AWS CLI configurata con permessi `wafv2:*` e `cloudwatch:*`
- Un ALB esistente (o usa `--scope CLOUDFRONT` per CloudFront)

### Step 1: Esaminare la configurazione WAF esistente

```bash
cat 02-security-compliance/09-waf-monitoring/waf-rules.json
```

### Step 2: Creare la WebACL

```bash
# Crea il WebACL con le regole definite nel JSON
WAF_ARN=$(aws wafv2 create-web-acl \
  --name gestionale-webacl \
  --scope REGIONAL \
  --default-action Allow={} \
  --rules file://02-security-compliance/09-waf-monitoring/waf-rules.json \
  --visibility-config SampledRequestsEnabled=true,CloudWatchMetricsEnabled=true,MetricName=gestionale-webacl \
  --region eu-west-1 \
  --query 'Summary.ARN' \
  --output text)

echo "WAF WebACL creata: $WAF_ARN"
```

### Step 3: Associare WAF all'Application Load Balancer

```bash
ALB_ARN="arn:aws:elasticloadbalancing:eu-west-1:123456789012:loadbalancer/app/gestionale-alb/1234567890"

aws wafv2 associate-web-acl \
  --web-acl-arn $WAF_ARN \
  --resource-arn $ALB_ARN \
  --region eu-west-1

echo "WAF associato all'ALB"
```

### Step 4: Abilitare il logging WAF su S3

```bash
LOG_BUCKET="aws-waf-logs-gestionale-$(aws sts get-caller-identity --query Account --output text)"

# Crea bucket per i log (il nome deve iniziare con "aws-waf-logs-")
aws s3api create-bucket \
  --bucket $LOG_BUCKET \
  --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1

# Abilita il logging
aws wafv2 put-logging-configuration \
  --logging-configuration ResourceArn=$WAF_ARN,LogDestinationConfigs=arn:aws:s3:::$LOG_BUCKET \
  --region eu-west-1

echo "Logging WAF abilitato su s3://$LOG_BUCKET"
```

### Step 5: Creare allarme CloudWatch per richieste bloccate

```bash
# Crea SNS topic per le notifiche
SNS_ARN=$(aws sns create-topic \
  --name gestionale-security-alerts \
  --region eu-west-1 \
  --query 'TopicArn' \
  --output text)

# Sottoscrivi email al topic
aws sns subscribe \
  --topic-arn $SNS_ARN \
  --protocol email \
  --notification-endpoint "security@gestionale.ial.it" \
  --region eu-west-1

# Crea allarme: se >100 richieste bloccate in 5 minuti → alert
aws cloudwatch put-metric-alarm \
  --alarm-name "WAF-BlockedRequests-High" \
  --alarm-description "Troppe richieste bloccate dal WAF - possibile attacco" \
  --metric-name BlockedRequests \
  --namespace AWS/WAFV2 \
  --dimensions Name=WebACL,Value=gestionale-webacl Name=Region,Value=eu-west-1 Name=Rule,Value=ALL \
  --statistic Sum \
  --period 300 \
  --threshold 100 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 1 \
  --alarm-actions $SNS_ARN \
  --region eu-west-1
```

### Step 6: Testare le regole con mode Count

```bash
# Cambia una regola in COUNT per testare senza bloccare
# Recupera la configurazione attuale
WAF_ID=$(aws wafv2 get-web-acl \
  --name gestionale-webacl \
  --scope REGIONAL \
  --region eu-west-1 \
  --query 'WebACL.Id' \
  --output text)

echo "WAF ID: $WAF_ID"

# Visualizza le statistiche di campionamento
aws wafv2 get-sampled-requests \
  --web-acl-arn $WAF_ARN \
  --rule-metric-name gestionale-webacl \
  --scope REGIONAL \
  --time-window StartTime=$(date -u -d '1 hour ago' +%s),EndTime=$(date -u +%s) \
  --max-items 10 \
  --region eu-west-1
```

### 🧹 Cleanup (Sostenibilità)

```bash
# Disassocia WAF dall'ALB prima di eliminarlo
aws wafv2 disassociate-web-acl --resource-arn $ALB_ARN --region eu-west-1

# Elimina logging configuration
aws wafv2 delete-logging-configuration --resource-arn $WAF_ARN --region eu-west-1

# Elimina WebACL (richiede lock token)
LOCK_TOKEN=$(aws wafv2 get-web-acl --name gestionale-webacl --scope REGIONAL --id $WAF_ID --region eu-west-1 --query 'LockToken' --output text)
aws wafv2 delete-web-acl --name gestionale-webacl --scope REGIONAL --id $WAF_ID --lock-token $LOCK_TOKEN --region eu-west-1

# Elimina allarme e SNS
aws cloudwatch delete-alarms --alarm-names "WAF-BlockedRequests-High" --region eu-west-1
aws sns delete-topic --topic-arn $SNS_ARN --region eu-west-1

# Svuota e elimina bucket log
aws s3 rm s3://$LOG_BUCKET --recursive
aws s3api delete-bucket --bucket $LOG_BUCKET --region eu-west-1
```

## ✅ Checkpoint
- [ ] Comprendo la differenza tra Managed Rule Groups e regole personalizzate
- [ ] WebACL creata con almeno 3 regole configurate
- [ ] Rate-based rule configurata (2000 req/5min)
- [ ] Allarme CloudWatch attivo per richieste bloccate
- [ ] Logging WAF abilitato su S3

## 📖 Approfondimenti
- [AWS WAF Documentation](https://docs.aws.amazon.com/waf/latest/developerguide/)
- [AWS Managed Rule Groups](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups.html)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [AWS WAF Security Automations](https://aws.amazon.com/solutions/implementations/aws-waf-security-automations/)
