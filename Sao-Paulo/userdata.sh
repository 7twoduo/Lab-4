#!/bin/bash
set -Eeuo pipefail
PKG="$(command -v dnf || command -v yum)"
"$PKG" update -y
"$PKG" install -y python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install flask pymysql boto3

mkdir -p /opt/rdsapp
cat >/opt/rdsapp/app.py <<'PY'
import json
import os
import html
import boto3
import pymysql
from flask import Flask, request, redirect, Response
REGION = os.environ.get("AWS_REGION", "sa-east-1")
SECRET_ID = os.environ.get("SECRET_ID", "lab/rds/mysql692")
APP_VERSION = os.environ.get("APP_VERSION", "mysql692-v4")
secrets = boto3.client("secretsmanager", region_name=REGION)
app = Flask(__name__)
def get_db_creds():
    resp = secrets.get_secret_value(SecretId=SECRET_ID)
    return json.loads(resp["SecretString"])
def db_name_from_secret(c):
    return c.get("db_name") or c.get("dbname") or c.get("database") or "labdb"
def quote_identifier(name):
    return "`" + str(name).replace("`", "``") + "`"
def get_conn(use_db=True):
    c = get_db_creds()
    kwargs = {
        "host": c["host"],
        "user": c["username"],
        "password": c["password"],
        "port": int(c.get("port", 3306)),
        "connect_timeout": 10,
        "autocommit": True,
        "charset": "utf8mb4",
        "cursorclass": pymysql.cursors.Cursor,
    }
    if use_db:
        kwargs["database"] = db_name_from_secret(c)
    return pymysql.connect(**kwargs)
def create_notes_table(cur):
    cur.execute("""
        CREATE TABLE IF NOT EXISTS notes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            note VARCHAR(255) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    """)
    try:
        cur.execute("ALTER TABLE notes ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;")
    except pymysql.err.OperationalError as e:
        if e.args and e.args[0] != 1060:
            raise

def ensure_schema():
    c = get_db_creds()
    db_name = db_name_from_secret(c)
    try:
        conn = get_conn(use_db=False)
        cur = conn.cursor()
        cur.execute(f"CREATE DATABASE IF NOT EXISTS {quote_identifier(db_name)} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;")
        cur.execute(f"USE {quote_identifier(db_name)};")
        create_notes_table(cur)
        cur.close()
        conn.close()
    except pymysql.err.OperationalError as e:
        code = e.args[0] if e.args else None
        if code not in (1044, 1045, 1227):
            raise
        conn = get_conn(use_db=True)
        cur = conn.cursor()
        create_notes_table(cur)
        cur.close()
        conn.close()
    return db_name


def safe_error(e):
    return html.escape(str(e))


def get_notes_html():
    try:
        ensure_schema()
        conn = get_conn(use_db=True)
        cur = conn.cursor()
        cur.execute("SELECT id, note, COALESCE(DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s'), 'legacy') FROM notes ORDER BY id DESC;")
        rows = cur.fetchall()
        cur.close()
        conn.close()
        if not rows:
            return """<div class='empty'><div class='empty-icon'>📝</div><h3>No records yet</h3><p>Add a note to prove the EC2 → Secrets Manager → RDS path.</p></div>"""
        out = """<div class='table-wrap'><table><thead><tr><th>ID</th><th>Note</th><th>Created</th></tr></thead><tbody>"""
        for r in rows:
            out += f"<tr><td><span class='pill'>#{r[0]}</span></td><td>{html.escape(str(r[1]))}</td><td>{html.escape(str(r[2]))}</td></tr>"
        out += "</tbody></table></div>"
        return out
    except Exception as e:
        return f"""<div class='empty warning'><div class='empty-icon'>⚠️</div><h3>Database not ready</h3><p>This AMI builder may not have Secrets Manager permission. The app is running; the launched instance with the correct role should connect.</p><small>{safe_error(e)}</small></div>"""


def db_status_html():
    try:
        db_name = ensure_schema()
        c = get_db_creds()
        host = html.escape(c.get("host", "unknown"))
        return f"""<aside class='panel status good'><div class='dot'></div><p class='eyebrow'>Database</p><h3>Connected</h3><p>Secret <b>{html.escape(SECRET_ID)}</b></p><p class='muted'>DB: <b>{html.escape(db_name)}</b><br>Host: <b>{host}</b></p></aside>"""
    except Exception as e:
        return f"""<aside class='panel status bad'><div class='dot'></div><p class='eyebrow'>Database</p><h3>Waiting for Runtime Role</h3><p class='muted'>The app is installed. The final EC2 role must allow Secrets Manager and RDS access.</p><small>{safe_error(e)}</small></aside>"""


STYLE_CSS = r"""
*{box-sizing:border-box}body{margin:0;min-height:100vh;font-family:Inter,ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;color:#e5e7eb;background:radial-gradient(circle at 8% 8%,rgba(56,189,248,.32),transparent 30rem),radial-gradient(circle at 92% 10%,rgba(168,85,247,.22),transparent 30rem),linear-gradient(135deg,#020617 0%,#0f172a 45%,#111827 100%);padding:34px}.shell{width:min(1180px,100%);margin:0 auto}.hero{display:grid;grid-template-columns:1.45fr .85fr;gap:24px;margin-bottom:24px}.panel{background:rgba(15,23,42,.86);border:1px solid rgba(148,163,184,.24);border-radius:30px;box-shadow:0 28px 90px rgba(0,0,0,.42);backdrop-filter:blur(18px)}.hero-main{padding:38px;position:relative;overflow:hidden}.hero-main:after{content:"";position:absolute;right:-95px;top:-95px;width:270px;height:270px;border-radius:999px;background:rgba(56,189,248,.12);border:1px solid rgba(125,211,252,.24)}.badge{display:inline-flex;padding:9px 13px;border-radius:999px;color:#bae6fd;background:rgba(14,165,233,.14);border:1px solid rgba(125,211,252,.28);font-size:12px;font-weight:900;letter-spacing:.09em;text-transform:uppercase}h1{margin:20px 0 14px;font-size:clamp(38px,5vw,64px);line-height:.92;letter-spacing:-.06em}h2{margin:0 0 8px;font-size:25px;letter-spacing:-.035em}.subtitle,.muted,p{color:#cbd5e1;line-height:1.65}.actions{display:flex;flex-wrap:wrap;gap:12px;margin-top:28px}.btn,button{border:0;border-radius:15px;padding:14px 18px;color:#fff;text-decoration:none;font-weight:900;cursor:pointer;background:linear-gradient(135deg,#2563eb,#06b6d4);box-shadow:0 16px 36px rgba(37,99,235,.34);transition:.18s ease}.btn:hover,button:hover{transform:translateY(-1px);box-shadow:0 22px 48px rgba(37,99,235,.42)}.btn.secondary{background:rgba(15,23,42,.88);border:1px solid rgba(148,163,184,.30);box-shadow:none}.grid{display:grid;grid-template-columns:.85fr 1.35fr;gap:24px}.card{padding:30px}.status{padding:30px;display:flex;flex-direction:column;justify-content:center;min-height:100%}.status h3{font-size:31px;margin:8px 0}.good h3{color:#86efac}.bad h3{color:#fca5a5}.dot{width:18px;height:18px;border-radius:999px;background:#22c55e;box-shadow:0 0 0 10px rgba(34,197,94,.12);margin-bottom:15px}.bad .dot{background:#f59e0b;box-shadow:0 0 0 10px rgba(245,158,11,.13)}.eyebrow{margin:0;color:#38bdf8;font-size:12px;text-transform:uppercase;letter-spacing:.13em;font-weight:900}.input-row{display:flex;gap:10px;margin-top:18px}input{width:100%;border:1px solid rgba(148,163,184,.30);border-radius:15px;background:rgba(2,6,23,.72);color:#f8fafc;padding:15px;font-size:15px;outline:none}input:focus{border-color:rgba(56,189,248,.88);box-shadow:0 0 0 4px rgba(56,189,248,.13)}.table-wrap{overflow:hidden;border:1px solid rgba(148,163,184,.18);border-radius:20px;margin-top:18px}table{width:100%;border-collapse:collapse}th{color:#93c5fd;background:rgba(15,23,42,.94);text-align:left;padding:15px 16px;font-size:12px;text-transform:uppercase;letter-spacing:.09em}td{padding:16px;border-top:1px solid rgba(148,163,184,.14);color:#e2e8f0}.pill{display:inline-flex;padding:6px 10px;border-radius:999px;background:rgba(37,99,235,.18);color:#bfdbfe;font-weight:900}.empty{margin-top:18px;padding:32px;text-align:center;border-radius:22px;border:1px dashed rgba(148,163,184,.32);background:rgba(2,6,23,.26)}.empty-icon{font-size:40px;margin-bottom:9px}.warning h3{color:#fbbf24}small{display:block;color:#94a3b8;word-break:break-word;margin-top:10px}footer{text-align:center;margin-top:24px;color:#64748b;font-size:13px}@media(max-width:900px){body{padding:18px}.hero,.grid{grid-template-columns:1fr}.input-row{flex-direction:column}h1{font-size:42px}}
"""


def page(title, body):
    return f"""<!doctype html><html lang='en'><head><meta charset='utf-8'><meta name='viewport' content='width=device-width, initial-scale=1'><meta http-equiv='Cache-Control' content='no-store, no-cache, max-age=0'><title>{html.escape(title)}</title><link rel='stylesheet' href='/style.css?v={APP_VERSION}'><style>{STYLE_CSS}</style></head><body><main class='shell'>{body}<footer>EC2 → Secrets Manager → RDS MySQL | Flask on port 80</footer></main></body></html>"""


@app.route("/style.css")
def style_css():
    resp = Response(STYLE_CSS, mimetype="text/css")
    resp.headers["Cache-Control"] = "no-store, no-cache, max-age=0, s-maxage=0"
    resp.headers["Pragma"] = "no-cache"
    resp.headers["Expires"] = "0"
    return resp


@app.after_request
def no_cache_dynamic_html(resp):
    if "text/html" in resp.content_type:
        resp.headers["Cache-Control"] = "no-store, no-cache, max-age=0, s-maxage=0"
        resp.headers["Pragma"] = "no-cache"
        resp.headers["Expires"] = "0"
    return resp


@app.route("/health")
def health():
    return "healthy", 200


def dashboard(records_title="Database Records"):
    return f"""
    <section class='hero'><div class='panel hero-main'><div class='badge'>AWS Production Path Demo</div><h1>EC2 → RDS Notes Command Center</h1><p class='subtitle'>A polished Flask dashboard running on EC2, pulling credentials from AWS Secrets Manager, and writing live records into Amazon RDS MySQL.</p><div class='actions'><a class='btn' href='/init'>Initialize DB</a><a class='btn secondary' href='/list'>Refresh Records</a><a class='btn secondary' href='/health'>Health Check</a></div></div>{db_status_html()}</section>
    <section class='grid'><div class='panel card'><p class='eyebrow'>Create Record</p><h2>Add a note</h2><p class='muted'>Submit a record to verify browser → EC2 → Secrets Manager → RDS.</p><form action='/add' method='get'><div class='input-row'><input name='note' placeholder='Type a production test note...' required><button type='submit'>Add</button></div></form></div><div class='panel card'><p class='eyebrow'>Live Data</p><h2>{records_title}</h2>{get_notes_html()}</div></section>
    """


@app.route("/")
def home():
    return page("EC2 RDS Notes App", dashboard())


@app.route("/init")
def init_db():
    try:
        db_name = ensure_schema()
        body = f"""<section class='hero'><div class='panel hero-main'><div class='badge'>Database Initialized</div><h1>Schema Ready</h1><p class='subtitle'>Database <b>{html.escape(db_name)}</b> and table <b>notes</b> are ready for writes.</p><div class='actions'><a class='btn' href='/'>Home</a><a class='btn secondary' href='/list'>View Records</a></div></div>{db_status_html()}</section><section class='panel card'><p class='eyebrow'>Live Data</p><h2>Current Records</h2>{get_notes_html()}</section>"""
        return page("Database Initialized", body)
    except Exception as e:
        body = f"""<section class='hero'><div class='panel hero-main'><div class='badge'>Runtime Dependency Pending</div><h1>App Installed</h1><p class='subtitle'>The Flask service is healthy. Database initialization is waiting on the runtime EC2 role, secret access, or RDS network path.</p><div class='actions'><a class='btn' href='/'>Home</a><a class='btn secondary' href='/list'>View Records</a></div></div>{db_status_html()}</section><section class='panel card'><p class='eyebrow'>Init Result</p><h2>Initialization blocked</h2><p class='muted'>This is expected on the golden AMI builder if it does not have Secrets Manager permission.</p><small>{safe_error(e)}</small></section>"""
        return page("Initialization Pending", body), 200


@app.route("/add", methods=["POST", "GET"])
def add_note():
    try:
        ensure_schema()
        note = request.values.get("note", "").strip()
        if not note:
            return page("Missing Note", "<section class='panel card'><h1>Missing note</h1><p class='muted'>Go back and enter a note.</p><a class='btn' href='/'>Return Home</a></section>"), 400
        conn = get_conn(use_db=True)
        cur = conn.cursor()
        cur.execute("INSERT INTO notes(note) VALUES(%s);", (note,))
        cur.close()
        conn.close()
        return redirect("/list")
    except Exception as e:
        body = f"""<section class='panel card'><p class='eyebrow'>Write Blocked</p><h1>Record was not added</h1><p class='muted'>The app is running, but database write access is not available on this instance.</p><small>{safe_error(e)}</small><div class='actions'><a class='btn' href='/'>Home</a><a class='btn secondary' href='/list'>Records</a></div></section>"""
        return page("Write Blocked", body), 200


@app.route("/list")
def list_notes():
    body = f"""<section class='hero'><div class='panel hero-main'><div class='badge'>Database View</div><h1>RDS Records</h1><p class='subtitle'>Fresh records pulled directly from the RDS MySQL backend when the runtime role has permission.</p><div class='actions'><a class='btn' href='/'>Home</a><a class='btn secondary' href='/init'>Initialize DB</a><a class='btn secondary' href='/list'>Refresh</a></div></div>{db_status_html()}</section><section class='panel card'><p class='eyebrow'>Live Data</p><h2>Database Records</h2>{get_notes_html()}</section>"""
    return page("Notes Database", body)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
PY
# line guard 01: keep systemd target line stable
# line guard 02: used by external replacement script
# line guard 03: do not remove without rechecking line 206
cat >/etc/systemd/system/rdsapp.service <<'SERVICE'
[Unit]
Description=EC2 to RDS Notes App
After=network.target
[Service]
WorkingDirectory=/opt/rdsapp
Environment=SECRET_ID=lab/rds/mysql692
ExecStart=/usr/bin/python3 /opt/rdsapp/app.py
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable rdsapp
systemctl restart rdsapp
