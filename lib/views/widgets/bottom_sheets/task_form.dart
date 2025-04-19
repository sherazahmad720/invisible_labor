import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  AuthController _authController = Get.find<AuthController>();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;

  DateTime? startDateTime;
  DateTime? endDateTime;

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
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      buttonText:
                          startDateTime != null
                              ? DateFormat(
                                'yyyy-MM-dd – kk:mm',
                              ).format(startDateTime!)
                              : 'Start Time',
                      buttonType: ButtonType.bordered,
                      onPressed: () async {
                        DateTime? start = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(
                            Duration(days: 365),
                          ),
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
                              startDateTime = DateTime(
                                start.year,
                                start.month,
                                start.day,
                                startTime.hour,
                                startTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: CustomButton(
                      buttonText:
                          endDateTime != null
                              ? DateFormat(
                                'yyyy-MM-dd – kk:mm',
                              ).format(endDateTime!)
                              : 'End Time',
                      buttonType: ButtonType.bordered,
                      onPressed: () async {
                        DateTime? end = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(
                            Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(Duration(days: 365 * 3)),
                          initialDate: DateTime.now(),
                        );

                        if (end != null) {
                          TimeOfDay? endTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (endTime != null) {
                            setState(() {
                              endDateTime = DateTime(
                                end.year,
                                end.month,
                                end.day,
                                endTime.hour,
                                endTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
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
              durationInMinutes:
                  DateTimeRange(
                    start: startDateTime!,
                    end: endDateTime!,
                  ).duration.inMinutes,
              workspaceId: _authController.selectedWorkSpace?.ref?.id,
              doneBy: _authController.userModel?.ref?.id,
              startTime: startDateTime,
              endTime: endDateTime,
              isPublic: false,
            );

            DocumentReference? ref = await FirebaseServices.createTask(
              taskModel,
            );

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
