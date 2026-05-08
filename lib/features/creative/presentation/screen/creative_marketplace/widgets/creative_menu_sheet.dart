import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCreativeMenuSheet(BuildContext context, String creativeName) {
  showModalBottomSheet(
    context: context,
    builder: (context) => CreativeMenuSheet(creativeName: creativeName),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    isScrollControlled: false,
  );
}

class CreativeMenuSheet extends StatelessWidget {
  final String creativeName;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewDetails;

  const CreativeMenuSheet({
    super.key,
    required this.creativeName,
    this.onEdit,
    this.onDelete,
    this.onViewDetails,
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
                    onTap:
                        onEdit ??
                        () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Edit $creativeName')),
                          );
                        },
                  ),
                  _MenuOption(
                    icon: Icons.visibility_outlined,
                    title: 'View Details',
                    onTap:
                        onViewDetails ??
                        () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('View details for $creativeName'),
                            ),
                          );
                        },
                  ),
                  _MenuOption(
                    icon: Icons.share_outlined,
                    title: 'Share',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Share $creativeName')),
                      );
                    },
                  ),
                  _MenuOption(
                    icon: Icons.delete_outline,
                    title: 'Delete',
                    isDestructive: true,
                    onTap:
                        onDelete ??
                        () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Delete $creativeName')),
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
