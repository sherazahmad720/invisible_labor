import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/views/screens/auth/login_screen.dart';
import 'package:labor/views/screens/navigation_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> user = Rx<User?>(null);
  UserModel? userModel;

  authListener() async {
    user.value = _auth.currentUser;

    await Future.delayed(const Duration(milliseconds: 1500));
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        user.value = firebaseUser;
        await fetchUserModel();

        Get.offAll(() => NavigationScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // await FirebaseMessaging.instance.subscribeToTopic(
      //   FirebaseAuth.instance.currentUser!.uid,
      // );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    // await FirebaseMessaging.instance.unsubscribeFromTopic(
    //   FirebaseAuth.instance.currentUser!.uid,
    // );
    await _auth.signOut();
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  String? getUserId() {
    return _auth.currentUser?.uid;
  }

  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  Future<UserModel?> fetchUserModel() async {
    String? userId = getUserId();
    if (userId != null) {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      if (doc.exists) {
        userModel = UserModel.fromDoc(doc);
        update();
        return userModel!;
      } else {
        logout();
      }
    } else {
      logout();
    }
    return null;
  }
}
