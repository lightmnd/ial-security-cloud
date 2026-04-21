# 📘 Lezione 5 – Database: Agnostic vs Managed

**📅 Data:** Lunedì 15/06/2025  
**🗂️ Modulo:** Modulo 1 – Strategia & Agnosticismo  
**⏱️ Durata:** 1 ora

## 🎯 Obiettivi della Lezione
- Confrontare PostgreSQL self-managed (Docker Compose) vs Amazon RDS
- Configurare la persistenza dei dati con Docker Volumes
- Eseguire operazioni CRUD sul database del gestionale
- Usare PgAdmin per gestire il database via interfaccia grafica

## 📚 Concetti Chiave

### Self-Managed vs Managed Database

**PostgreSQL su Docker Compose (Self-Managed):**
- Tu controlli tutto: installazione, patch, backup, alta disponibilità
- Portabile: gira identicamente in locale, su VM, su Kubernetes
- Costi inferiori a parità di risorse
- Responsabilità: devi configurare backup, replica, monitoraggio

**Amazon RDS PostgreSQL (Managed):**
- AWS gestisce: patch, backup automatici, Multi-AZ failover
- SLA: 99.95% uptime con Multi-AZ
- Costo più alto rispetto a EC2 equivalente (~30% premium)
- Riduce la complessità operativa per team piccoli
- Integrazione nativa con IAM, KMS, CloudWatch, VPC

**Quando scegliere cosa:**
- Startup/piccoli team → RDS (meno overhead operativo)
- Team con DBA dedicato → Self-managed (più controllo e risparmio)
- Vincoli di portabilità/agnosticismo → Self-managed su container
- Compliance GDPR con key management → RDS + KMS Customer Managed Key

### Docker Volumes: Persistenza dei Dati
I container sono effimeri per default — quando vengono rimossi, i dati spariscono. I **Volumes** di Docker montano una directory persistente fuori dal container. Il volume sopravvive all'eliminazione e ricreazione del container.

```
Container PostgreSQL     ←→     Docker Volume (pgdata)
     /var/lib/postgresql/data   →  ./docker-volumes/pgdata/
```

### PgAdmin: GUI per PostgreSQL
PgAdmin è un'interfaccia web open source per gestire PostgreSQL. Permette di eseguire query SQL, visualizzare lo schema, gestire utenti, monitorare le performance — senza la necessità di usare la CLI psql.

## 🛠️ Hands-on: PostgreSQL con Docker Compose

### Prerequisiti
- Docker e Docker Compose installati
- Porta 5432 e 8080 libere sul laptop

### Step 1: Esaminare i file di configurazione

```bash
# Visualizza il docker-compose
cat 01-strategy-agnostic/05-data-persistence/docker-compose-db.yml

# Visualizza lo schema SQL
cat 01-strategy-agnostic/05-data-persistence/init.sql
```

### Step 2: Avviare PostgreSQL e PgAdmin

```bash
cd 01-strategy-agnostic/05-data-persistence/

# Avvia i servizi in background
docker compose -f docker-compose-db.yml up -d

# Verifica che i container siano partiti
docker compose -f docker-compose-db.yml ps

# Attendi che PostgreSQL sia healthy
docker compose -f docker-compose-db.yml logs postgres | tail -5
```
> 💡 **Nota:** Lo script `init.sql` viene eseguito automaticamente al primo avvio, creando le tabelle e inserendo i dati di esempio.

### Step 3: Connettersi con psql

```bash
# Connettiti al database dentro il container
docker exec -it gestionale-db psql -U admin -d gestionale

# Una volta dentro psql:
\dt                          -- lista le tabelle
\d studenti                  -- struttura tabella studenti
SELECT * FROM studenti;      -- lista tutti gli studenti
SELECT * FROM report_iscrizioni;  -- usa la view creata
\q                           -- esci
```

### Step 4: Operazioni CRUD

```sql
-- CREATE: inserisci un nuovo studente
INSERT INTO studenti (nome, cognome, email, data_nascita) 
VALUES ('Luisa', 'Conti', 'luisa.conti@studente.ial.it', '1992-03-10');

-- READ: cerca studenti iscritti al corso
SELECT s.nome, s.cognome, c.nome as corso, i.stato
FROM iscrizioni i
JOIN studenti s ON i.studente_id = s.id
JOIN corsi c ON i.corso_id = c.id
ORDER BY s.cognome;

-- UPDATE: aggiorna il pagamento
UPDATE iscrizioni SET pagamento_effettuato = true 
WHERE studente_id = 3;

-- DELETE: rimuovi lo studente appena creato
DELETE FROM studenti WHERE email = 'luisa.conti@studente.ial.it';
```

### Step 5: Accedere a PgAdmin

```
1. Apri browser: http://localhost:8080
2. Login: admin@corso.local / changeme_in_production
3. Aggiungi server:
   - Host: postgres (nome del servizio Docker)
   - Port: 5432
   - Database: gestionale
   - Username: admin
   - Password: changeme_in_production
4. Naviga: Servers → gestionale → Databases → gestionale → Schemas → Tables
```

### Step 6: Backup del Database

```bash
# Esegui un backup (dump SQL)
docker exec gestionale-db pg_dump -U admin gestionale > backup-gestionale-$(date +%Y%m%d).sql

# Verifica il backup
head -20 backup-gestionale-$(date +%Y%m%d).sql

# Ripristino da backup
# docker exec -i gestionale-db psql -U admin gestionale < backup-gestionale-YYYYMMDD.sql
```

### Step 7: Confronto con RDS (Teorico)

```bash
# Creare un'istanza RDS PostgreSQL (per riferimento, non eseguire in lab)
aws rds create-db-instance \
  --db-instance-identifier gestionale-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version "15.4" \
  --master-username admin \
  --master-user-password "SecurePass123!" \
  --allocated-storage 20 \
  --storage-encrypted \
  --backup-retention-period 7 \
  --multi-az \
  --region eu-west-1

# Nota: db.t3.micro Multi-AZ costa ~$30/mese vs ~$5/mese self-managed
```

### 🧹 Cleanup (Sostenibilità)

```bash
cd 01-strategy-agnostic/05-data-persistence/

# Ferma e rimuovi i container
docker compose -f docker-compose-db.yml down

# Rimuovi anche i volumi (cancella i dati!)
docker compose -f docker-compose-db.yml down -v

# Pulizia file di backup
rm -f backup-gestionale-*.sql

echo "Cleanup completato - nessuna risorsa cloud attiva"
```

## ✅ Checkpoint
- [ ] docker-compose-db.yml compreso e avviato
- [ ] PostgreSQL raggiungibile via `docker exec psql`
- [ ] init.sql eseguito con tabelle e dati presenti
- [ ] CRUD eseguito con successo
- [ ] PgAdmin accessibile via browser
- [ ] Backup creato con pg_dump

## 📖 Approfondimenti
- [PostgreSQL Documentation](https://www.postgresql.org/docs/15/)
- [Amazon RDS for PostgreSQL](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PgAdmin Documentation](https://www.pgadmin.org/docs/)
