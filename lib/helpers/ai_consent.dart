import 'package:blood_synergy_app/helpers/AppPreference.dart';

/// Stores whether the user has consented to share data with the AI chatbot.
/// Bumped key so users re-see consent after Gemini-specific disclosure update.
class AiConsent {
  static const _key = 'ai_chatbot_consent_v2';

  static bool get hasConsented => UserPref.prefs.getBool(_key) ?? false;

  static Future<void> setConsented(bool value) async {
    await UserPref.prefs.setBool(_key, value);
  }

  static Future<void> clear() async {
    await UserPref.prefs.remove(_key);
  }
}
