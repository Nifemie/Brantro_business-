import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../logic/faq_provider.dart';
import '../widgets/faq_item_card.dart';
import '../widgets/add_faq_dialog.dart';
import '../widgets/faq_details_dialog.dart';

class FaqScreen extends ConsumerStatefulWidget {
  const FaqScreen({super.key});

  @override
  ConsumerState<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final faqState = ref.watch(faqProvider);

    // Filter FAQs based on search query
    final filteredFaqs = faqState.faqs.where((faq) {
      final query = _searchController.text.toLowerCase();
      return faq.title.toLowerCase().contains(query) ||
          faq.answer.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'FAQs'),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(faqProvider.notifier).fetchFaqs();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                  SliverToBoxAdapter(
                    child: SearchFilterCard(
                      title: 'Frequently Asked Questions',
                      searchController: _searchController,
                      searchHint: 'Search FAQs...',
                      showFilterButton: false,
                      actionButtonLabel: 'Add FAQ',
                      actionButtonIcon: Icons.add,
                      onActionButtonTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddFaqDialog(
                            onSubmit: (title, answer) async {
                              try {
                                await ref
                                    .read(faqProvider.notifier)
                                    .addFaq(title, answer);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('FAQ created successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to add FAQ: $e'),
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
                  faqState.isLoading
                      ? const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : filteredFaqs.isEmpty
                          ? const SliverFillRemaining(
                              child: EmptyState(
                                icon: Icons.help_outline_rounded,
                                title: 'No FAQs Found',
                                message: 'Click "Add FAQ" to add custom FAQs to your profile.',
                                showIconBackground: false,
                              ),
                            )
                          : SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final faq = filteredFaqs[index];
                                    return FaqItemCard(
                                      faq: faq,
                                      onView: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => FaqDetailsDialog(faq: faq),
                                        );
                                      },
                                      onDelete: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete FAQ'),
                                            content: const Text(
                                                'Are you sure you want to delete this FAQ?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, true),
                                                style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          try {
                                            await ref
                                                .read(faqProvider.notifier)
                                                .deleteFaq(faq.id);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'FAQ deleted successfully'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Delete failed: $e'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                    );
                                  },
                                  childCount: filteredFaqs.length,
                                ),
                              ),
                            ),
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
