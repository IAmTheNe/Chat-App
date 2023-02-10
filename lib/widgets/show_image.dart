import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({
    super.key,
    required this.src,
  });

  final String src;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppBar(),
                    ),
                    Center(
                      child: Image.network(src),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            width: 200.w,
            height: 120.h,
            color: Colors.black12,
            child: Image.network(
              src,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
