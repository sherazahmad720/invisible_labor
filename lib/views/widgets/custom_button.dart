import 'package:flutter/material.dart';
import 'package:labor/utils/enum/button_type.dart';
import 'package:labor/utils/extentions.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.buttonType = ButtonType.filled,
    this.isLoading = false,
    this.buttonColor,
    this.buttonHeight,
    this.fontSize,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String buttonText;
  final void Function()? onPressed;
  final ButtonType buttonType;
  final bool isLoading;
  final Color? buttonColor;
  final double? buttonHeight;
  final double? fontSize;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: buttonHeight ?? 58,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border:
              buttonType == ButtonType.bordered
                  ? Border.all(
                    color: buttonColor ?? Theme.of(context).colorScheme.primary,
                  )
                  : null,
          borderRadius: BorderRadius.circular(100),
          color:
              buttonType == ButtonType.bordered
                  ? null
                  : buttonType == ButtonType.opacity
                  ? (buttonColor ?? Theme.of(context).colorScheme.primary)
                      .withOpacity(0.1)
                  : (buttonColor ?? Theme.of(context).colorScheme.primary),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isLoading)
              SizedBox(
                height: (buttonHeight ?? 58) / 2,
                width: (buttonHeight ?? 58) / 2,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon!,
                    size: 15,
                    color:
                        buttonType == ButtonType.bordered
                            ? buttonColor ??
                                Theme.of(context).colorScheme.primary
                            : buttonType == ButtonType.opacity
                            ? buttonColor ??
                                Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                  ),
                  10.5.height,
                ],
                Text(
                  buttonText,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color:
                        buttonType == ButtonType.bordered
                            ? buttonColor ??
                                Theme.of(context).colorScheme.primary
                            : buttonType == ButtonType.opacity
                            ? buttonColor ??
                                Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                    fontSize: fontSize,
                  ),
                ),
                if (trailingIcon != null) ...[
                  10.5.width,
                  Icon(
                    trailingIcon!,
                    size: 15,
                    color:
                        buttonType == ButtonType.bordered
                            ? buttonColor ??
                                Theme.of(context).colorScheme.primary
                            : buttonType == ButtonType.opacity
                            ? buttonColor ??
                                Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
