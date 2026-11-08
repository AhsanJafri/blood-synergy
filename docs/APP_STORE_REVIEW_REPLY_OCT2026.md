# App Store Connect — Resolution Center replies

**Submission ID:** `31dd8851-e7a9-479f-a042-94ac710c0329`  
**Previous version reviewed:** 1.0 (12)  
**Review device:** iPad Air 11-inch (M3)

Upload the new build first, then paste each reply below into Resolution Center. Also paste the short Notes into **App Review Information**.

Demo account: `demo@gmail.com` / `demo12345`

---

## Reply 1 — Guidelines 5.1.1(i) & 5.1.2(i) (AI / privacy)

```
Thank you for the feedback. We have updated the app as follows:

1. Before the chatbot opens, users now see an explicit consent screen that:
   - Discloses what data may be sent: chat messages; lab values; lab-report images the user chooses to upload; sex/gender if set on the profile; and the account authentication token for the session
   - Identifies who receives the data: Blood Synergy’s chatbot service at web.blood-synergy.com, which uses Google’s Gemini API to generate educational responses. Identifying details are removed before AI processing
   - States that Google processes this data under its Gemini API terms with safeguards appropriate to that service, and that data is not sold
   - Requires the user to tap Allow before any chatbot session is established
   - Allows the user to tap Don’t Allow and return without sharing data
   - Links to the in-app Privacy Policy from the consent screen

2. The Privacy Policy is available in-app (Profile → Privacy Policy) and at https://web.blood-synergy.com/privacy-policy. It describes account data, lab values, sex, chatbot / Gemini processing, retention, and related practices.

3. In-app FAQs also describe chatbot data sharing and Gemini at a high level.

How to verify: Log in with demo@gmail.com / demo12345 → Home → chatbot icon → review the consent screen (names Google Gemini) → Allow → chatbot loads. Don’t Allow returns without opening the chatbot. Privacy Policy: Profile → Privacy Policy.
```

---

## Reply 2 — Guideline 1.4.1 (Citations)

```
Thank you for the feedback. We added easy-to-find medical citations throughout the app:

- Profile → Sources & Citations, including general foundations (NIH/MedlinePlus, CDC, American Heart Association, NHLBI) plus pattern-specific research links for Energy, Digestion, Inflammation, Blood Sugar, Hypothyroid, Hashimoto’s Thyroid, Brain Health, Macrocytic Anemia, and Hepatic
- Citations on the Recommendations screen where educational tips appear
- Citations on the report / Pattern Results screen after educational pattern analysis
- Chatbot App Bar → Sources, plus an on-screen educational disclaimer that content is not medical advice

All health-related content remains educational only and is not medical advice. Users are directed to consult a licensed clinician.

How to verify: Log in → Profile → Sources & Citations (expand any pattern). Also open Recommendations or a report’s Pattern Results, or Chatbot → Sources.
```

---

## Reply 3 — Guideline 2.1(b) (Business model / paid content)

```
Blood Synergy does not sell digital content, subscriptions, or unlockable features inside the iOS app, and does not use In-App Purchase.

Answers to your questions:

1. Who are the users that will use the paid content in the app?
There is no paid content in the app. All core features are free for registered users (adults 18+ who upload or enter their own lab values for educational pattern analysis).

2. Where can users purchase the content that can be accessed in the app?
Users cannot purchase content in the app. Optional external educational / wellness links (for example seminars or informational sites) open outside the app in Safari and are not required to use Blood Synergy. Those external pages show free educational modules.

3. What specific types of previously purchased content can a user access in the app?
None. The app does not unlock previously purchased digital content.

4. What paid content, subscriptions, or features are unlocked within the app that do not use In-App Purchase?
None.

5. What paid content can user purchase outside app?
The app does not provide a storefront for digital goods. Any external website a user visits independently may have its own products; those purchases are not unlocked or managed by this iOS app.

Demo account for review: demo@gmail.com / demo12345
```

---

## Reply 4 — Guideline 4 (iPad layout)

```
Thank you for the feedback. We revised iPad layout and readability for iPadOS, including iPad Air 11-inch:

- Tablet-aware ScreenUtil design size and text adaptation
- Content width constrained on large screens so UI is not overstretched
- Clearer bottom navigation labels/icons on tablets
- Landscape supported on iPad for easier reading
- Fixed incorrect selected-tab highlighting on Practitioners / Profile
- Compact, consistent headers on Home, Wellness, and Practitioners
- Wellness category cards updated for readable titles and improved layout

Please re-test the new build on iPad Air 11-inch.
```

---

## App Review Information — Notes (paste into Notes field)

```
Demo: demo@gmail.com / demo12345

Verification path:
1) Login → Home → Chatbot icon → Gemini consent (Allow / Don’t Allow) → Privacy Policy link on consent screen
2) Profile → Sources & Citations (general + pattern-specific research)
3) Recommendations / Report Pattern Results (citations)
4) Chatbot → Sources
5) Profile → Privacy Policy (https://web.blood-synergy.com/privacy-policy)

Business model: No IAP, no subscriptions, no paid digital unlocks in this iOS app. All core features are free for registered users.

Content: Educational only — not medical advice.
iPad: Layout improved for iPad Air 11" (portrait + landscape).
```
