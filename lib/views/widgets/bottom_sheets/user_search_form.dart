import 'package:flutter/material.dart';
import 'package:labor/models/workspace_model.dart';

class UserSearchForm extends StatefulWidget {
  const UserSearchForm({super.key, required this.workspaceModel});
  final WorkspaceModel workspaceModel;

  @override
  State<UserSearchForm> createState() => _UserSearchFormState();
}

class _UserSearchFormState extends State<UserSearchForm> {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    bool isLoading = false;
    return Container();
  }
}
