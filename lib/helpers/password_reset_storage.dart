import 'package:blood_synergy_app/helpers/AppPreference.dart';

class PasswordResetStorage {
  static const _resetTokenKey = 'password_reset_token';
  static const _resetEmailKey = 'password_reset_email';
  static const _otpKey = 'password_reset_otp';
  static const _otpExpiryKey = 'password_reset_otp_expiry_ms';
  static const _otpVerifiedKey = 'password_reset_otp_verified';

  static const otpValidity = Duration(minutes: 2);

  static Future<void> saveSession({
    required String resetToken,
    required String email,
  }) async {
    await UserPref.prefs.setString(_resetTokenKey, resetToken);
    await UserPref.prefs.setString(_resetEmailKey, email);
    await UserPref.prefs.setBool(_otpVerifiedKey, false);
  }

  static String? get resetToken => UserPref.prefs.getString(_resetTokenKey);

  static String? get email => UserPref.prefs.getString(_resetEmailKey);

  static Future<void> saveOtp(String otp) async {
    final expiry = DateTime.now().add(otpValidity).millisecondsSinceEpoch;
    await UserPref.prefs.setString(_otpKey, otp);
    await UserPref.prefs.setInt(_otpExpiryKey, expiry);
    await UserPref.prefs.setBool(_otpVerifiedKey, false);
  }

  static bool isOtpExpired() {
    final expiry = UserPref.prefs.getInt(_otpExpiryKey);
    if (expiry == null) return true;
    return DateTime.now().millisecondsSinceEpoch > expiry;
  }

  static bool verifyOtp(String code) {
    final stored = UserPref.prefs.getString(_otpKey);
    if (stored == null || stored.isEmpty || isOtpExpired()) return false;
    return stored.trim() == code.trim();
  }

  static Future<void> markOtpVerified() async {
    await UserPref.prefs.setBool(_otpVerifiedKey, true);
  }

  static bool get isOtpVerified =>
      UserPref.prefs.getBool(_otpVerifiedKey) ?? false;

  static Future<void> clear() async {
    await UserPref.prefs.remove(_resetTokenKey);
    await UserPref.prefs.remove(_resetEmailKey);
    await UserPref.prefs.remove(_otpKey);
    await UserPref.prefs.remove(_otpExpiryKey);
    await UserPref.prefs.remove(_otpVerifiedKey);
  }
}
