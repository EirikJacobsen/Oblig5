# UtleieApp

Flask-applikasjon for et utleiesystem basert på databasen fra Oblig 3. Støtter innlogging, kundebehandling, utstyrsoversikt, utleieregistrering og statistikk.

## Teknologier

- Python / Flask
- MySQL (mysql-connector-python)
- Flask-Login (sesjonshåndtering)
- Werkzeug (passord-hashing)
- Jinja2 (templates)
- python-dotenv (.env-konfigurasjon)

## Oppsett

### 1. Klon repoet

```bash
git clone https://github.com/EirikJacobsen/Oblig5.git
cd Oblig5
```

### 2. Opprett og aktiver virtuelt miljø

```bash
python3 -m venv venv
source venv/bin/activate        # macOS/Linux
venv\Scripts\activate           # Windows
```

### 3. Installer avhengigheter

```bash
pip install -r requirements.txt
```

### 4. Sett opp MySQL-database

Kjør SQL-filene i denne rekkefølgen i MySQL:

```bash
mysql -u <bruker> -p < database/oblig3.sql
mysql -u <bruker> -p < database/login_tabell.sql
```

### 5. Konfigurer databasetilkobling med .env

Opprett en fil kalt `.env` i rotmappen med følgende innhold (tilpass verdiene til din MySQL-installasjon):

```env
db_host=localhost
db_user=ditt_brukernavn
db_password=ditt_passord
db_name=oblig3_5tabeller
SECRET_KEY=en_hemmelig_nokkel
```

> `.env` er lagt til i `.gitignore` og vil aldri bli pushet til GitHub.

### 6. Generer passord for brukerne

Standardbrukerne (`hilde` og `berit`) trenger passord-hasher i databasen. Kjør dette én gang:

```bash
python3 -c "
from werkzeug.security import generate_password_hash
from db import get_db_connection
conn = get_db_connection()
cursor = conn.cursor()
cursor.execute(\"UPDATE Login SET PassordHash = %s WHERE Brukernavn = 'hilde'\", (generate_password_hash('hilde123'),))
cursor.execute(\"UPDATE Login SET PassordHash = %s WHERE Brukernavn = 'berit'\", (generate_password_hash('berit123'),))
conn.commit()
cursor.close()
conn.close()
print('Passord oppdatert.')
"
```

Standard innlogging etter dette:

| Brukernavn | Passord   |
|------------|-----------|
| hilde      | hilde123  |
| berit      | berit123  |

### 7. Start applikasjonen

```bash
python app.py
```

Åpne nettleseren på [http://127.0.0.1:5000](http://127.0.0.1:5000).

## Funksjoner

| Side             | Beskrivelse                                              |
|------------------|----------------------------------------------------------|
| Login            | Innlogging med brukernavn og passord                     |
| Dashboard        | Oversikt over aktive utleier og tilgjengelig utstyr      |
| Kunder           | Liste over alle kunder med mulighet for redigering       |
| Ny kunde         | Registrer ny kunde med leverings- og fakturaadresse      |
| Utstyr           | Filtrerbar oversikt over alt utstyr med status           |
| Ny utleie        | Registrer utleie av ledig utstyr til en kunde            |
| Aktive utleier   | Se pågående utleier og registrer innlevering             |
| Statistikk       | Inntekt per utstyr og mest utleid utstyr                 |

## Databasedump

Mappen `database/` inneholder SQL-filer for oppbygging av databasen samt tidsstemplede dumps:

- `oblig3.sql` – oppretter tabeller og legger inn testdata
- `login_tabell.sql` – oppretter Login-tabell med brukere
- `dump_YYYY-MM-DD_HH-MM-SS.sql` – periodiske dumps av hele databasen

### Importere hele databasen fra en dump

Hvis du har en ferdig dump (f.eks. `dump_2026-04-19_14-56-32.sql`) kan du gjenopprette hele databasen med én kommando:

```bash
mysql -u <bruker> -p < database/dump_YYYY-MM-DD_HH-MM-SS.sql
```

Dumpen inneholder `CREATE DATABASE` og `USE`-setninger, så databasen opprettes automatisk – du trenger ikke kjøre `oblig3.sql` eller `login_tabell.sql` separat.

> **Merk:** Passordhashene i `Login`-tabellen er allerede inkludert i dumpen. Du trenger ikke generere nye passord etter import, med mindre du vil endre dem.
