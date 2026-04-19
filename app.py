from flask import Flask, render_template, request, redirect, url_for, flash
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from werkzeug.security import check_password_hash, generate_password_hash
from db import get_db_connection
from config import SECRET_KEY

app = Flask(__name__)
app.secret_key = SECRET_KEY

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

class User(UserMixin):
    def __init__(self, id, brukernavn, kundebehandler_id, navn):
        self.id = id
        self.brukernavn = brukernavn
        self.kundebehandler_id = kundebehandler_id
        self.navn = navn

@login_manager.user_loader
def load_user(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT l.LoginID, l.Brukernavn, l.KundebehandlerID, k.KundebehandlerNavn
        FROM Login l
        JOIN Kundebehandler k ON l.KundebehandlerID = k.KundebehandlerID
        WHERE l.LoginID = %s
    """, (user_id,))
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    if row:
        return User(row["LoginID"], row["Brukernavn"], row["KundebehandlerID"], row["KundebehandlerNavn"])
    return None

@app.route("/")
@login_required
def dashboard():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT COUNT(*) AS antall FROM Utleie WHERE InnlevertDato IS NULL")
    aktive = cursor.fetchone()["antall"]

    cursor.execute("""
        SELECT COUNT(*) AS antall
        FROM Utstyr u
        WHERE NOT EXISTS (
            SELECT 1
            FROM Utleie ut
            WHERE ut.UtstyrsMal_ID = u.UtstyrsMal_ID
              AND ut.InstansID = u.InstansID
              AND ut.InnlevertDato IS NULL
        )
    """)
    tilgjengelige = cursor.fetchone()["antall"]

    cursor.execute("""
        SELECT u.UtleieID, u.UtleidDato, k.Kundenavn, um.UtstyrsMerke, um.UtstyrsModell
        FROM Utleie u
        JOIN Kunde k ON u.KundeNr = k.KundeNr
        JOIN UtstyrsMal um ON u.UtstyrsMal_ID = um.UtstyrsMal_ID
        ORDER BY u.UtleieID DESC
        LIMIT 5
    """)
    siste_utleier = cursor.fetchall()

    cursor.close()
    conn.close()
    return render_template("dashboard.html", aktive=aktive, tilgjengelige=tilgjengelige, siste_utleier=siste_utleier)

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        brukernavn = request.form["brukernavn"]
        passord = request.form["passord"]

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT l.LoginID, l.Brukernavn, l.PassordHash, l.KundebehandlerID, k.KundebehandlerNavn
            FROM Login l
            JOIN Kundebehandler k ON l.KundebehandlerID = k.KundebehandlerID
            WHERE l.Brukernavn = %s
        """, (brukernavn,))
        row = cursor.fetchone()
        cursor.close()
        conn.close()

        if row and check_password_hash(row["PassordHash"], passord):
            user = User(row["LoginID"], row["Brukernavn"], row["KundebehandlerID"], row["KundebehandlerNavn"])
            login_user(user)
            return redirect(url_for("dashboard"))

        flash("Feil brukernavn eller passord")

    return render_template("login.html")

@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("login"))

@app.route("/kunder")
@login_required
def kunder():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Kunde ORDER BY KundeNr")
    kunder = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template("kunder.html", kunder=kunder)

@app.route("/kunder/ny", methods=["GET", "POST"])
@login_required
def ny_kunde():
    if request.method == "POST":
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO Kunde (
                KundeNr, Kundenavn, KundeType, KundeEpost,
                LeveringAdrGate, LeveringAdrGateNr, LeveringAdrPostNr, LeveringAdrPoststed,
                FakturaAdrGate, FakturaAdrGateNr, FakturaAdrPostNr, FakturaAdrPoststed
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            request.form["kundenr"],
            request.form["kundenavn"],
            request.form["kundetype"],
            request.form["kundeepost"],
            request.form["levering_gate"],
            request.form["levering_gatenr"],
            request.form["levering_postnr"],
            request.form["levering_poststed"],
            request.form["faktura_gate"],
            request.form["faktura_gatenr"],
            request.form["faktura_postnr"],
            request.form["faktura_poststed"]
        ))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for("kunder"))

    return render_template("kunde_ny.html")

@app.route("/utstyr")
@login_required
def utstyr():
    valgt_type = request.args.get("type", "")
    valgt_kategori = request.args.get("kategori", "")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    sql = """
        SELECT 
            um.UtstyrsMal_ID,
            u.InstansID,
            um.UtstyrsMerke,
            um.UtstyrsModell,
            um.UtstyrsType,
            um.Kategori,
            CASE
                WHEN EXISTS (
                    SELECT 1 FROM Utleie ut
                    WHERE ut.UtstyrsMal_ID = u.UtstyrsMal_ID
                      AND ut.InstansID = u.InstansID
                      AND ut.InnlevertDato IS NULL
                ) THEN 'Utleid'
                ELSE 'Tilgjengelig'
            END AS Status
        FROM Utstyr u
        JOIN UtstyrsMal um ON u.UtstyrsMal_ID = um.UtstyrsMal_ID
        WHERE (%s = '' OR um.UtstyrsType = %s)
          AND (%s = '' OR um.Kategori = %s)
        ORDER BY um.UtstyrsType, um.UtstyrsMerke
    """
    cursor.execute(sql, (valgt_type, valgt_type, valgt_kategori, valgt_kategori))
    utstyrsliste = cursor.fetchall()

    cursor.execute("SELECT DISTINCT UtstyrsType FROM UtstyrsMal ORDER BY UtstyrsType")
    typer = cursor.fetchall()

    cursor.execute("SELECT DISTINCT Kategori FROM UtstyrsMal ORDER BY Kategori")
    kategorier = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("utstyr.html", utstyrsliste=utstyrsliste, typer=typer, kategorier=kategorier)

@app.route("/utleie/ny", methods=["GET", "POST"])
@login_required
def ny_utleie():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == "POST":
        cursor.execute("""
            INSERT INTO Utleie (
                UtleidDato, InnlevertDato, Betalingsmate, LeveresKunde,
                LeveringsKostnad, UtstyrsMal_ID, InstansID, KundebehandlerID, KundeNr
            ) VALUES (%s, NULL, %s, %s, %s, %s, %s, %s, %s)
        """, (
            request.form["utleid_dato"],
            request.form["betalingsmate"],
            request.form["leveres_kunde"],
            request.form["leveringskostnad"],
            request.form["utstyrsmal_id"],
            request.form["instans_id"],
            current_user.kundebehandler_id,
            request.form["kundenr"]
        ))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for("aktive_utleier"))

    cursor.execute("SELECT KundeNr, Kundenavn FROM Kunde ORDER BY Kundenavn")
    kunder = cursor.fetchall()

    cursor.execute("""
        SELECT u.UtstyrsMal_ID, u.InstansID, um.UtstyrsMerke, um.UtstyrsModell
        FROM Utstyr u
        JOIN UtstyrsMal um ON u.UtstyrsMal_ID = um.UtstyrsMal_ID
        WHERE NOT EXISTS (
            SELECT 1 FROM Utleie ut
            WHERE ut.UtstyrsMal_ID = u.UtstyrsMal_ID
              AND ut.InstansID = u.InstansID
              AND ut.InnlevertDato IS NULL
        )
        ORDER BY um.UtstyrsMerke, um.UtstyrsModell
    """)
    ledig_utstyr = cursor.fetchall()

    cursor.close()
    conn.close()
    return render_template("utleie.html", kunder=kunder, ledig_utstyr=ledig_utstyr)

@app.route("/utleie/innlever/<int:utleie_id>", methods=["POST"])
@login_required
def registrer_innlevering(utleie_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        UPDATE Utleie
        SET InnlevertDato = CURDATE()
        WHERE UtleieID = %s
    """, (utleie_id,))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for("aktive_utleier"))

@app.route("/statistikk")
@login_required
def statistikk():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT COUNT(*) AS AntallKompletteUtleier
        FROM Utleie
        WHERE UtleidDato >= '2019-01-01'
          AND InnlevertDato <= '2020-02-10'
          AND InnlevertDato IS NOT NULL
    """)
    komplette = cursor.fetchone()

    cursor.execute("""
        SELECT
            um.UtstyrsMal_ID,
            SUM(DATEDIFF(u.InnlevertDato, u.UtleidDato) * um.LeieprisDogn + u.LeveringsKostnad) AS SumPerUtstyr,
            um.UtstyrsMerke,
            um.UtstyrsModell,
            um.UtstyrsType
        FROM Utleie u
        JOIN UtstyrsMal um ON u.UtstyrsMal_ID = um.UtstyrsMal_ID
        WHERE u.InnlevertDato IS NOT NULL
        GROUP BY um.UtstyrsMal_ID, um.UtstyrsMerke, um.UtstyrsModell, um.UtstyrsType
        HAVING SUM(DATEDIFF(u.InnlevertDato, u.UtleidDato) * um.LeieprisDogn + u.LeveringsKostnad) > 0
        ORDER BY SumPerUtstyr DESC
    """)
    inntekt = cursor.fetchall()

    cursor.execute("""
        SELECT
            COUNT(*) AS AntUtleid,
            um.UtstyrsMerke,
            um.UtstyrsModell,
            um.UtstyrsType,
            um.Kategori
        FROM Utleie u
        JOIN UtstyrsMal um ON u.UtstyrsMal_ID = um.UtstyrsMal_ID
        GROUP BY um.UtstyrsMal_ID, um.UtstyrsMerke, um.UtstyrsModell, um.UtstyrsType, um.Kategori
        ORDER BY AntUtleid DESC
        LIMIT 1
    """)
    topp = cursor.fetchone()

    cursor.close()
    conn.close()
    return render_template("statistikk.html", komplette=komplette, inntekt=inntekt, topp=topp)