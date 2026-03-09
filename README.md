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

Pour pointer vers un backend public (APK):
```bash
flutter build apk --release --dart-define=API_BASE_URL=https://api.ton-domaine.com
```

## Endpoints MVP

- Auth: `/api/auth/register|login|logout|verify-email|forgot-password/`
  - `POST /api/auth/request-email-verification/` (email)
  - `POST /api/auth/verify-email/` (uid + token)
  - `POST /api/auth/forgot-password/` (email)
  - `POST /api/auth/reset-password-confirm/` (uid + token + new_password)
- User: `/api/users/me/`
- Listings: `/api/listings/`, `/api/listings/{id}/`, `/api/listings/my/`, `/api/listings/stats/`
- Favorites: `/api/favorites/`, `/api/favorites/{id}/`
- Reports: `/api/reports/`

## Flux MVP

`inscription -> verification email -> connexion -> liste annonces -> detail -> appel/WhatsApp`

## Conditions Test Entre Amis (APK)

1. Backend en ligne (public):
```bash
cd logeme_backend
cp .env.example .env
# Mets DJANGO_DEBUG=0 + ton domaine dans DJANGO_ALLOWED_HOSTS
. .venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
gunicorn logeme.wsgi:application --bind 0.0.0.0:8000
```

2. CORS / HTTPS:
- Dans `.env` production:
  - `CORS_ALLOW_ALL_ORIGINS=0`
  - `CORS_ALLOWED_ORIGINS=https://ton-app-web-ou-domaine`
  - `CSRF_TRUSTED_ORIGINS=https://ton-domaine-api`
  - `SECURE_SSL_REDIRECT=1`
  - `SESSION_COOKIE_SECURE=1`
  - `CSRF_COOKIE_SECURE=1`

3. SMTP réel (emails verify/reset):
- Dans `.env`:
  - `EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend`
  - `EMAIL_HOST=smtp.gmail.com`
  - `EMAIL_PORT=587`
  - `EMAIL_HOST_USER=ton_email`
  - `EMAIL_HOST_PASSWORD=mot_de_passe_app`
  - `EMAIL_USE_TLS=1`
  - `DEFAULT_FROM_EMAIL=no-reply@ton-domaine.com`
  - `FRONTEND_BASE_URL=https://logeme.app`

4. Build APK avec URL publique API:
```bash
cd logeme_mobile
export PATH="/home/junior/Flutter/flutter_sdk/flutter/bin:$PATH"
flutter pub get
flutter build apk --release --dart-define=API_BASE_URL=https://api.ton-domaine.com
```
