# Cognix — Backend (Django)

Overview

Django-based API that orchestrates AI interactions, handles file generation
(PDF/DOCX/PPTX), and stores minimal state in `db.sqlite3` by default. The
backend exposes endpoints used by the Flutter client (`ai_study/`).

Prerequisites
- Python 3.10+ (virtual environment recommended)
- See `requirements.txt` for dependencies.

Quick setup
```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

Notes
- The project includes `db.sqlite3` for local development; for production,
	switch to a managed database and configure environment variables.
- Use `.env` if environment variable support is implemented (check repo
	for dotenv usage).

License
See [LICENSE](LICENSE) for licensing terms. A copy is included at `backend/LICENSE`.
