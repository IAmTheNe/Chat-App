import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAvatarRectangle extends StatelessWidget {
  const CustomAvatarRectangle({
    super.key,
    required this.src,
    this.child,
  });

  final String src;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(src),
      ),
    );
  }
}

class CustomFindBox extends StatelessWidget {
  const CustomFindBox({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: ClipRRect(
        child: Container(
          margin: EdgeInsets.only(
            left: 8.w,
            right: 16.w,
          ),
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}
