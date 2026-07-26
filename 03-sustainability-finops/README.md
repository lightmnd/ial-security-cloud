# Modulo 3 - Sustainability & FinOps (Lab 13-18)

Questa cartella contiene i lab pratici da eseguire in aula in sequenza.

## Ordine consigliato

1. `13-sustainability-shared-responsibility`
2. `14-finops-cost-management`
3. `15-lambda-serverless`
4. `16-autoscaling-graviton`
5. `17-storage-lifecycle`
6. `18-cdn-cloudfront`

## Prerequisiti minimi laboratorio

- Account AWS con permessi amministrativi temporanei per i lab.
- AWS CLI v2 installata e configurata (`aws configure`).
- Regione principale del corso: `eu-west-1`.
- Python 3.12 disponibile (usato in alcuni step di utility).
- Accesso console AWS per verifiche visuali (Billing, CloudWatch, CloudFront).

## Checklist iniziale rapida

```bash
aws --version
aws sts get-caller-identity
aws configure get region
python3 --version
```

## Convenzioni usate nei README

- Tutti i comandi sono scritti per essere compatibili con macOS e Linux.
- Dove possibile vengono creati file JSON locali invece di passare payload inline lunghi.
- Ogni lab include una sezione `Cleanup` per evitare costi residui.

## Nota didattica

Alcuni servizi (es. Cost Explorer, Budgets, Compute Optimizer) dipendono da dati storici dell'account.
Se il tenant e' nuovo, parti del lab potrebbero non mostrare risultati significativi, ma i comandi rimangono validi.
