# Forgot Password Flow

## Status

The forgot-password flow is implemented in the Flutter application. It allows a customer to enter a registered phone number, verify an OTP, and set a new password.

The API base URL is read from `BASE_URL` in `.env`. The current fallback is:

```text
https://bloodsynergybackend.trangotech.dev/api/
```

## User flow

```text
Login
  -> Recover Password?
  -> Enter registered phone number
  -> POST customer/forgot
  -> Enter or resend the 6-digit OTP
  -> POST customer/verify/otp
  -> Enter and confirm the new password
  -> POST customer/change/password
  -> Password updated
```

The forgot-password API returns a token. The app stores this token and sends it as a Bearer token when resending/verifying the OTP and changing the password.

## APIs

### 1. Request password reset

```http
POST {BASE_URL}/customer/forgot
```

Authentication: Not required

Request:

```json
{
  "phone": "+923001234567"
}
```

Expected successful response shape:

```json
{
  "status": 200,
  "message": "OTP sent successfully",
  "token": "reset-token"
}
```

The app proceeds to OTP verification when the response contains a non-null `token`.

### 2. Resend OTP

```http
GET {BASE_URL}/customer/resend/otp
Authorization: Bearer <reset-token>
```

The OTP screen enables resend after a two-minute countdown. A `status` of `200` is treated as success.

### 3. Verify OTP

```http
POST {BASE_URL}/customer/verify/otp
Authorization: Bearer <reset-token>
Content-Type: application/json
```

Request:

```json
{
  "code": "123456"
}
```

A `status` of `200` opens the Set New Password screen.

### 4. Set new password

```http
POST {BASE_URL}/customer/change/password
Authorization: Bearer <reset-token>
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
- `lib/views/screens/otpVerification/otpVerification.dart` - OTP verification and resend.
- `lib/views/screens/Password/SetNewPassword.dart` - new-password form.
- `lib/Cubits/login_cubit/login_cubit.dart` - phone validation and reset request state.
- `lib/Cubits/signup_cubit/signup_cubit.dart` - OTP actions and state.
- `lib/Cubits/update_password_cubit/update_password_cubit.dart` - password update state.
- `lib/Repositories/AuthenticationRepository.dart` - forgot-password API calls.
- `lib/network_helpers/NetworkEndpoint.dart` - endpoint paths.

## Known implementation gaps

- The confirmation password is currently ignored because `password` is passed twice to validation.
- Password mismatch and the password rules shown on the screen are not enforced correctly.
- After a successful reset, the screen is popped instead of explicitly navigating to Login.
- The reset token is persisted as the application's normal authentication token before OTP verification; this should match the backend's intended security design.
- There are currently no automated tests for this flow.
