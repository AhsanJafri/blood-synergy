import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      _googleSignIn.authorizationClient.authorizationForScopes( ['email']);
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      print(googleUser.toString());
      print(googleUser);

      return googleUser;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login(
          loginBehavior: LoginBehavior.dialogOnly,
          permissions: ['public_profile']);
      final facebookUserData = await _facebookAuth.getUserData();

      return facebookUserData;
    } catch (e) {
      print('Error signing in with Facebook: $e');
      return null;
    }
  }

  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(
          scopes: [AppleIDAuthorizationScopes.email]);

      return result;
    } catch (e) {
      print('Error signing in with Apple: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _facebookAuth.logOut();
  }
}
