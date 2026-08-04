# Blood Synergy API Documentation

Generated and verified from the Flutter client source on 2026-07-26.

This document describes the API contract actually used by the mobile
application. It includes every active route, the complete request URL, HTTP
method, authentication requirement, headers, query parameters or body, the
response fields parsed by the client, example success responses, and relevant
client behavior.

> **Contract boundary:** this repository contains the Flutter client, not the
> backend controllers or an OpenAPI schema. Request fields and parsed response
> fields below are source-confirmed. Example IDs, timestamps, messages, and
> business data are illustrative. Backend-only validation rules and unparsed
> response properties must be confirmed against the backend implementation.

## Total API count

The project actively executes **24 distinct HTTP method + URL combinations**.

| Group | Count |
|---|---:|
| Primary mobile backend | 20 |
| Main website auth synchronization | 2 |
| SendGrid email delivery | 1 |
| Terms and Conditions HTML fetch | 1 |
| **Total active HTTP endpoints** | **24** |

The centralized endpoint registry contains **42 constants**. Of those, **22 are referenced by active call sites** and **20 are currently unused**. The two additional active HTTP endpoints are the direct SendGrid call and the direct Terms and Conditions fetch, bringing the active total to 24.

### Counting rules

- A unique HTTP method + URL is counted once, even when the app can call it multiple times.
- Only explicit HTTP requests in active Dart code are counted.
- Google/Facebook SDK calls are not counted because their HTTP contracts are managed by their packages and are not declared in this codebase.
- General WebView page loads for the chatbot, FAQ, privacy policy, and disclaimer are not counted as APIs.
- Commented-out code, dummy image/content links, socket configuration without a socket call, and endpoint constants with no call site are not counted.

## Base URLs

The values can be overridden through `.env`.

| Placeholder | Environment key | Fallback |
|---|---|---|
| `{BASE_URL}` | `BASE_URL` | `https://bloodsynergybackend.trangotech.dev/api/` |
| `{MAIN_BASE_URL}` | `MAIN_BASE_URL` | `https://web.blood-synergy.com` |
| `{UPLOAD_BASE_URL}` | `UPLOAD_BASE_URL` | `https://bloodsynergybackend.trangotech.dev/` |

Examples below show the complete client-side contract that can be established from request construction, response parsing, and the project models. Placeholder values and messages are illustrative; they are not captured production responses. This repository does not contain the backend implementation or an OpenAPI specification, so fields that the client does not parse cannot be recovered reliably and are called out where applicable.

### Other environment values used by HTTP calls

| Environment key | Fallback | Used by |
|---|---|---|
| `SENDGRID_API_KEY` | Empty | SendGrid Bearer authentication |
| `TWILIO_SENDGRID_API_KEY` | Empty | Legacy fallback for `SENDGRID_API_KEY` |
| `SENDGRID_FROM_EMAIL` | `synergyblood@gmail.com` | SendGrid `from.email` |
| `MOCK_EMAIL_OTP` | `false` | Skips the SendGrid call when `true` |
| `FCM_TOKEN` | `sjcn` | Saved pending-signup model; currently overridden by the registration repository |
| `DEVICE_ID` | `sdkjcscsdjkcsnd` | Saved pending-signup model; currently overridden by the registration repository |
| `DEVICE_TYPE` | `IPhone` | Saved pending-signup model; currently overridden by the registration repository |

### URL construction requirements

- `{BASE_URL}` is concatenated directly with paths such as `customer/login`.
  The configured value must therefore end in `/`.
- `{MAIN_BASE_URL}` is normalized by removing one trailing `/`, then joining it
  to `api/login` or `api/register`.
- `{UPLOAD_BASE_URL}` is used both to construct the Terms URL and to resolve
  relative image paths returned by the backend. It should end in `/`.

## Active route catalog

| # | Method | Complete fallback URL | Auth | Request format | Response format |
|---:|---|---|---|---|---|
| 1 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/login` | No | Multipart form | JSON object envelope |
| 2 | `POST` | `https://web.blood-synergy.com/api/login` | No | Multipart form | Website auth JSON |
| 3 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/register` | No | Multipart form | JSON object envelope |
| 4 | `POST` | `https://web.blood-synergy.com/api/register` | No | Multipart form | Website auth JSON |
| 5 | `POST` | `https://api.sendgrid.com/v3/mail/send` | SendGrid API key | JSON object | Empty success body or SendGrid error JSON |
| 6 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/resend/otp` | Bearer | No body | JSON object envelope |
| 7 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/verify/otp` | Bearer | JSON object | JSON object envelope |
| 8 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/forgot` | No | JSON object | JSON object envelope with token |
| 9 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/change/password` | Bearer | JSON object | JSON object envelope |
| 10 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/logout` | Bearer | `null` | JSON object envelope |
| 11 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/delete/account` | Bearer | `null` | JSON object envelope |
| 12 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/social/login` | No | JSON object | JSON object envelope with token |
| 13 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/profile` | Bearer | No body | JSON object envelope |
| 14 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/profile/update` | Bearer | Multipart form | JSON object envelope |
| 15 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/categories` | Bearer | No body | JSON list envelope |
| 16 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/doctors` | Bearer | No body | JSON list envelope |
| 17 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/doctors/show?doctor_id=10` | Bearer | Query string | JSON object envelope |
| 18 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/supplements` | Bearer | No body | JSON list envelope |
| 19 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/reports?category_id=1` | Bearer | Query string | JSON list envelope |
| 20 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/reports/show?category_id=1&report_id=25` | Bearer | Query string | JSON object envelope |
| 21 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/categories/form?category_id=1` | Bearer | Query string | JSON object envelope |
| 22 | `POST` | `https://bloodsynergybackend.trangotech.dev/api/customer/categories/report` | Bearer | Top-level JSON array | JSON object envelope |
| 23 | `GET` | `https://bloodsynergybackend.trangotech.dev/api/customer/statistics?type=month` | Bearer | Query string | Statistics JSON object |
| 24 | `GET` | `https://bloodsynergybackend.trangotech.dev/term-condition` | No | No body | HTML text |

## Shared backend conventions

### Authentication

Protected endpoints send:

```http
Authorization: Bearer <token>
```

The app normally also requests JSON. Multipart requests let Dio generate the multipart boundary.

Never manually set the multipart boundary. The HTTP client generates it from
the `FormData` payload.

### Headers sent by the current client

The exact client headers vary by transport:

| Request kind | Headers |
|---|---|
| Authenticated `http` request | `Authorization: Bearer <token>`, `Accept: */*`, `Content-Type: application/json` |
| Unauthenticated `http` GET | `Accept: */*`, `Content-Type: application/json`, `X-Requested-With: XMLHttpRequest` |
| Unauthenticated `http` POST | No explicit headers; the social-login body is still JSON-encoded |
| Authenticated Dio request | `Authorization: Bearer <token>`, `Accept: application/json` |
| Unauthenticated Dio request | `Accept: application/json` |
| SendGrid | `Authorization: Bearer <SENDGRID_API_KEY>`, `Content-Type: application/json` |

For Dio `FormData`, Dio supplies `Content-Type: multipart/form-data` with the
boundary. Several JSON bodies are passed to Dio as an already encoded JSON
string; integrations should explicitly use `Content-Type: application/json`
even though the current wrapper does not set that header itself.

### Object response envelope

Endpoints parsed with `BaseResponse` must return `status` and `message`. Other properties are optional:

```json
{
  "status": 200,
  "message": "Success",
  "data": {},
  "token": "optional-token",
  "pagination": {
    "total_pages": 1,
    "page_number": 1
  }
}
```

| Property | Type | Required by parser | Description |
|---|---|---:|---|
| `status` | integer | Yes | Application-level status used to decide success |
| `message` | string | Yes | User-facing success or error message |
| `data` | object or absent | No | Route-specific response object |
| `token` | string or `null` | No | Login, registration, or reset Bearer token |
| `pagination` | object or `null` | No | Optional pagination metadata |
| `pagination.total_pages` | integer or `null` | No | Total available pages |
| `pagination.page_number` | integer or `null` | No | Current page number |

### List response envelope

Endpoints parsed with `BaseListResponse` use an array for `data`:

```json
{
  "status": 200,
  "message": "Success",
  "data": [],
  "token": null,
  "pagination": {
    "total_pages": 1,
    "page_number": 1
  }
}
```

When present, `data` must be an array of JSON objects. The parser tolerates an
absent `data` property, but not `data: null` or a non-array value.

| Property | Type | Required by parser | Description |
|---|---|---:|---|
| `status` | integer | Yes | Application-level status |
| `message` | string | Yes | User-facing status message |
| `data` | array of objects or absent | No | Route-specific result items |
| `token` | string or `null` | No | Supported by the shared parser but unused by current list routes |
| `pagination` | object or `null` | No | Optional pagination metadata |

The app decides success primarily from the JSON `status` field, not only from the HTTP status code.

### Error response contract

For primary-backend routes parsed with `BaseResponse` or `BaseListResponse`,
the minimum client-compatible error body is:

```json
{
  "status": 422,
  "message": "Validation failed"
}
```

The category, doctor-list, and supplement-list handlers explicitly clear the
local login session when the JSON body contains `status: 401`. Most other
routes simply display `message`. The shared parsers require both `status` and
`message`; an HTML error page, an empty response, or a JSON response without
either property becomes a client parsing error.

HTTP status codes and JSON `status` values are separate. Dio calls in this
project accept every HTTP response status and then inspect the JSON body.
Consumers should therefore preserve the JSON envelope on `4xx` responses.

### User data object

Login, registration, social login, and profile responses are expected to use some or all of these fields inside `data`:

```json
{
  "id": 123,
  "first_name": "Ahsan",
  "last_name": "Syed",
  "email": "user@example.com",
  "phone": "+923001234567",
  "image": "uploads/profile.jpg",
  "gender": "male",
  "age": "30",
  "month": null,
  "day": null,
  "year": null,
  "medical_history": "None",
  "fcm_token": "device-push-token",
  "stripe_token": null,
  "device_id": "device-id",
  "device_type": "IPhone",
  "is_verify": 1,
  "is_active": 1,
  "settings": {
    "push_notification": 1
  },
  "created_at": "2026-07-24T10:00:00.000Z",
  "updated_at": "2026-07-24T10:00:00.000Z",
  "deleted_at": null
}
```

| Property | Client type | Nullable | Notes |
|---|---|---:|---|
| `id` | integer | Yes | Customer identifier |
| `first_name` | string | Yes | Given name |
| `last_name` | string | Yes | Family name |
| `email` | string | Yes | Customer email |
| `phone` | string | Yes | International phone value |
| `image` | string | Yes | Absolute URL or a path relative to `{UPLOAD_BASE_URL}` |
| `gender` | string | Yes | Current UI submits values such as `male` |
| `age` | string | Yes | Serialized as a string by the current model |
| `month`, `day`, `year` | string | Yes | Optional date components |
| `medical_history` | string | Yes | Free-text medical history |
| `fcm_token` | string | Yes | Push notification token |
| `stripe_token` | string | Yes | Optional payment token |
| `device_id` | string | Yes | Client/device identifier |
| `device_type` | string | Yes | Examples in the current client are `IPhone` and `iPhone` |
| `is_verify` | integer | Yes | Verification flag |
| `is_active` | integer | Yes | Active-account flag |
| `settings.push_notification` | integer | Yes | Push notification setting |
| `created_at`, `updated_at` | ISO-8601 string | Yes | Parsed as `DateTime` |
| `deleted_at` | string or `null` | Yes | Soft-deletion timestamp when present |

## Current client integration caveats

These points describe the present Flutter implementation and are important
when reproducing or debugging its requests:

- The application globally accepts invalid TLS certificates through
  `MyHttpOverrides`. This should be removed for production because it disables
  normal certificate validation for `dart:io` HTTP traffic.
- The SendGrid API key is read by the mobile client. A production design should
  send OTP mail through a trusted backend so the provider key is not shipped
  inside the application.
- Login and registration send hardcoded device/FCM values from
  `AuthenticationRepository`; the environment-backed values saved before
  signup are not used by the registration request.
- The GET query builder concatenates `key=value` pairs without percent
  encoding. Current query values are integers or `month`/`year`, so they do not
  trigger this limitation.
- Social login parses and requires a token but does not persist that token in
  the current repository method.
- Main website login/registration synchronization is best-effort. Failure does
  not roll back successful primary-backend authentication.
- The current Change Password UI collects an old password, but
  `UpdatePasswordCubit` does not forward it. Both the Change Password and Set
  New Password screens currently call API 9 with `old_password: ""` and
  `is_forgot: "1"`.

## Authentication flow order

### Signup

1. Validate and store the signup fields locally.
2. Call API 5 to send an email OTP.
3. Verify the OTP locally within its two-minute validity window.
4. Call API 3 to create the primary-backend account.
5. Start API 4 in the background to obtain the website auth token.

### Login

1. Call API 1 and persist its mobile Bearer token and user data.
2. Call API 2 and persist a website token when the response contains
   `success: true` and a recognized token property.
3. A failure in step 2 does not fail the mobile login.

### Forgot password

1. Call API 8 and store the returned reset Bearer token.
2. Call API 7 with the backend OTP.
3. Call API 9 with `is_forgot: "1"` and the reset Bearer token.

## Authentication and account APIs

### 1. Customer login

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/login
Content-Type: multipart/form-data
Accept: application/json
```

Authentication: not required.

Request body:

```text
phone=<email-or-phone-entered-by-user>
password=<password>
fcm_token=sjcn
device_id=sdkjcscsdjkcsnd
device_type=IPhone
```

| Field | Type | Required | Source-confirmed behavior |
|---|---|---:|---|
| `phone` | string | Yes | The repository accepts an email or phone string, but the current login UI supplies country code + phone number |
| `password` | string | Yes | Plain-text password inside the TLS-protected multipart request |
| `fcm_token` | string | Yes | Currently hardcoded to `sjcn` in the repository |
| `device_id` | string | Yes | Currently hardcoded to `sdkjcscsdjkcsnd` |
| `device_type` | string | Yes | Currently hardcoded to `IPhone` |

Although the repository parameter is named `phoneEmail`, the request always
sends it under the `phone` field.

Example request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/login' \
  --header 'Accept: application/json' \
  --form 'phone=+923001234567' \
  --form 'password=Password@1' \
  --form 'fcm_token=sjcn' \
  --form 'device_id=sdkjcscsdjkcsnd' \
  --form 'device_type=IPhone'
```

Successful response:

```json
{
  "status": 200,
  "message": "Login successful",
  "data": {
    "id": 123,
    "first_name": "Ahsan",
    "last_name": "Syed",
    "email": "user@example.com",
    "phone": "+923001234567",
    "image": null,
    "gender": "male",
    "age": "30",
    "month": null,
    "day": null,
    "year": null,
    "medical_history": null,
    "fcm_token": "sjcn",
    "stripe_token": null,
    "device_id": "sdkjcscsdjkcsnd",
    "device_type": "IPhone",
    "is_verify": 1,
    "is_active": 1,
    "settings": {
      "push_notification": 1
    },
    "created_at": "2026-07-24T10:00:00.000Z",
    "updated_at": "2026-07-24T10:00:00.000Z",
    "deleted_at": null
  },
  "token": "mobile-bearer-token"
}
```

The client requires a non-null `token` before treating login as successful.

### 2. Main website login synchronization

Complete endpoint:

```http
POST https://web.blood-synergy.com/api/login
Content-Type: multipart/form-data
Accept: application/json
```

Authentication: not required.

Request body:

```text
phone=<email-or-phone-entered-by-user>
email=<email-returned-by-customer-login, when available>
password=<password>
fcm_token=sjcn
device_id=sdkjcscsdjkcsnd
device_type=IPhone
```

The `email` field is conditionally added from the successful primary-login
`data.email`. All remaining fields are copied from API 1.

Example request:

```bash
curl --request POST \
  'https://web.blood-synergy.com/api/login' \
  --header 'Accept: application/json' \
  --form 'phone=+923001234567' \
  --form 'email=user@example.com' \
  --form 'password=Password@1' \
  --form 'fcm_token=sjcn' \
  --form 'device_id=sdkjcscsdjkcsnd' \
  --form 'device_type=IPhone'
```

Successful response:

```json
{
  "success": true,
  "auth_token": "website-auth-token"
}
```

When `success` is `true`, the client accepts the token from the first available field among `auth_token`, `token`, `webAuthToken`, and `access_token`. Failure does not fail the primary mobile login.

### 3. Customer registration

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/register
Content-Type: multipart/form-data
Accept: application/json
```

Authentication: not required.

Request body:

```text
email=user@example.com
first_name=Ahsan
last_name=Syed
phone=+923001234567
password=<password>
device_id=987675rdtcfvghbhn7867
device_type=iPhone
fcm_token=09876ftyvghbhjnkoi8978g67t
```

| Field | Type | Required | Client validation or behavior |
|---|---|---:|---|
| `email` | string | Yes | Client checks a basic email pattern |
| `first_name` | string | Yes | At least 2 alphanumeric/space characters in the client |
| `last_name` | string | Yes | At least 2 alphanumeric/space characters in the client |
| `phone` | string | Yes | International `+` format; current client accepts 11–17 characters |
| `password` | string | Yes | Client requires at least 6 characters |
| `device_id` | string | Yes | Repository currently overrides the model and sends the shown hardcoded value |
| `device_type` | string | Yes | Repository currently sends `iPhone` |
| `fcm_token` | string | Yes | Repository currently sends the shown hardcoded value |

The signup screen first stores these values locally, sends and verifies the
email OTP through SendGrid, and only then invokes this route.

Example request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/register' \
  --header 'Accept: application/json' \
  --form 'email=user@example.com' \
  --form 'first_name=Ahsan' \
  --form 'last_name=Syed' \
  --form 'phone=+923001234567' \
  --form 'password=Password@1' \
  --form 'device_id=987675rdtcfvghbhn7867' \
  --form 'device_type=iPhone' \
  --form 'fcm_token=09876ftyvghbhjnkoi8978g67t'
```

Successful response:

```json
{
  "status": 200,
  "message": "Registration successful",
  "data": {
    "id": 123,
    "first_name": "Ahsan",
    "last_name": "Syed",
    "email": "user@example.com",
    "phone": "+923001234567",
    "image": null,
    "gender": null,
    "age": null,
    "month": null,
    "day": null,
    "year": null,
    "medical_history": null,
    "fcm_token": "09876ftyvghbhjnkoi8978g67t",
    "stripe_token": null,
    "device_id": "987675rdtcfvghbhn7867",
    "device_type": "iPhone",
    "is_verify": 1,
    "is_active": 1,
    "settings": {
      "push_notification": 1
    },
    "created_at": "2026-07-24T10:00:00.000Z",
    "updated_at": "2026-07-24T10:00:00.000Z",
    "deleted_at": null
  },
  "token": "mobile-bearer-token"
}
```

The client requires both `status: 200` and a non-null `token`.

### 4. Main website registration synchronization

Complete endpoint:

```http
POST https://web.blood-synergy.com/api/register
Content-Type: multipart/form-data
Accept: application/json
```

Authentication: not required.

Request body:

```text
email=user@example.com
first_name=Ahsan
last_name=Syed
phone=+923001234567
password=<password>
device_id=987675rdtcfvghbhn7867
device_type=iPhone
fcm_token=09876ftyvghbhjnkoi8978g67t
```

The field contract is identical to API 3.

Example request:

```bash
curl --request POST \
  'https://web.blood-synergy.com/api/register' \
  --header 'Accept: application/json' \
  --form 'email=user@example.com' \
  --form 'first_name=Ahsan' \
  --form 'last_name=Syed' \
  --form 'phone=+923001234567' \
  --form 'password=Password@1' \
  --form 'device_id=987675rdtcfvghbhn7867' \
  --form 'device_type=iPhone' \
  --form 'fcm_token=09876ftyvghbhjnkoi8978g67t'
```

Successful response:

```json
{
  "success": true,
  "auth_token": "website-auth-token"
}
```

This synchronization is started without awaiting it, so its failure does not fail customer registration. The accepted token aliases are the same as API 2.

### 5. Send signup email OTP

Complete endpoint:

```http
POST https://api.sendgrid.com/v3/mail/send
Authorization: Bearer <SENDGRID_API_KEY>
Content-Type: application/json
```

Request body:

```json
{
  "personalizations": [
    {
      "to": [
        {
          "email": "user@example.com"
        }
      ]
    }
  ],
  "from": {
    "email": "synergyblood@gmail.com"
  },
  "subject": "Blood Synergy Verification Code",
  "content": [
    {
      "type": "text/plain",
      "value": "Your Blood Synergy verification code is 123456. It expires in 2 minutes."
    }
  ]
}
```

| Property | Type | Required | Description |
|---|---|---:|---|
| `personalizations` | array | Yes | SendGrid recipient groups |
| `personalizations[].to` | array | Yes | Recipient list |
| `personalizations[].to[].email` | string | Yes | Signup email |
| `from.email` | string | Yes | `SENDGRID_FROM_EMAIL`, defaulting to `synergyblood@gmail.com` |
| `subject` | string | Yes | Fixed subject shown above |
| `content` | array | Yes | Message body variants |
| `content[].type` | string | Yes | Fixed to `text/plain` |
| `content[].value` | string | Yes | Generated six-digit OTP; the current expiry window is two minutes |

Example request:

```bash
curl --request POST \
  'https://api.sendgrid.com/v3/mail/send' \
  --header 'Authorization: Bearer <SENDGRID_API_KEY>' \
  --header 'Content-Type: application/json' \
  --data '{
    "personalizations": [
      {
        "to": [
          {
            "email": "user@example.com"
          }
        ]
      }
    ],
    "from": {
      "email": "synergyblood@gmail.com"
    },
    "subject": "Blood Synergy Verification Code",
    "content": [
      {
        "type": "text/plain",
        "value": "Your Blood Synergy verification code is 123456. It expires in 2 minutes."
      }
    ]
  }'
```

Successful response:

```http
HTTP/1.1 202 Accepted
```

The success body is not used. The app accepts HTTP `200` or `202`.

Example error response consumed by the client:

```json
{
  "errors": [
    {
      "message": "The from address does not match a verified Sender Identity."
    }
  ]
}
```

When `MOCK_EMAIL_OTP=true`, this endpoint is not called; the OTP is stored locally and printed to the debug console.

### 6. Resend backend OTP

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/resend/otp
Authorization: Bearer <token>
```

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/resend/otp' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "OTP resent successfully"
}
```

This route remains wired into the cubit, although the current signup flow normally uses the SendGrid resend operation.

### 7. Verify backend OTP

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/verify/otp
Authorization: Bearer <token>
Content-Type: application/json
```

Request body:

```json
{
  "code": "123456"
}
```

| Field | Type | Required | Description |
|---|---|---:|---|
| `code` | string | Yes | OTP text entered by the user |

Example request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/verify/otp' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
    "code": "123456"
  }'
```

Successful response:

```json
{
  "status": 200,
  "message": "OTP verified successfully"
}
```

### 8. Request password reset

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/forgot
Accept: application/json
```

Authentication: not required.

Request body:

```json
{
  "phone": "+923001234567"
}
```

| Field | Type | Required | Description |
|---|---|---:|---|
| `phone` | string | Yes | International phone number assembled from country code + local number |

Example request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/forgot' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
    "phone": "+923001234567"
  }'
```

Successful response:

```json
{
  "status": 200,
  "message": "OTP sent successfully",
  "token": "reset-bearer-token"
}
```

The app proceeds when `token` is non-null and stores it as the current Bearer token.

### 9. Change or reset password

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/change/password
Authorization: Bearer <token>
Content-Type: application/json
```

Request body variants:

Repository-supported body for a normal password change:

```json
{
  "password": "NewPassword@1",
  "old_password": "OldPassword@1",
  "is_forgot": "0"
}
```

Body currently sent by both password screens:

```json
{
  "password": "NewPassword@1",
  "old_password": "",
  "is_forgot": "1"
}
```

| Field | Type | Required | Description |
|---|---|---:|---|
| `password` | string | Yes | New password |
| `old_password` | string | Conditional | Existing password for a normal change; empty string for reset completion |
| `is_forgot` | string enum | Yes | `"0"` for normal change, `"1"` for forgot-password completion |

No active caller currently passes the normal-change variant. It is shown
because `AuthenticationRepository.changePassword` supports constructing it;
the UI behavior is described in the caveats above.

Example request variants:

Example normal password-change request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/change/password' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
    "password": "NewPassword@1",
    "old_password": "OldPassword@1",
    "is_forgot": "0"
  }'
```

Example forgot-password completion request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/change/password' \
  --header 'Authorization: Bearer <reset-bearer-token>' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
    "password": "NewPassword@1",
    "old_password": "",
    "is_forgot": "1"
  }'
```

Successful response:

```json
{
  "status": 200,
  "message": "Password updated successfully"
}
```

### 10. Customer logout

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/logout
Authorization: Bearer <token>
```

Request body: `null`.

Example request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/logout' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Logged out successfully"
}
```

The app clears local preferences after `status: 200`.

### 11. Delete customer account

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/delete/account
Authorization: Bearer <token>
```

Request body: `null`.

Example request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/delete/account' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Account deleted successfully"
}
```

The app clears in-memory user data and local preferences after success.

### 12. Social login

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/social/login
```

Authentication: not required.

Request body:

```json
{
  "id": "provider-user-id",
  "name": "Ahsan Syed",
  "nickname": "",
  "email": "user@example.com",
  "avatar": "https://provider.example/avatar.jpg",
  "type": "google"
}
```

| Field | Type | Required | Description |
|---|---|---:|---|
| `id` | string | Yes | Provider account identifier |
| `name` | string | Yes | Provider display name; may be empty |
| `nickname` | string | Yes | Current client always sends an empty string |
| `email` | string | Yes | Provider email |
| `avatar` | string | Yes | Provider image URL; may be empty |
| `type` | string enum | Yes | `google` or `facebook` |

Example request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/social/login' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
    "id": "provider-user-id",
    "name": "Ahsan Syed",
    "nickname": "",
    "email": "user@example.com",
    "avatar": "https://provider.example/avatar.jpg",
    "type": "google"
  }'
```

`type` is currently `google` or `facebook`.

Successful response:

```json
{
  "status": 200,
  "message": "Login successful",
  "data": {
    "id": 123,
    "first_name": "Ahsan",
    "last_name": "Syed",
    "email": "user@example.com",
    "phone": "+923001234567",
    "image": "uploads/profile.jpg",
    "gender": "male",
    "age": "30",
    "month": null,
    "day": null,
    "year": null,
    "medical_history": null,
    "fcm_token": "device-push-token",
    "stripe_token": null,
    "device_id": "device-id",
    "device_type": "IPhone",
    "is_verify": 1,
    "is_active": 1,
    "settings": {
      "push_notification": 1
    },
    "created_at": "2026-07-24T10:00:00.000Z",
    "updated_at": "2026-07-24T10:00:00.000Z",
    "deleted_at": null
  },
  "token": "mobile-bearer-token"
}
```

The code requires a non-null token, but unlike normal login it does not currently persist that token. The low-level unauthenticated POST helper also JSON-encodes this request without explicitly setting `Content-Type: application/json`.

## Profile APIs

### 13. Get customer profile

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/profile
Authorization: Bearer <token>
```

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/profile' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Profile fetched successfully",
  "data": {
    "id": 123,
    "first_name": "Ahsan",
    "last_name": "Syed",
    "email": "user@example.com",
    "phone": "+923001234567",
    "image": "uploads/profile.jpg",
    "gender": "male",
    "age": "30",
    "month": null,
    "day": null,
    "year": null,
    "medical_history": "None",
    "fcm_token": "device-push-token",
    "stripe_token": null,
    "device_id": "device-id",
    "device_type": "IPhone",
    "is_verify": 1,
    "is_active": 1,
    "settings": {
      "push_notification": 1
    },
    "created_at": "2026-07-24T10:00:00.000Z",
    "updated_at": "2026-07-24T10:00:00.000Z",
    "deleted_at": null
  }
}
```

### 14. Update customer profile

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/profile/update
Authorization: Bearer <token>
Content-Type: multipart/form-data
```

Request body:

```text
image=<uploaded image.jpg>
gender=male
age=30
medical_history=None
```

| Field | Type | Required by current request | Description |
|---|---|---:|---|
| `image` | file | Yes | Selected image, or bundled placeholder when no path is selected |
| `gender` | string or `null` | Yes | Current gender selection |
| `age` | string or `null` | Yes | Age value |
| `medical_history` | string or `null` | Yes | Free-text medical history |

If no image path is selected, the client uploads `assets/images/profilePlaceHolder.jpg`.

Example request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/profile/update' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json' \
  --form 'image=@/absolute/path/to/image.jpg;type=image/jpeg' \
  --form 'gender=male' \
  --form 'age=30' \
  --form 'medical_history=None'
```

Successful response:

```json
{
  "status": 200,
  "message": "Profile updated successfully",
  "data": {
    "id": 123
  }
}
```

The update response's `data` is not otherwise consumed. On success, the client immediately calls API 13 to refresh and persist the complete profile.

## Categories, doctors, and supplements APIs

### 15. Get categories

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/categories
Authorization: Bearer <token>
```

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/categories' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Categories fetched successfully",
  "data": [
    {
      "id": 1,
      "name": "Lipid Panel",
      "short_code": "LP",
      "icon": "uploads/categories/lipid.png",
      "short_description": "Lipid test reports"
    }
  ]
}
```

Parsed `data[]` fields:

| Field | Type | Nullable | Description |
|---|---|---:|---|
| `id` | integer | No | Category identifier |
| `name` | string | Yes | Display name |
| `short_code` | string | Yes | Category abbreviation |
| `icon` | string | Yes | Path resolved against `{UPLOAD_BASE_URL}` |
| `short_description` | string | Yes | Category summary |

### 16. Get doctors

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/doctors
Authorization: Bearer <token>
```

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/doctors' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Doctors fetched successfully",
  "data": [
    {
      "id": 10,
      "name": "Dr. Jane Doe",
      "city": "Karachi",
      "image": "uploads/doctors/jane.jpg"
    }
  ]
}
```

Parsed `data[]` fields:

| Field | Type | Nullable | Description |
|---|---|---:|---|
| `id` | integer | No | Doctor identifier |
| `name` | string | No | Doctor display name |
| `city` | string | No | City |
| `image` | string | Yes | Relative image path expected by the current list model |

### 17. Get doctor detail

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/doctors/show?doctor_id=10
Authorization: Bearer <token>
```

Query parameters:

| Name | Type | Required | Meaning |
|---|---|---|---|
| `doctor_id` | integer | Yes | Doctor identifier |

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/doctors/show?doctor_id=10' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Doctor fetched successfully",
  "data": {
    "id": 10,
    "name": "Dr. Jane Doe",
    "email": "doctor@example.com",
    "designation": "Nutritionist",
    "phone": "+923001234567",
    "personal_site": "https://doctor.example.com",
    "city": "Karachi",
    "image": "uploads/doctors/jane.jpg",
    "address": "Clinic address",
    "description": "Doctor profile",
    "education": "<p>Qualification details</p>",
    "experience": "10 years",
    "created_at": "2026-07-24T10:00:00.000Z",
    "updated_at": "2026-07-24T10:00:00.000Z"
  }
}
```

Parsed `data` fields:

| Field | Type | Nullable | Description |
|---|---|---:|---|
| `id` | integer or numeric string | No | Invalid/missing values become `0` in the client |
| `name` | string | No | Missing value becomes an empty string |
| `email` | string | Yes | Contact email |
| `designation` | string | Yes | Professional designation |
| `phone` | string | Yes | Contact phone |
| `personal_site` | string | Yes | Personal website |
| `city` | string | Yes | City |
| `image` | string | Yes | Absolute URL or path relative to `{UPLOAD_BASE_URL}` |
| `address` | string | Yes | Street/clinic address |
| `description` | string | Yes | Profile description |
| `education` | string | Yes | HTML-capable education content |
| `experience` | string | Yes | Experience description |
| `created_at`, `updated_at` | string | Yes | Timestamps kept as strings |

### 18. Get supplements

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/supplements
Authorization: Bearer <token>
```

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/supplements' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Supplements fetched successfully",
  "data": [
    {
      "title": "Vitamin C",
      "color": "#F4A261",
      "links": [
        {
          "title": "Vitamin C reference",
          "link": "https://example.com/vitamin-c"
        }
      ]
    }
  ]
}
```

Parsed `data[]` fields:

| Field | Type | Nullable | Description |
|---|---|---:|---|
| `title` | string | No | Supplement group title |
| `color` | string | No | Color value consumed by the UI |
| `links` | array | No | Reference links |
| `links[].title` | string | No | Link label |
| `links[].link` | string | No | Link URL |

## Reports and forms APIs

### 19. Get reports by category

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/reports?category_id=1
Authorization: Bearer <token>
```

Query parameters:

| Name | Type | Required | Meaning |
|---|---|---|---|
| `category_id` | integer | Yes | Category whose reports should be returned |

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/reports?category_id=1' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Reports fetched successfully",
  "data": [
    {
      "category_id": 1,
      "report_id": 25,
      "report_name": "Lipid Report",
      "is_positive": 0,
      "created_at": "2026-07-24T10:00:00.000Z",
      "user": {
        "id": 123,
        "image": "uploads/profile.jpg"
      }
    }
  ]
}
```

Parsed `data[]` fields:

| Field | Type | Nullable | Description |
|---|---|---:|---|
| `category_id` | integer | No | Category identifier |
| `report_id` | integer | No | Report identifier |
| `report_name` | string | No | Report display name |
| `is_positive` | integer | No | Backend result flag |
| `created_at` | string | No | Creation timestamp retained as a string |
| `user.id` | integer | No | Customer identifier |
| `user.image` | string | No | Relative path is resolved against `{UPLOAD_BASE_URL}`; missing values use the app placeholder |

### 20. Get report detail

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/reports/show?category_id=1&report_id=25
Authorization: Bearer <token>
```

Query parameters:

| Name | Type | Required | Meaning |
|---|---|---|---|
| `category_id` | integer | Yes | Report category |
| `report_id` | integer | Yes | Report identifier |

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/reports/show?category_id=1&report_id=25' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Report fetched successfully",
  "data": {
    "id": 25,
    "name": "Lipid Report",
    "created_at": "2026-07-24T10:00:00.000Z",
    "updated_at": "2026-07-24T10:00:00.000Z",
    "form_answers": [
      {
        "form_id": 5,
        "answer": "120",
        "category_id": 1,
        "customer_id": 123,
        "is_positive": 0,
        "label": "LDL",
        "short_code": "LDL",
        "unit": "mg/dL",
        "range": "0-129"
      }
    ],
    "patterns": {
      "primary": [
        {
          "id": 7,
          "title": "Primary pattern",
          "color": "#FF0000",
          "remarks": "Example remarks",
          "symptoms": "Example symptoms",
          "result": "25%",
          "pattern_color": "red"
        }
      ],
      "secondary": [],
      "tertiary": []
    }
  }
}
```

Parsed `data` fields:

| Field | Type | Nullable | Description |
|---|---|---:|---|
| `id` | integer | Yes | Report identifier |
| `name` | string | Yes | Report name |
| `created_at`, `updated_at` | ISO-8601 string | Yes | Parsed as `DateTime` |
| `form_answers` | array | Yes | Submitted form values; absent becomes an empty list |
| `patterns` | object | Yes | Pattern groups |
| `patterns.primary` | array | Yes | Primary patterns |
| `patterns.secondary` | array | Yes | Secondary patterns |
| `patterns.tertiary` | array | Yes | Tertiary patterns |

Parsed `form_answers[]` fields:

| Field | Type | Nullable |
|---|---|---:|
| `form_id` | integer | Yes |
| `answer` | string | Yes |
| `category_id` | integer | Yes |
| `customer_id` | integer | Yes |
| `is_positive` | integer | Yes |
| `label` | string | Yes |
| `short_code` | string | Yes |
| `unit` | string | Yes |
| `range` | string | Yes |

Parsed fields in every primary, secondary, or tertiary pattern:

| Field | Type | Nullable |
|---|---|---:|
| `id` | integer | Yes |
| `title` | string | Yes |
| `color` | string | Yes |
| `remarks` | string | Yes |
| `symptoms` | string | Yes |
| `result` | string | Yes |
| `pattern_color` | string | Yes |

### 21. Get category form

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/categories/form?category_id=1
Authorization: Bearer <token>
```

Query parameters:

| Name | Type | Required | Meaning |
|---|---|---|---|
| `category_id` | integer | Yes | Category whose form should be returned |

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/categories/form?category_id=1' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Form fetched successfully",
  "data": {
    "id": 1,
    "name": "Lipid Panel",
    "short_description": "Enter the values from the test",
    "forms": [
      {
        "id": 5,
        "category_id": 1,
        "label": "LDL",
        "unit": "mg/dL",
        "is_ratio": 0
      }
    ]
  }
}
```

Parsed `data` fields:

| Field | Type | Nullable | Description |
|---|---|---:|---|
| `id` | integer | No | Category/form identifier |
| `name` | string | Yes | Form title |
| `short_description` | string | Yes | Instructions or summary |
| `forms` | array | Yes | Input definitions; absent becomes an empty list |
| `forms[].id` | integer | No | Form input identifier |
| `forms[].category_id` | integer | Yes | Owning category |
| `forms[].label` | string | Yes | User-visible input label |
| `forms[].unit` | string | Yes | Measurement unit |
| `forms[].is_ratio` | integer | Yes | Ratio-input flag |

### 22. Create category report

Complete endpoint:

```http
POST https://bloodsynergybackend.trangotech.dev/api/customer/categories/report
Authorization: Bearer <token>
Content-Type: application/json
```

Request body:

The body is a top-level array. `id`, `value`, and `category_id` are serialized as strings:

```json
[
  {
    "id": "5",
    "value": "120",
    "category_id": "1"
  },
  {
    "id": "6",
    "value": "50",
    "category_id": "1"
  }
]
```

| Field | JSON type sent | Required | Description |
|---|---|---:|---|
| `[].id` | string | Yes | Form input identifier converted to a string |
| `[].value` | string | Yes | User-entered test value |
| `[].category_id` | string | Yes | Category identifier converted to a string |

Example request:

```bash
curl --request POST \
  'https://bloodsynergybackend.trangotech.dev/api/customer/categories/report' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '[
    {
      "id": "5",
      "value": "120",
      "category_id": "1"
    },
    {
      "id": "6",
      "value": "50",
      "category_id": "1"
    }
  ]'
```

Successful response:

```json
{
  "status": 200,
  "message": "Report created successfully",
  "data": {
    "report_id": 25
  }
}
```

The client requires `data` to be a JSON object because the shared `BaseResponse` parser casts it to a map.

## Statistics API

### 23. Get statistics

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/api/customer/statistics?type=month
Authorization: Bearer <token>
```

Query parameters:

| Name | Type | Required | Accepted by UI | Meaning |
|---|---|---|---|---|
| `type` | string | Yes | `month`, `year` | Grouping period |

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/api/customer/statistics?type=month' \
  --header 'Authorization: Bearer <token>' \
  --header 'Accept: application/json'
```

Successful response:

```json
{
  "status": 200,
  "message": "Statistics fetched successfully",
  "data": {
    "January": [
      {
        "pattern_id": 7,
        "report_id": 25,
        "result": "25%",
        "title": "Primary pattern",
        "created_at": "2026-01-24T10:00:00.000Z",
        "pattern_color": "#FF0000",
        "pattern_range_color": "red"
      }
    ]
  }
}
```

For yearly mode, the keys inside `data` are expected to be year strings rather than month names.

Parsed fields in each `data.<period>[]` item:

| Field | Type | Nullable | Description |
|---|---|---:|---|
| `pattern_id` | integer | Yes | Pattern identifier |
| `report_id` | integer | Yes | Report identifier |
| `result` | string | Yes | Numeric percentage string; the UI removes `%` and parses it as a number |
| `title` | string | Yes | Pattern title |
| `created_at` | ISO-8601 string | Yes | Parsed as `DateTime` |
| `pattern_color` | string | Yes | Hex color expected by the chart |
| `pattern_range_color` | string | Yes | Range/color label |

## Content API

### 24. Get Terms and Conditions HTML

Complete endpoint:

```http
GET https://bloodsynergybackend.trangotech.dev/term-condition
```

Authentication: not required.

Request body: none.

Example request:

```bash
curl --request GET \
  'https://bloodsynergybackend.trangotech.dev/term-condition' \
  --header 'Accept: text/html'
```

Successful response:

```http
HTTP/1.1 200 OK
Content-Type: text/html

<!doctype html>
<html>
  <body>
    <h1>Terms and Conditions</h1>
    ...
  </body>
</html>
```

The response is read as plain text and must be non-empty. The HTML is then supplied to an in-app WebView.

## Declared but unused endpoint constants

These **20 endpoints are present in `NetworkEndpoint.dart` but have no active call site**, so they are not included in the total of 24:

| Endpoint constant | Path |
|---|---|
| `getRecommendations` | `customer/reports/recommendation` |
| `exploreFeeds` | `customer/explore-feeds` |
| `getAllMatches` | `customer/matches` |
| `unmatch` | `customer/matches/un-match` |
| `follow` | `customer/follow` |
| `updateAnswers` | `customer/question-answers/upload` |
| `getVenues` | `customer/venues` |
| `bookTable` | `customer/venues/book-table` |
| `addCard` | `customer/cards/add` |
| `cardList` | `customer/cards` |
| `defaultCard` | `customer/cards/default` |
| `deleteCard` | `customer/cards/delete` |
| `getQuestions` | `customer/question-answers` |
| `getAllChats` | `customer/chats` |
| `getNotifications` | `customer/notifications` |
| `blockUser` | `customer/blocks/add` |
| `getBlockUsers` | `customer/blocks` |
| `unblockUser` | `customer/blocks/unblock` |
| `uploadMsgFile` | `customer/messages/upload` |
| `unblockAllUsers` | `customer/blocks/unblock-all` |

Their HTTP methods, request bodies, and response schemas cannot be determined reliably from the current project because nothing invokes them.

## Source map

| Concern | Main source files |
|---|---|
| Endpoint constants | `lib/network_helpers/NetworkEndpoint.dart` |
| Base URLs and headers | `lib/helpers/env_config.dart`, `lib/network_helpers/serverSettings.dart` |
| HTTP execution | `lib/network_helpers/network.dart` |
| Authentication/account contracts | `lib/Repositories/AuthenticationRepository.dart` |
| Profile contracts | `lib/Repositories/ProfileRepository.dart` |
| Categories/doctors/supplements | `lib/Repositories/HomeRepository.dart` |
| Reports/forms | `lib/Repositories/ReportsRepository.dart` |
| Statistics | `lib/Repositories/StatisticsRepository.dart` |
| SendGrid | `lib/services/sendgrid_otp_service.dart` |
| Terms content | `lib/views/screens/TermsCondition.dart` |
| Response field shapes | `lib/Models/*.dart`, `lib/helpers/BaseModel.dart` |
| Client validation | `lib/helpers/validator.dart`, relevant screen and Cubit files |
| Signup/OTP sequencing | `lib/Cubits/signup_cubit/signup_cubit.dart`, `lib/helpers/pending_signup_storage.dart` |
| Login/password sequencing | `lib/Cubits/login_cubit/login_cubit.dart`, `lib/Cubits/update_password_cubit/update_password_cubit.dart` |
