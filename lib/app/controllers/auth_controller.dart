import 'package:chatapp/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  Future<void> login() async {
    // Create Function for login with google.
    try {
      // untuk handle kebocoran data user sebelum login
      await _googleSignIn.signOut();
      // ini digunakan untuk mendapatkan google akun
      await _googleSignIn.signIn().then((value) => _currentUser = value);
      // digunakan untuk mengecek status login user
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        // login berhasil
        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print(userCredential);

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        // login is failed

      }
    } catch (error) {
      print(error);
    }
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
