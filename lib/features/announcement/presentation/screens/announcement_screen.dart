import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../logic/announcement_provider.dart';
import '../widgets/add_announcement_dialog.dart';
import '../widgets/announcement_card.dart';

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
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(announcementProvider.notifier)
                      .fetchAnnouncements(query: _searchController.text.trim());
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SearchFilterCard(
                        title: 'Platform Announcements',
                        searchController: _searchController,
                        searchHint: 'Search announcements...',
                        showFilterButton: false,
                        actionButtonLabel: 'Add Announcement',
                        actionButtonIcon: Icons.add,
                        onChanged: (val) {
                          ref
                              .read(announcementProvider.notifier)
                              .fetchAnnouncements(query: val.trim());
                        },
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
                                    final errorText = e.toString().replaceFirst('Exception: ', '');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(errorText),
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
                    SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                    if (announcementState.isLoading && announcementState.announcements.isEmpty)
                      const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (announcementState.announcements.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyState(
                          icon: Icons.campaign_outlined,
                          title: 'No Announcements Yet',
                          message: 'Announcements you create or publish will appear here.',
                          showIconBackground: false,
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = announcementState.announcements[index];
                            return AnnouncementCard(
                              announcement: item,
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Announcement'),
                                    content: Text('Are you sure you want to delete "${item.title}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await ref.read(announcementProvider.notifier).deleteAnnouncement(item.id);
                                }
                              },
                            );
                          },
                          childCount: announcementState.announcements.length,
                        ),
                      ),
                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
