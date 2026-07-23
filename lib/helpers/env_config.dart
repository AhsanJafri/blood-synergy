import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get(String key, {required String fallback}) =>
      dotenv.env[key]?.trim().isNotEmpty == true
          ? dotenv.env[key]!.trim()
          : fallback;

  static String get baseUrl =>
      get('BASE_URL', fallback: 'https://bloodsynergybackend.trangotech.dev/api/');

  static String get mainBaseUrl =>
      get('MAIN_BASE_URL', fallback: 'https://web.blood-synergy.com');

  static String get uploadBaseUrl =>
      get('UPLOAD_BASE_URL', fallback: 'https://bloodsynergybackend.trangotech.dev/');

  static String get socketUrl =>
      get('SOCKET_URL', fallback: 'http://31.186.241.24:3016/');

  static String get imageUrl =>
      get('IMAGE_URL', fallback: 'https://netubiebackend.trangotech.dev/');

  static String get fcmToken => get('FCM_TOKEN', fallback: 'sjcn');

  static String get deviceId =>
      get('DEVICE_ID', fallback: 'sdkjcscsdjkcsnd');

  static String get deviceType => get('DEVICE_TYPE', fallback: 'IPhone');

  static String get twilioAccountSid => get('TWILIO_ACCOUNT_SID', fallback: '');

  static String get twilioAuthToken => get('TWILIO_AUTH_TOKEN', fallback: '');

  static String get twilioNumber => get('TWILIO_NUMBER', fallback: '');

  static String get sendgridApiKey => get('SENDGRID_API_KEY',
      fallback: get('TWILIO_SENDGRID_API_KEY', fallback: ''));

  static String get sendgridFromEmail =>
      get('SENDGRID_FROM_EMAIL', fallback: 'synergyblood@gmail.com');

  /// Set MOCK_EMAIL_OTP=true in .env to skip SendGrid and print OTP to console.
  static bool get mockEmailOtp =>
      get('MOCK_EMAIL_OTP', fallback: 'false').toLowerCase() == 'true';
}
