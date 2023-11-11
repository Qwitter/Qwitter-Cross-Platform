import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      return googleUser;
    } catch (error) {
      return null;
    }
  }
}
