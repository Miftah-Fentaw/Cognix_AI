#!/bin/bash
echo "🚀 Setting up Cognix Backend in Projects folder..."

# Navigate to correct directory
cd /home/miftah/Projects/Cognix/backend || exit

# Create venv if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate venv
source venv/bin/activate

# Install dependencies
echo "⬇️  Installing dependencies..."
pip install django djangorestframework django-cors-headers requests python-dotenv

# Run migrations
echo "🗄️  Applying migrations..."
python manage.py migrate

# Run server
echo "✅ Starting server on 0.0.0.0:8000..."
echo "-----------------------------------"
python manage.py runserver 0.0.0.0:8000
