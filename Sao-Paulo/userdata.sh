#!/bin/bash
dnf update -y
dnf install -y python3-pip
pip3 install flask pymysql boto3



mkdir -p /opt/rdsapp
cat >/opt/rdsapp/app.py <<'PY'
import json
import os
import html
import boto3
import pymysql
from flask import Flask, request, redirect

REGION = os.environ.get("AWS_REGION", "sa-east-1")
SECRET_ID = os.environ.get("SECRET_ID", "lab/rds/mysql119")

secrets = boto3.client("secretsmanager", region_name=REGION)

def get_db_creds():
    resp = secrets.get_secret_value(SecretId=SECRET_ID)
    return json.loads(resp["SecretString"])

def get_conn():
    c = get_db_creds()
    return pymysql.connect(
        host=c["host"],
        user=c["username"],
        password=c["password"],
        port=int(c.get("port", 3306)),
        database=c.get("db_name", "labdb"),
        autocommit=True
    )

def page(title, body):
    return f"""
    <!doctype html>
    <html>
    <head>
      <title>{title}</title>
      <style>
        body {{
          font-family: Arial, sans-serif;
          background: #0f172a;
          color: #e5e7eb;
          margin: 0;
          padding: 40px;
        }}
        .card {{
          max-width: 760px;
          margin: auto;
          background: #111827;
          border: 1px solid #334155;
          border-radius: 14px;
          padding: 28px;
          box-shadow: 0 10px 30px rgba(0,0,0,.35);
        }}
        h1, h2, h3 {{ color: #38bdf8; }}
        input {{
          padding: 12px;
          width: 70%;
          border-radius: 8px;
          border: 1px solid #475569;
          background: #020617;
          color: white;
        }}
        button, .btn {{
          padding: 12px 16px;
          border: 0;
          border-radius: 8px;
          background: #2563eb;
          color: white;
          cursor: pointer;
          text-decoration: none;
          display: inline-block;
          margin: 6px 4px 6px 0;
        }}
        button:hover, .btn:hover {{ background: #1d4ed8; }}
        table {{
          width: 100%;
          border-collapse: collapse;
          margin-top: 18px;
        }}
        th, td {{
          padding: 12px;
          border-bottom: 1px solid #334155;
          text-align: left;
        }}
        th {{ color: #93c5fd; }}
        .muted {{ color: #94a3b8; }}
      </style>
    </head>
    <body>
      <div class="card">
        {body}
      </div>
    </body>
    </html>
    """

def get_notes_html():
    try:
        conn = get_conn()
        cur = conn.cursor()
        cur.execute("SELECT id, note FROM notes ORDER BY id DESC;")
        rows = cur.fetchall()
        cur.close()
        conn.close()

        if not rows:
            return "<p class='muted'>No notes in the database yet.</p>"

        out = """
        <h3>Database Records</h3>
        <table>
          <tr><th>ID</th><th>Note</th></tr>
        """
        for r in rows:
            out += f"<tr><td>{r[0]}</td><td>{html.escape(r[1])}</td></tr>"
        out += "</table>"
        return out

    except Exception as e:
        return f"<p class='muted'>Database not initialized yet. Click Initialize DB first.</p>"

app = Flask(__name__)

@app.route("/")
def home():
    body = f"""
    <h1>EC2 → RDS Notes App</h1>
    <p class="muted">Simple Flask app connected to Amazon RDS MySQL using Secrets Manager.</p>

    <a class="btn" href="/init">Initialize DB</a>
    <a class="btn" href="/list">Refresh Database</a>

    <h3>Add Note</h3>
    <form action="/add" method="get">
      <input name="note" placeholder="Type a note..." required>
      <button type="submit">Add Note</button>
    </form>

    {get_notes_html()}
    """
    return page("EC2 RDS Notes App", body)

@app.route("/init")
def init_db():
    c = get_db_creds()
    conn = pymysql.connect(
        host=c["host"],
        user=c["username"],
        password=c["password"],
        port=int(c.get("port", 3306)),
        autocommit=True
    )
    cur = conn.cursor()
    cur.execute("CREATE DATABASE IF NOT EXISTS labdb;")
    cur.execute("USE labdb;")
    cur.execute("""
        CREATE TABLE IF NOT EXISTS notes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            note VARCHAR(255) NOT NULL
        );
    """)
    cur.close()
    conn.close()
    return redirect("/")

@app.route("/add", methods=["POST", "GET"])
def add_note():
    note = request.args.get("note", "").strip()
    if not note:
        return page("Missing Note", "<h2>Missing note</h2><p>Try adding a note from the home page.</p><a class='btn' href='/'>Go Back</a>"), 400

    conn = get_conn()
    cur = conn.cursor()
    cur.execute("INSERT INTO notes(note) VALUES(%s);", (note,))
    cur.close()
    conn.close()
    return redirect("/")

@app.route("/list")
def list_notes():
    body = f"""
    <h2>Notes Database</h2>
    <a class="btn" href="/">Home</a>
    <a class="btn" href="/list">Refresh</a>
    {get_notes_html()}
    """
    return page("Notes Database", body)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
PY

cat >/etc/systemd/system/rdsapp.service <<'SERVICE'
[Unit]
Description=EC2 to RDS Notes App
After=network.target

[Service]
WorkingDirectory=/opt/rdsapp
Environment=SECRET_ID=lab/rds/mysql119
ExecStart=/usr/bin/python3 /opt/rdsapp/app.py
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable rdsapp
systemctl start rdsapp

