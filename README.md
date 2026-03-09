# LogeMe MVP

Application mobile de location pour le Togo et l'Afrique de l'Ouest.

## Structure

- `logeme_backend/` : API Django REST + JWT (SQLite local)
- `logeme_mobile/` : Frontend Flutter

## Backend (SQLite)

1. Installer dépendances:
```bash
cd logeme_backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```
2. Migrations:
```bash
python manage.py makemigrations
python manage.py migrate
```
3. Lancer serveur:
```bash
python manage.py runserver 0.0.0.0:8000
```

## Mobile Flutter

Le SDK local est dans `/home/junior/Flutter/flutter_sdk/flutter`.

```bash
cd logeme_mobile
export PATH="/home/junior/Flutter/flutter_sdk/flutter/bin:$PATH"
flutter pub get
flutter run
```

## Endpoints MVP

- Auth: `/api/auth/register|login|logout|verify-email|forgot-password/`
- User: `/api/users/me/`
- Listings: `/api/listings/`, `/api/listings/{id}/`, `/api/listings/my/`, `/api/listings/stats/`
- Favorites: `/api/favorites/`, `/api/favorites/{id}/`
- Reports: `/api/reports/`

## Flux MVP

`inscription -> verification email -> connexion -> liste annonces -> detail -> appel/WhatsApp`
