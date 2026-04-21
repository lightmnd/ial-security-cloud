# 📘 Lezione 23 – Laboratorio Finale

**📅 Data:** Lunedì 16/09/2025  
**🗂️ Modulo:** Modulo 4 – IaC & Osservabilità  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Assemblare l'intera architettura del corso in un sistema coerente
- Applicare tutti i pattern di sicurezza, sostenibilità e IaC
- Documentare l'architettura finale

## 📚 Concetti Chiave

Il laboratorio finale integra tutti i componenti delle 22 lezioni precedenti in un sistema completo e produzione-ready.

Vedi `architecture-blueprint.md` per la documentazione completa dell'architettura.

## 🛠️ Hands-on: Deploy dell'Architettura Completa

```bash
cat 04-iac-observability/23-final-project/architecture-blueprint.md
```

### Checklist di Deploy Finale

```
MODULO 1 - INFRASTRUTTURA
[ ] VPC con subnet pubbliche e private (lezione 6)
[ ] EKS cluster con Graviton nodes (lezione 4 + 16)
[ ] ECR con immagini scansionate (lezione 3)

MODULO 2 - SICUREZZA
[ ] IAM roles con least-privilege (lezione 7)
[ ] KMS CMK per encryption at-rest (lezione 8)
[ ] WAF associato all'ALB (lezione 9)
[ ] CloudTrail e Config attivi (lezione 10)

MODULO 3 - SOSTENIBILITÀ
[ ] Lambda per notifiche (lezione 15)
[ ] S3 lifecycle policies (lezione 17)
[ ] CloudFront distribuzione (lezione 18)
[ ] Budget Alert $100/mese (lezione 14)

MODULO 4 - IaC
[ ] Tutto deployato via Terraform (lezione 19)
[ ] Dashboard Grafana operativo (lezione 20)
[ ] Step Functions workflow attivo (lezione 21)
```

### 🧹 Cleanup Finale

```bash
# Elimina tutto tramite Terraform
cd 04-iac-observability/19-terraform-core/
terraform destroy -auto-approve

echo "Architettura completa eliminata"
```

## ✅ Checkpoint
- [ ] Architecture blueprint documentato
- [ ] Tutti i moduli integrati
- [ ] Sistema testato end-to-end

## 📖 Approfondimenti
- [AWS Reference Architectures](https://aws.amazon.com/architecture/)
- [AWS Well-Architected Labs](https://wellarchitectedlabs.com/)
