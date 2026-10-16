import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../logic/announcement_provider.dart';
import '../widgets/add_announcement_dialog.dart';

class AnnouncementScreen extends ConsumerStatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  ConsumerState<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends ConsumerState<AnnouncementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final announcementState = ref.watch(announcementProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'ANNOUNCEMENTS'),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SearchFilterCard(
                      title: 'Platform Announcements',
                      searchController: _searchController,
                      searchHint: 'Search announcements...',
                      showFilterButton: false,
                      actionButtonLabel: 'Add Announcement',
                      actionButtonIcon: Icons.add,
                      onActionButtonTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddAnnouncementDialog(
                            onSubmit: ({
                              required String title,
                              required String audience,
                              String? category,
                              String? actionText,
                              String? actionUrl,
                              required String description,
                            }) async {
                              try {
                                await ref
                                    .read(announcementProvider.notifier)
                                    .addAnnouncement(
                                      title: title,
                                      audience: audience,
                                      category: category,
                                      actionText: actionText,
                                      actionUrl: actionUrl,
                                      description: description,
                                    );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Announcement created successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to create announcement: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                  
                  // Always show empty state as requested: "there is no card for this yet, just empty state"
                  const SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.campaign_outlined,
                      title: 'No Announcements Yet',
                      message: 'Announcements you create will appear here once cards are designed.',
                      showIconBackground: false,
                    ),
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
