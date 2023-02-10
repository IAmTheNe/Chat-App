import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({
    super.key,
    required this.text,
    this.buttonBackgroundColor,
    this.icon,
    this.iconColor,
    this.textColor,
    this.onPressed,
  });

  /// A variable that is used to store the text that is passed in.
  final String text;
  final Color? buttonBackgroundColor;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: iconColor ?? Colors.white,
            ),
            label: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16.sp,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBackgroundColor ??
                  Theme.of(context).colorScheme.onPrimary,
              minimumSize: Size(1.sw - 64.w, 50),
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBackgroundColor ??
                  Theme.of(context).colorScheme.onPrimary,
              minimumSize: Size(1.sw - 64.w, 50),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16.sp,
              ),
            ),
          );
  }
}
