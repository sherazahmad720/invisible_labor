import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/dashboard_controller.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/views/screens/auth/login_screen.dart';
import 'package:labor/views/screens/navigation_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> user = Rx<User?>(null);
  UserModel? userModel;
  WorkspaceModel? _selectedWorkSpace;
  WorkspaceModel? get selectedWorkSpace => _selectedWorkSpace;
  RxBool isLoading = false.obs;
  String? displayName;

  set selectWorkSpace(WorkspaceModel model) {
    userModel?.ref?.update({'selectedWorkspace': model.ref});
    _selectedWorkSpace = model;
    Get.put(DashboardController()).updateDashboard();
    update();
  }

  authListener() async {
    user.value = _auth.currentUser;

    await Future.delayed(const Duration(milliseconds: 500));
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        user.value = firebaseUser;
        await fetchUserModel();
        isLoading.value = false;
        Get.offAll(() => NavigationScreen());
        // logout();
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }

  Future<String?> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // await FirebaseMessaging.instance.subscribeToTopic(
      //   FirebaseAuth.instance.currentUser!.uid,
      // );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      isLoading.value = false;
      return 'An unexpected error occurred. Please try again.';
    }
  }

  signup(String email, String password, {required String displayName}) async {
    try {
      // this.displayName = displayName;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseAuth.instance.currentUser?.updateDisplayName(displayName);
      // await FirebaseMessaging.instance.subscribeToTopic(
      //   FirebaseAuth.instance.currentUser!.uid,
      // );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      isLoading.value = false;
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    // await FirebaseMessaging.instance.unsubscribeFromTopic(
    //   FirebaseAuth.instance.currentUser!.uid,
    // );
    _selectedWorkSpace = null;
    userModel = null;
    await _auth.signOut();
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      Get.back();
    } catch (e) {
      print('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
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

  Future<UserModel?> fetchUserModel({String? displayName}) async {
    String? userId = getUserId();
    if (userId != null) {
      UserModel? userDataModel = await FirebaseServices.getUser(userId);
      if (userDataModel != null) {
        userModel = userDataModel;
        if (userModel?.selectedWorkspaceRef != null) {
          _selectedWorkSpace = await FirebaseServices.getWorkspace(
            userModel!.selectedWorkspaceRef!,
          );
        }
      } else {
        var result = await saveUserData(userId);
        userModel = result;
        WorkspaceModel workspaceModel = await saveDefaultWorkSpace(userId);
        _selectedWorkSpace = workspaceModel;
        update();
      }
    } else {
      logout();
      return null;
    }
    return null;
  }

  Future<UserModel> saveUserData(String userId) async {
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
