import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/task_model.dart';
import 'package:labor/services/firebase_services.dart';

class DashboardController extends GetxController {
  String selectedDuration = 'monthly';
  int count = 0;
  int averageTime = 0;
  bool loading = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    updateDashboard();
  }

  updateDashboard() async {
    if (loading) {
      return;
    }
    loading = true;
    update();
    try {
      List<TaskModel> list = [];
      DateTime today = DateTime.now();
      int subtractDays = 0;

      if (selectedDuration == 'monthly') {
        subtractDays = 30;
      } else if (selectedDuration == 'weekly') {
        subtractDays = 7;
      } else if (selectedDuration == 'yearly') {
        subtractDays = 365;
      }
      QuerySnapshot snapshot =
          await FirebaseServices.tasksCollection
              .where(
                'startTime',
                isGreaterThan: today.subtract(Duration(days: subtractDays)),
              )
              .where(
                'workspaceId',
                isEqualTo:
                    Get.find<AuthController>().selectedWorkSpace?.ref?.id ??
                    '-',
              )
              .get();
      count = snapshot.docs.length;
      int totalTime = 0;
      for (DocumentSnapshot documentSnapshot in snapshot.docs) {
        if (documentSnapshot.exists) {
          TaskModel taskModel = TaskModel.fromDoc(documentSnapshot);
          totalTime += taskModel.durationInMinutes ?? 0;
        }
      }

      // snapshot.docs.map((DocumentSnapshot doc) {});
      averageTime = count == 0 ? 0 : totalTime ~/ count;
    } catch (e) {
      print('$e');
    } finally {
      loading = false;
      update();
    }
  }
}
