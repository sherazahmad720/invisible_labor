import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labor/models/user_model.dart';
import 'package:labor/utils/extentions.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.userModel, this.isCreator = false});
  final UserModel userModel;
  final bool isCreator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: context.theme.colorScheme.primary,
          backgroundImage:
              (userModel.photoUrl ?? '') != ''
                  ? CachedNetworkImageProvider(userModel.photoUrl!)
                  : null,
          child:
              (userModel.photoUrl ?? '') == ''
                  ? Center(
                    child: Text(
                      (userModel.displayName ?? '').substring(0, 1),
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: context.theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                  : null,
        ),
        10.width,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userModel.displayName ?? ''),
              Text(userModel.email ?? ''),
            ],
          ),
        ),
        if (isCreator) _buildRoleChip(context),
      ],
    );
  }

  Widget _buildRoleChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.colorScheme.primary),
      ),
      child: Text(
        'Creator',
        style: TextStyle(
          color: context.theme.colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
