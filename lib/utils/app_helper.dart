import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:labor/utils/extentions.dart';

class AppHelper {
  showCustomBottomSheet(
    BuildContext context,
    Widget child,
    String title, {
    bool isMaxSize = true,
  }) {
    return showModalBottomSheet(
      elevation: 5,
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.9,
        minHeight: Get.height * 0.3,
      ),
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: isMaxSize ? MainAxisSize.max : MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: context.theme.hintColor,
                    ),
                  ),
                ),
                20.height,
                Row(
                  children: [
                    SizedBox(width: 40),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),

                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
