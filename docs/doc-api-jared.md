# Blood Synergy — Backend Migration Handoff

**For:** the mobile app developer
**Date:** 31 July 2026
**Subject:** The primary API has moved to our own server — action needed in the app config

---

## TL;DR

The primary mobile backend that used to run at
`https://bloodsynergybackend.trangotech.dev/api/` is now hosted on **our own
server**. To switch the app over, you only need to **change three values in the
app's `.env`** (below). The request/response contract is **unchanged** — every
endpoint behaves exactly as described in `API-Doc.md`, so no Dart/model changes
are required.

---

## 1. Change these in the app `.env`

| Key | New value | Notes |
|---|---|---|
| `BASE_URL` | `https://web.blood-synergy.com/api/` | **must keep the trailing `/`** |
| `UPLOAD_BASE_URL` | `https://web.blood-synergy.com/` | **must keep the trailing `/`** |
| `MAIN_BASE_URL` | `https://web.blood-synergy.com` | unchanged — this was already correct |

That's it. `BASE_URL` + `customer/login` resolves to
`https://web.blood-synergy.com/api/customer/login`, etc.

> If we front the server with a different public domain later, only the host in
> those three values changes.

**HTTPS only.** The server redirects HTTP → HTTPS and has a valid certificate,
so the app's "accept invalid certificate" override (`MyHttpOverrides`) is no
longer needed and should be removed for production.

---

## 2. What's implemented

All 24 endpoints from `API-Doc.md` are live, under `/api/customer/*` (plus
`/term-condition`):

- **Auth/account:** login, register, resend/verify OTP, forgot, change/reset
  password, logout, delete account, social login
- **Profile:** get, update (multipart, with image upload)
- **Catalog:** categories, doctors, doctor detail, supplements, category form
- **Reports:** list, detail, create, statistics

Responses use the documented envelope (`status` / `message` / `data` / `token` /
`pagination`); success is decided from the JSON `status`, exactly as today.

**Auth:** login/register/social return a Bearer token in `token`. Send it as
`Authorization: Bearer <token>` on protected calls. The login `phone` field
accepts an email or a phone number (same as before). Forgot-password flow is
unchanged: `forgot` → returns reset token → `verify/otp` → `change/password`
with `is_forgot: "1"`.

---

## 3. Test account (please remove before go-live)

A ready-to-use account with a sample report is seeded so you can log in and see
data immediately:

```
email/phone : demo@blood-synergy.com
password    : Demo@12345
```

It has one Lipid Panel report that produces a "Cardiovascular/Metabolic Risk"
pattern, so Reports, Report Detail and Statistics all return content for it.

---

## 4. 30-second verification (curl)

```bash
# Register (or use the demo account)
curl -s -X POST https://web.blood-synergy.com/api/customer/login \
  -F 'phone=demo@blood-synergy.com' -F 'password=Demo@12345'
# -> { "status":200, "message":"Login successful", "data":{...}, "token":"<TOKEN>" }

# Use the token
TOKEN=<paste token>
curl -s https://web.blood-synergy.com/api/customer/categories \
  -H "Authorization: Bearer $TOKEN"
```

---

## 5. Two things you must know (important)

**a) This is a fresh database — old accounts and history did NOT carry over.**
The previous developer's server is gone and unreachable, so the users, past
reports, doctor roster and supplement content that lived there could not be
recovered. Practical impact:
- Existing users cannot log in with old credentials; they will need to
  **register again**.
- The categories, blood markers, doctors and supplements currently in the app
  are **sensible placeholder content**, not the original data. If you (or the
  client) can provide the real reference content — or a database export from the
  old server if one ever turns up — we will load it. Until then the app is fully
  functional against the placeholder catalog.

**b) Phone OTP (forgot-password / resend) has no SMS/email gateway yet.**
Those endpoints generate and store a code, but there is currently no delivery
provider wired on this server, so a user won't actually receive the code. (Codes
are written to the server log in the current dev configuration.) The **signup
email OTP is unaffected** — that still goes through SendGrid from the app, as
before. If the app relies on backend phone-OTP for password reset, let us know
and we'll connect a gateway; otherwise we can keep reset on the email path.

---

## 6. What did NOT change

- **Website sync** (`POST /api/login`, `POST /api/register` — the `MAIN_BASE_URL`
  calls) still works the same way and returns `{ success, auth_token }`.
- **Signup email OTP via SendGrid** is still a direct client → SendGrid call.
- Image/icon fields still return absolute URLs (or relative paths you resolve
  against `UPLOAD_BASE_URL`, same as before).
- `statistics` still keys `data` by month name (`type=month`) or year
  (`type=year`).

---

## 7. A couple of questions back to you

1. Confirm the **public domain** we should standardize on (currently
   `web.blood-synergy.com`).
2. Do you have the **real reference data** (categories/markers/doctors/
   supplements) or a DB export from the old backend? If so, send it over.
3. Is **backend phone-OTP password reset** required, or can reset stay on the
   email/SendGrid path? This decides whether we wire an SMS gateway.

---

*Server-side code and operations notes live in `app/mobile/README.md` on the
server, for whoever maintains the backend.*
