# Blood Synergy — App Overview

**Last updated:** October 4, 2026  
**App Store status:** Version **1.0 — Waiting for Review**

---

## What it is

Blood Synergy is a mobile wellness app for tracking lab markers, viewing educational insights, finding practitioners, and using an AI chatbot for lab-related questions. Content is **educational only** and is **not medical advice**.

| Layer | Technology |
|---|---|
| Mobile app | **Flutter** (iOS) |
| Backend API | **PHP** (`https://web.blood-synergy.com/api/`) |
| Email / OTP | **SendGrid** |
| In-app web content | **WebView** (`flutter_inappwebview`) on selected screens |

---

## App Store review

| Item | Value |
|---|---|
| App name | BloodSynergy |
| Version | 1.0 |
| Status | **Waiting for Review** |
| Demo account (submitted to Apple) | **Email:** `demo@gmail.com` |
| | **Password:** `demo12345` |

### Suggested reviewer path
1. Log in with the demo account above  
2. Accept disclaimer (if shown)  
3. Home → categories / lab panels  
4. Practitioners → doctor detail  
5. Profile → Privacy Policy, FAQs, Delete account  

---

## WebView screens (3)

These screens load web content inside the Flutter app via WebView:

| # | Screen | Where in the app | URL / content |
|---|---|---|---|
| 1 | **Chatbot** | Home → chatbot icon | `https://web.blood-synergy.com/chatbot.php` (auth cookie from mobile JWT) |
| 2 | **Disclaimer** | After profile setup / before dashboard | `https://web.blood-synergy.com/disclaimer.php` |
| 3 | **Privacy Policy** | Profile → Privacy Policy (also linked from signup) | `https://web.blood-synergy.com/privacy-policy` (fetched then shown in WebView) |

> **Note:** Terms & Conditions (Profile / signup) also renders HTML in a WebView (`term-condition` endpoint), similar to Privacy Policy.

---

## Main native features (Flutter)

- Splash → Login / Signup (email OTP via SendGrid before register)
- Forgot password (email OTP via SendGrid)
- Home dashboard with lab categories
- Lipid / lab panels, reports, statistics
- Practitioners list & doctor detail
- Profile, edit profile, change password, FAQs (in-app), logout, delete account
- Push notification preference (local toggle)

---

## Backend & email

- **API base:** `https://web.blood-synergy.com/api/`
- **Language:** PHP
- **Auth:** Customer login/register, bearer token for protected routes
- **SendGrid:** Used for signup verification OTP and password-reset OTP emails

---

## Privacy & compliance notes (for reviewers)

- Privacy policy URL: `https://web.blood-synergy.com/privacy-policy`
- Account deletion: Profile → **Delete account**
- No in-app purchases / subscriptions in the iOS app
- Declared as **not** a regulated medical device (educational / wellness tracking)
- Camera / photo library access: optional profile photo & lab image upload only

---

## Quick reference

```
Demo login:  demo@gmail.com / demo12345
Stack:       Flutter + PHP + SendGrid
WebViews:    Chatbot · Disclaimer · Privacy Policy
Store:       1.0 Waiting for Review
```
