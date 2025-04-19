import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/controllers/auth_controller.dart';
import 'package:labor/models/task_model.dart';
import 'package:labor/models/workspace_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/enum/button_type.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/custom_button.dart';
import 'package:labor/views/widgets/custom_text_form_field.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  AuthController _authController = Get.find<AuthController>();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;

  DateTimeRange? dateTimeRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: titleController,
                validator: (val) {
                  if ((val?.trim() ?? '').isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                labelText: 'Title',
                hintText: 'Write you task title here...',
              ),
              20.height,
              CustomTextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if ((val?.trim() ?? '').isEmpty) {
                    return 'Duration is required';
                  }
                  return null;
                },
                labelText: 'Duration In Minutes',
                hintText: 'Write you duration in minutes here...',
              ),

              20.height,
              CustomButton(
                buttonText: 'Select Duration',
                buttonType: ButtonType.bordered,
                onPressed: () async {
                  DateTime? start = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365 * 3)),
                    initialDate: DateTime.now(),
                  );

                  if (start != null) {
                    TimeOfDay? startTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (startTime != null) {
                      setState(() {
                        // dateTimeRange =  DateTimeRange(start: start, end: end)
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
        30.height,
        CustomButton(
          buttonText: 'Save',
          isLoading: isLoading,
          onPressed: () async {
            if (!formKey.currentState!.validate()) {
              return;
            }
            setState(() {
              isLoading = true;
            });
            TaskModel taskModel = TaskModel(
              title: titleController.text,
              durationInMinutes: int.tryParse(durationController.text),
              workspaceId: _authController.selectedWorkSpace?.ref?.id,
              doneBy: _authController.userModel?.ref?.id,
              isPublic: false,
            );

            DocumentReference? ref = await FirebaseServices.createTask(
              taskModel,
            );
            // if (ref != null) {
            //   DocumentSnapshot doc = await ref.get();
            //   if (doc.exists) {
            //     _authController.selectWorkSpace = TaskModel.fromDoc(doc);
            //     _authController.update();
            //   }
            // }

            setState(() {
              isLoading = false;
            });
            Get.back();
          },
        ),
      ],
    );
  }
}
