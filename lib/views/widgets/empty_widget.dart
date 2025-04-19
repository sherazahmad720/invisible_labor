import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.title,
    this.message,
    this.iconData,
  });
  final String title;
  final String? message;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData ?? Icons.block_outlined,
              size: 64,
              color: context.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
