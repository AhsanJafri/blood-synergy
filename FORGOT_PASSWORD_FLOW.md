# Forgot Password Flow

## Status

The forgot-password flow is implemented in the Flutter application. It allows a customer to enter their registered email, receive a six-digit OTP at that email, verify that OTP locally, and set a new password.

The API base URL is read from `BASE_URL` in `.env`. The current fallback is:

```text
https://web.blood-synergy.com/api/
```

## User flow

```text
Login
  -> Recover Password?
  -> Enter registered email
  -> POST customer/forgot
  -> Read email and reset token from the response
  -> Send or resend a 6-digit OTP through SendGrid
  -> Verify the OTP locally on the device
  -> Enter and confirm the new password
  -> POST customer/change/password
  -> Password updated
```

The forgot-password API returns the customer email and a backend reset token. The app sends the locally generated OTP to that email through SendGrid. The backend reset token is kept separately and is sent as a Bearer token only when changing the password after local OTP verification.

## APIs

### 1. Request password reset

```http
POST {BASE_URL}/customer/forgot
```

Authentication: Not required

Request:

```json
{
  "email": "customer@example.com"
}
```

Expected successful response shape:

```json
{
  "status": 200,
  "message": "OTP sent successfully",
  "data": {
    "email": "customer@example.com",
    "email": "customer@example.com"
  },
  "token": "backend-reset-token"
}
```

The app stores the email and backend reset token, then sends a newly generated six-digit OTP to the returned email through SendGrid.

### 2. Send or resend email OTP

The app uses the existing `SendGridOtpService` to send the six-digit OTP. The OTP is stored locally and expires after two minutes. Resend is also sent through SendGrid after the countdown; the backend `resend/otp` endpoint is not used for this flow.

### 3. Verify OTP locally

The app compares the entered code with the locally stored code and checks the two-minute expiry. A match opens the Set New Password screen. The backend `verify/otp` endpoint is not used for this flow.

### 4. Set new password

```http
POST {BASE_URL}/customer/change/password
Authorization: Bearer <backend-reset-token>
```

Request:

```json
{
  "password": "NewPassword@1",
  "old_password": "",
  "is_forgot": "1"
}
```

A `status` of `200` is displayed as a successful password update.

## Main implementation files

- `lib/views/screens/loginn/loginScreen.dart` - recovery entry point.
- `lib/views/screens/Password/ForgotPassword.dart` - phone-number form.
- `lib/views/screens/otpVerification/otpVerification.dart` - email OTP verification and resend.
- `lib/views/screens/Password/SetNewPassword.dart` - new-password form.
- `lib/Cubits/login_cubit/login_cubit.dart` - phone validation and reset request state.
- `lib/Cubits/signup_cubit/signup_cubit.dart` - OTP actions and state.
- `lib/Cubits/update_password_cubit/update_password_cubit.dart` - password update state.
- `lib/Repositories/AuthenticationRepository.dart` - forgot-password API calls.
- `lib/network_helpers/NetworkEndpoint.dart` - endpoint paths.

## Known implementation gaps

- After a successful reset, the screen is popped instead of explicitly navigating to Login.
- The reset token and OTP are stored locally for the duration of the reset session.
- SendGrid must be configured with `SENDGRID_API_KEY` and `SENDGRID_FROM_EMAIL`.
