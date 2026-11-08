# Client update — App Store rejection fixes

Hi,

We’ve completed the App Store review fixes in the iOS app. Here’s what was done:

### 1. Privacy / AI consent (Guidelines 5.1.1 & 5.1.2)
- Added a consent screen **before** the chatbot opens.
- It clearly names **Google Gemini**, lists what may be sent (messages, lab values, lab-report images, sex/gender if set on the profile, and session auth), and explains how it’s used.
- Users must tap **Allow** to continue, or **Don’t Allow** to go back without sharing any chatbot data.
- The consent screen links to the in-app **Privacy Policy**.
- FAQs were updated to match this disclosure.

**Your action still needed:** Paste the Gemini / retention wording from `PRIVACY_POLICY_AI_ADDENDUM.md` onto the live privacy policy at https://web.blood-synergy.com/privacy-policy, after confirming your Gemini / Google Cloud setup is on a paid API path that does not train on user prompts.

### 2. Medical citations (Guideline 1.4.1)
- Added **Sources & Citations** under Profile (last tab), with tappable medical reference links (NIH/MedlinePlus, CDC, AHA, PubMed, etc.).
- Citations also appear on **Recommendations**, after **Pattern Results** on reports, and via **Sources** in the chatbot.
- Clear “educational / not medical advice” messaging is included.

### 3. Business model (Guideline 2.1(b))
- Prepared the App Store reply confirming there is **no paid content, no subscription, and no In-App Purchase** in this iOS app (all core features are free for registered users).
- **Important:** Do not send Apple a reply that mentions an in-app subscription unless you actually ship Apple IAP — that would conflict with how the app works today.

### 4. iPad layout (Guideline 4)
- Improved iPad readability (content width, text scaling, landscape support, bottom-tab highlighting).
- Tested on **iPad Air 11"** (the device Apple used in review) and iPhone.

### 5. Wellness tab layout
- Fixed the Wellness layout boxes: category titles no longer truncate awkwardly, cards are balanced and tappable, and the header/layout overall looks cleaner.

---

**Next steps for you**
1. Update the live privacy policy (see addendum above).
2. We’ll upload a new build and you can paste the Resolution Center replies from `APP_STORE_REVIEW_REPLY_OCT2026.md`.
3. Resubmit for review with the demo account notes.

Happy to walk you through the new screens on a quick call if useful.

Thanks  
[Your name]
