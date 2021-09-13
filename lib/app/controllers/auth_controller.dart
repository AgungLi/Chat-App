import 'package:chatapp/app/data/models/users_model.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  var user = UsersModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> firsInitialized() async {
    await autoLogin().then((value) => {
          if (value) {isAuth.value = true}
        });
    await skipIntro().then((value) => {
          if (value) {isSkipIntro.value = true}
        });
  }

  Future<bool> skipIntro() async {
    // akan mengubah isSkip = true
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    // akan mengubah isAuth = true => AutoLogin
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        // Masukan data ke Firebase
        CollectionReference users = firestore.collection('users');
        await users.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });
        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

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

        // Menyimpan status user yang sudah pernah login
        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        // Masukan data ke Firebase
        CollectionReference users = firestore.collection('users');

        final checkuser = await users.doc(_currentUser!.email).get();

        if (checkuser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
            "chats": []
          });
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }
        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

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
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  // PROFILE

  void changeProfile(String name, String status) {
    String date = DateTime.now().toIso8601String();
    //Update firebase
    CollectionReference users = firestore.collection("users");
    users.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date
    });

    // update model
    user.update((user) {
      user!.name = name;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.defaultDialog(title: "Success", middleText: "Change Profile Success");
  }

  void updateStatus(String status) {
    String date = DateTime.now().toIso8601String();

    //Update firebase
    CollectionReference users = firestore.collection("users");
    users.doc(_currentUser!.email).update({
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date,
    });

    // update model
    user.update((user) {
      user!.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });
    user.refresh();
    Get.defaultDialog(title: "Success", middleText: "Update status Success");
  }

// SEARCH
  void addNewConnection(String friendEmail) async {
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    final newChatDoc = await chats.add({
      "connection": [
        _currentUser!.email,
        friendEmail,
      ],
      "total_chats": 0,
      "total_read": 0,
      "total_unread": 0,
      "chat": [],
      "lastTime": date,
    });
    CollectionReference users = firestore.collection("users");
    await users.doc(_currentUser!.email).update({
      "chats": [
        {
          "connection": friendEmail,
          "chat_id": newChatDoc.id,
          "lastTime": DateTime.now().toIso8601String(),
        }
      ]
    });

    user.update((user) {
      user!.chats = [
        ChatUser(
          chatId: newChatDoc.id,
          connection: friendEmail,
          lastTime: date,
        )
      ];
    });
    user.refresh();
    Get.toNamed(Routes.CHAT_ROOM);
  }
}
