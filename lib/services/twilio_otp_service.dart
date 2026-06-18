import 'dart:math';

import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/env_config.dart';
import 'package:blood_synergy_app/helpers/pending_signup_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class TwilioOtpService {
  static const _otpLength = 6;

  String _generateOtp() {
    final random = Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < _otpLength; i++) {
      buffer.write(random.nextInt(10));
    }
    return buffer.toString();
  }

  TwilioFlutter? _client() {
    final accountSid = EnvConfig.twilioAccountSid;
    final authToken = EnvConfig.twilioAuthToken;
    final fromNumber = EnvConfig.twilioNumber;
    if (accountSid.isEmpty || authToken.isEmpty || fromNumber.isEmpty) {
      return null;
    }
    return TwilioFlutter(
      accountSid: accountSid,
      authToken: authToken,
      twilioNumber: fromNumber,
    );
  }

  Future<AppResultState<String>> sendOtp(String phoneNumber) async {
    final otp = _generateOtp();

    // In DEBUG mode - use mock OTP (no real SMS)
    if (kDebugMode) {
      debugPrint('========================================');
      debugPrint('DEBUG MODE - MOCK OTP: $otp');
      debugPrint('========================================');
      await PendingSignupStorage.saveOtp(otp);
      return AppResultState.success('Code sent! (Dev: $otp)');
    }

    // PRODUCTION mode - use Twilio
    final client = _client();
    if (client == null) {
      return AppResultState.error(
        'Twilio is not configured.',
      );
    }

    try {
      final response = await client.sendSMS(
        toNumber: phoneNumber,
        messageBody:
            'Your Blood Synergy verification code is $otp. It expires in 2 minutes.',
      );

      if (response.responseState != ResponseState.SUCCESS) {
        final message = response.errorData?.message ??
            response.errorData?.toString() ??
            'Failed to send verification SMS';
        return AppResultState.error(message);
      }

      await PendingSignupStorage.saveOtp(otp);
      return AppResultState.success('Verification code sent.');
    } catch (e) {
      return AppResultState.error(e.toString());
    }
  }
}
