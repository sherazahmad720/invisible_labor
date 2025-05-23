import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/services/firebase_services.dart';
import 'package:labor/utils/extentions.dart';
import 'package:labor/views/widgets/custom_button.dart';
import 'package:labor/views/widgets/custom_text_form_field.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';

class UserSearchForm extends StatefulWidget {
  UserSearchForm({super.key, required this.selectedUser});
  List<String> selectedUser;

  @override
  State<UserSearchForm> createState() => _UserSearchFormState();
}

class _UserSearchFormState extends State<UserSearchForm> {
  List<String> selectedUser = [];

  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  late Timer t;

  Timer? _debounceTimer;

  void _onSearchTextChanged(String newText) {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(milliseconds: 200));
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    selectedUser.addAll(widget.selectedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search User')),
      body: Container(
        // height: Get.height * 0.7,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            CustomTextFormField(
              labelText: 'Search User',
              hintText: 'Start typing name or email...',
              onChanged: (val) {
                _onSearchTextChanged(val);
              },
              controller: searchController,
            ),
            10.height,
            Expanded(
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : PaginateFirestore(
                        itemBuilder: (ctx, docs, index) {
                          final UserModel userModel = UserModel.fromDoc(
                            docs[index],
                          );
                          return userModel.id ==
                                  FirebaseAuth.instance.currentUser?.uid
                              ? SizedBox()
                              : CheckboxListTile(
                                title: Text(userModel.displayName ?? ''),
                                subtitle: Text(userModel.email ?? ''),
                                value: selectedUser.contains(userModel.id),
                                onChanged: (bool? value) {
                                  selectedUser.contains(userModel.id)
                                      ? selectedUser.remove(userModel.id)
                                      : selectedUser.add(userModel.id ?? '');
                                  setState(() {});
                                },
                              );
                        },
                        shrinkWrap: true,
                        query: FirebaseServices.searchUser(
                          searchController.text,
                        ),
                        isLive: true,
                        itemBuilderType: PaginateBuilderType.listView,
                      ),
            ),
            10.height,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonColor: Colors.red,

                    buttonText: 'Cancel',
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                10.width,
                Expanded(
                  child: CustomButton(
                    buttonText: 'Update',
                    buttonColor: Colors.green,
                    onPressed: () {
                      Get.back(result: selectedUser);
                    },
                  ),
                ),
              ],
            ),
            40.height,
          ],
        ),
      ),
    );
  }
}
