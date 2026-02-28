import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCreativeMenuSheet(BuildContext context, String title) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => CreativeMenuSheet(title: title),
  );
}

class CreativeMenuSheet extends StatelessWidget {
  final String title;

  const CreativeMenuSheet({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Menu Options
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _MenuOption(
                    icon: Icons.edit_outlined,
                    title: 'Edit Creative',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit $title')),
                      );
                    },
                  ),
                  _MenuOption(
                    icon: Icons.visibility_outlined,
                    title: 'View Details',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('View details for $title')),
                      );
                    },
                  ),
                  _MenuOption(
                    icon: Icons.share_outlined,
                    title: 'Share',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Share $title')),
                      );
                    },
                  ),
                  _MenuOption(
                    icon: Icons.delete_outline,
                    title: 'Delete',
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Delete $title')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Colors.red
            : (isDark ? Colors.white70 : Colors.grey[700]),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: isDestructive
              ? Colors.red
              : (isDark ? Colors.white : Colors.grey[900]),
        ),
      ),
      onTap: onTap,
    );
  }
}
