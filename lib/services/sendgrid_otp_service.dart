import 'dart:math';

import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/env_config.dart';
import 'package:blood_synergy_app/helpers/pending_signup_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:blood_synergy_app/helpers/password_reset_storage.dart';

class SendGridOtpService {
  static const _otpLength = 6;
  static const _sendGridUrl = 'https://api.sendgrid.com/v3/mail/send';

  String _generateOtp() {
    final random = Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < _otpLength; i++) {
      buffer.write(random.nextInt(10));
    }
    return buffer.toString();
  }

  String _otpMessage(String otp) =>
      'Your Blood Synergy verification code is $otp. It expires in 2 minutes.';

  Future<AppResultState<String>> sendOtp(
    String email, {
    bool forPasswordReset = false,
  }) async {
    final otp = _generateOtp();
    debugPrint(
        '[SENDGRID_OTP] Sending ${forPasswordReset ? 'password reset' : 'signup'} OTP to $email');

    if (EnvConfig.mockEmailOtp) {
      debugPrint('========================================');
      debugPrint('MOCK EMAIL OTP: $otp');
      debugPrint('Would send to: $email');
      debugPrint('========================================');
      await _saveOtp(otp, forPasswordReset);
      return AppResultState.success('Code sent to your email! (Mock: $otp)');
    }

    final apiKey = EnvConfig.sendgridApiKey;
    if (apiKey.isEmpty) {
      return AppResultState.error(
        'SendGrid is not configured. Add SENDGRID_API_KEY to .env',
      );
    }

    try {
      final dio = Dio();
      final response = await dio.post(
        _sendGridUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
        data: {
          'personalizations': [
            {
              'to': [
                {'email': email},
              ],
            },
          ],
          'from': {'email': EnvConfig.sendgridFromEmail},
          'subject': 'Blood Synergy Verification Code',
          'content': [
            {
              'type': 'text/plain',
              'value': _otpMessage(otp),
            },
          ],
        },
      );

      debugPrint('[SENDGRID_OTP] HTTP status: ${response.statusCode}');
      debugPrint('[SENDGRID_OTP] Response: ${response.data}');

      if (response.statusCode == 202 || response.statusCode == 200) {
        await _saveOtp(otp, forPasswordReset);
        return AppResultState.success('Verification code sent to your email.');
      }

      final errorBody = response.data;
      final message = errorBody is Map
          ? errorBody['errors']?.toString() ?? errorBody.toString()
          : errorBody?.toString() ?? 'Failed to send verification email';
      return AppResultState.error(message);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? data['errors']?.toString() ?? e.message
          : e.message ?? 'Failed to send verification email';
      return AppResultState.error(message.toString());
    } catch (e) {
      return AppResultState.error(e.toString());
    }
  }

  Future<void> _saveOtp(String otp, bool forPasswordReset) {
    return forPasswordReset
        ? PasswordResetStorage.saveOtp(otp)
        : PendingSignupStorage.saveOtp(otp);
  }
}
