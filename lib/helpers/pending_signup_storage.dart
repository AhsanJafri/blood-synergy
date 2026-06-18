import 'dart:convert';

import 'package:blood_synergy_app/Models/SignupReqModel.dart';
import 'package:blood_synergy_app/helpers/AppPreference.dart';

class PendingSignupStorage {
  static const _pendingSignupKey = 'pending_signup';
  static const _pendingOtpKey = 'pending_signup_otp';
  static const _otpExpiryKey = 'pending_signup_otp_expiry_ms';

  static const otpValidity = Duration(minutes: 2);

  static Future<void> savePendingSignup(SignupRequest request) async {
    await UserPref.prefs.setString(
      _pendingSignupKey,
      jsonEncode(request.toJson()),
    );
  }

  static Future<SignupRequest?> loadPendingSignup() async {
    final raw = UserPref.prefs.getString(_pendingSignupKey);
    if (raw == null || raw.isEmpty) return null;
    return SignupRequest.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static Future<void> saveOtp(String otp) async {
    final expiry = DateTime.now().add(otpValidity).millisecondsSinceEpoch;
    await UserPref.prefs.setString(_pendingOtpKey, otp);
    await UserPref.prefs.setInt(_otpExpiryKey, expiry);
  }

  static bool isOtpExpired() {
    final expiry = UserPref.prefs.getInt(_otpExpiryKey);
    if (expiry == null) return true;
    return DateTime.now().millisecondsSinceEpoch > expiry;
  }

  static bool verifyOtp(String code) {
    final stored = UserPref.prefs.getString(_pendingOtpKey);
    if (stored == null || stored.isEmpty) return false;
    if (isOtpExpired()) return false;
    return stored.trim() == code.trim();
  }

  static Future<void> clear() async {
    await UserPref.prefs.remove(_pendingSignupKey);
    await UserPref.prefs.remove(_pendingOtpKey);
    await UserPref.prefs.remove(_otpExpiryKey);
  }
}
