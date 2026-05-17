// social_media_repository.dart
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialMediaRepository {

  // final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Future<AccessToken?> signInWithFacebook() async {
  //   final result = await _facebookAuth.login(permissions: ['email']);
  //   if (result.status == LoginStatus.success) {
  //     return result.accessToken;
  //   }
  //   return null;
 // }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      _googleSignIn.authorizationClient.authorizationForScopes( ['email']);
      final googleSignInAccount = await _googleSignIn.authenticate();
      return googleSignInAccount;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }

  // Future<AuthorizationCredentialAppleID?> signInWithApple() async {
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //   );
  //   return appleCredential;
  // }
}
