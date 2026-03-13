import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class DrawerOnlineUsers extends StatelessWidget {
  const DrawerOnlineUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: _OnlineAvatar(index: index),
          );
        },
      ),
    );
  }
}

class _OnlineAvatar extends StatelessWidget {
  final int index;

  const _OnlineAvatar({required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 26.r,
          backgroundColor: AppColors.grey300,
          backgroundImage: AssetImage(
            'assets/icons/avatars/avatars/avatar-${(index % 7) + 1}.jpg',
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 14.w,
            height: 14.w,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
