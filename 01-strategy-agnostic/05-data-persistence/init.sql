-- Schema iniziale del database gestionale
-- Eseguito automaticamente da PostgreSQL al primo avvio se montato in /docker-entrypoint-initdb.d/

CREATE TABLE IF NOT EXISTS studenti (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    data_nascita DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS corsi (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descrizione TEXT,
    durata_ore INTEGER NOT NULL CHECK (durata_ore > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS iscrizioni (
    id SERIAL PRIMARY KEY,
    studente_id INTEGER NOT NULL REFERENCES studenti(id) ON DELETE CASCADE,
    corso_id INTEGER NOT NULL REFERENCES corsi(id) ON DELETE CASCADE,
    data_iscrizione DATE NOT NULL DEFAULT CURRENT_DATE,
    stato VARCHAR(50) NOT NULL DEFAULT 'attiva',
    pagamento_effettuato BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (studente_id, corso_id)
);

INSERT INTO studenti (nome, cognome, email, data_nascita) VALUES
    ('Mario', 'Rossi', 'mario.rossi@studente.ial.it', '1990-05-12'),
    ('Giulia', 'Bianchi', 'giulia.bianchi@studente.ial.it', '1995-09-23'),
    ('Luca', 'Verdi', 'luca.verdi@studente.ial.it', '1988-11-02')
ON CONFLICT (email) DO NOTHING;

INSERT INTO corsi (nome, descrizione, durata_ore) VALUES
    ('Cloud Fundamentals', 'Introduzione ai concetti base del cloud computing', 24),
    ('AWS Security', 'Sicurezza, IAM, KMS e compliance su AWS', 16),
    ('Docker e Kubernetes', 'Containerizzazione e orchestrazione per applicazioni moderne', 20)
ON CONFLICT DO NOTHING;

INSERT INTO iscrizioni (studente_id, corso_id, data_iscrizione, stato, pagamento_effettuato) VALUES
    (1, 1, '2025-06-01', 'attiva', true),
    (1, 2, '2025-06-05', 'attiva', false),
    (2, 1, '2025-06-03', 'completata', true),
    (3, 3, '2025-06-10', 'attiva', false)
ON CONFLICT (studente_id, corso_id) DO NOTHING;

CREATE OR REPLACE VIEW report_iscrizioni AS
SELECT
    i.id AS iscrizione_id,
    s.nome,
    s.cognome,
    s.email,
    c.nome AS corso,
    c.durata_ore,
    i.data_iscrizione,
    i.stato,
    i.pagamento_effettuato
FROM iscrizioni i
JOIN studenti s ON i.studente_id = s.id
JOIN corsi c ON i.corso_id = c.id;
