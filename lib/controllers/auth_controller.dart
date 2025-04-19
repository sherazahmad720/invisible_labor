import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/views/screens/auth/login_screen.dart';
import 'package:labor/views/screens/navigation_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> user = Rx<User?>(null);
  UserModel? userModel;
  WorkspaceModel? selectedWorkSpace;
  RxBool isLoading = false.obs;

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

  signup(String email, String password, {required displayName}) async {
    try {
      UserCredential? result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        userModel = await saveUserData(
          result.user!.uid,
          displayName: displayName,
        );
      }
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
    selectedWorkSpace = null;
    userModel = null;
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

  String? getDisplayName() {
    return _auth.currentUser?.displayName;
  }

  String? getPhotoUrl() {
    return _auth.currentUser?.photoURL;
  }

  Future<UserModel?> fetchUserModel() async {
    String? userId = getUserId();
    if (userId != null) {
      UserModel? userDataModel = await FirebaseServices.getUser(userId);
      if (userDataModel != null) {
        userModel = userDataModel;
        if (userModel?.selectedWorkspaceRef != null) {
          selectedWorkSpace = await FirebaseServices.getWorkspace(
            userModel!.selectedWorkspaceRef!,
          );
        }
      } else {
        var result = await saveUserData(userId);
        userModel = result;
        WorkspaceModel workspaceModel = await saveDefaultWorkSpace(userId);
        selectedWorkSpace = workspaceModel;
        update();
      }
    } else {
      logout();
      return null;
    }
    return null;
  }

  Future<UserModel> saveUserData(String userId, {String? displayName}) async {
    UserModel userModel = UserModel(
      id: userId,
      email: getUserEmail(),
      displayName: getDisplayName() ?? displayName,
      friendsList: [],
      workspaces: [userId],
      selectedWorkspaceRef: FirebaseServices.workspaceCollection.doc(userId),
      groupLists: [],
      photoUrl: getPhotoUrl() ?? '',
      ref: FirebaseServices.userCollection.doc(userId),
    );
    await FirebaseServices.createUser(userModel, userId);
    return userModel;
  }

  Future<WorkspaceModel> saveDefaultWorkSpace(String userId) async {
    WorkspaceModel workspaceModel = WorkspaceModel(
      name: "${getDisplayName()} 's Workspace",
      members: [userId],
      createdBy: userId,
      ref: FirebaseServices.workspaceCollection.doc(userId),
    );
    await FirebaseServices.createWorkspace(workspaceModel, workspaceId: userId);
    return workspaceModel;
  }
}
