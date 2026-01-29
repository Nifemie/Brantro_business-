import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';

class ViewProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const ViewProfileScreen({
    super.key,
    required this.profileData,
  });

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profileData;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          // Cover Image & Avatar Header
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Cover Image
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Avatar & View Ad Slots Button
                  Positioned(
                    bottom: 16.h,
                    left: 16.w,
                    right: 16.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Avatar
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: profile['avatar'] != null
                                ? DecorationImage(
                                    image: NetworkImage(profile['avatar']),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: AppColors.grey300,
                          ),
                          child: profile['avatar'] == null
                              ? Icon(Icons.person,
                                  size: 40.sp, color: AppColors.grey600)
                              : null,
                        ),
                        Spacer(),
                        // View Ad Slots Button
                        ElevatedButton.icon(
                          onPressed: () {
                            final userId = profile['userId'];
                            if (userId != null) {
                              context.push('/seller-ad-slots/$userId', extra: {
                                'sellerName': profile['name'],
                                'sellerAvatar': profile['avatar'],
                                'sellerType': profile['profession'] ?? 'Professional',
                              });
                            }
                          },
                          icon: Icon(Icons.visibility, size: 16.sp),
                          label: Text('View Ad Slots'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Name & Badges
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile['name'] ?? 'Unknown',
                          style: AppTexts.h2(),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            _buildBadge(
                                profile['profession'] ?? 'Professional',
                                AppColors.error),
                            _buildBadge(
                                'Full Time', AppColors.primaryColor),
                            _buildBadge(
                                profile['location'] ?? 'Location',
                                AppColors.grey700),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // About Section
                  _buildSection(
                    'About',
                    profile['about'] ??
                        'Professional Artist available for verified advertising, partnerships, and brand collaborations on Brantro.',
                  ),

                  SizedBox(height: 20.h),

                  // Genres
                  if (profile['genres'] != null &&
                      (profile['genres'] as List).isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Genres', style: AppTexts.h4()),
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: (profile['genres'] as List)
                                .map((genre) => _buildGenreChip(genre))
                                .toList(),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),

                  // Stats Grid
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            Icons.work_outline,
                            profile['experience'] ?? '12 yrs',
                            'Experience',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            Icons.folder_outlined,
                            profile['projects'] ?? '7',
                            'Projects',
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            Icons.category_outlined,
                            profile['specialization'] ?? 'Film Acting',
                            'Specialization',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            Icons.person_outline,
                            profile['profession'] ?? 'Actor',
                            'Profession',
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Rating & Engagement Stats
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildEngagementStat(
                          Icons.star,
                          profile['rating'] ?? '0',
                          'Rating',
                          AppColors.warning,
                        ),
                        _buildEngagementStat(
                          Icons.favorite,
                          profile['likes'] ?? '0',
                          'Likes',
                          AppColors.error,
                        ),
                        _buildEngagementStat(
                          Icons.movie_outlined,
                          profile['productions'] ?? '7',
                          'Productions',
                          AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Social Media
                  _buildSocialMediaSection(
                    profile['socialMedia'] != null 
                      ? Map<String, dynamic>.from(profile['socialMedia'] as Map)
                      : null
                  ),

                  SizedBox(height: 20.h),

                  // Links/Actions
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Links', style: AppTexts.h4()),
                        SizedBox(height: 12.h),
                        _buildActionButton(
                          'Portfolio',
                          Icons.link,
                          AppColors.error,
                          () {
                            // TODO: Open portfolio
                          },
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                'Like',
                                Icons.favorite_border,
                                AppColors.primaryColor,
                                () {
                                  // TODO: Like action
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildActionButton(
                                'Save',
                                Icons.bookmark_border,
                                AppColors.warning,
                                () {
                                  // TODO: Save action
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildActionButton(
                                'Share',
                                Icons.share_outlined,
                                AppColors.grey600,
                                () {
                                  // TODO: Share action
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Tabs
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: AppColors.grey600,
                      indicatorColor: AppColors.primaryColor,
                      tabs: [
                        Tab(text: 'Features'),
                        Tab(text: 'Reviews'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFeaturesTab(profile),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: AppTexts.bodySmall(color: Colors.white),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTexts.h4()),
          SizedBox(height: 8.h),
          Text(
            content,
            style: AppTexts.bodyMedium(color: AppColors.grey700),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChip(String genre) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Text(
        genre,
        style: AppTexts.bodySmall(color: AppColors.grey700),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: AppColors.grey600),
          SizedBox(height: 8.h),
          Text(value, style: AppTexts.h4()),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTexts.bodySmall(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementStat(
      IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 4.h),
        Text(value, style: AppTexts.h4()),
        Text(
          label,
          style: AppTexts.bodySmall(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildSocialMediaSection(Map<String, dynamic>? socialMedia) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Social Media', style: AppTexts.h4()),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildSocialButton('Instagram', Colors.pink),
              _buildSocialButton('X', Colors.black),
              _buildSocialButton('YouTube', Colors.red),
              _buildSocialButton('TikTok', Colors.black87),
              _buildSocialButton('Facebook', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String platform, Color color) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Open social media link
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Text(platform, style: AppTexts.bodySmall(color: Colors.white)),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18.sp, color: color),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Widget _buildFeaturesTab(Map<String, dynamic> profile) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description', style: AppTexts.h4()),
            SizedBox(height: 12.h),
            Text(
              profile['description'] ??
                  'Brantro connects brands to verified influencers, media houses, and advertising spaces across Africa — with transparent pricing, proof of delivery, and campaign performance tracking.',
              style: AppTexts.bodyMedium(color: AppColors.grey700),
            ),
            SizedBox(height: 16.h),
            if (profile['features'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (profile['features'] as List)
                    .map((feature) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle,
                                  color: AppColors.success, size: 16.sp),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: AppTexts.bodyMedium(
                                      color: AppColors.grey700),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined,
                size: 48.sp, color: AppColors.grey400),
            SizedBox(height: 16.h),
            Text('No reviews yet', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              'Reviews will appear here',
              style: AppTexts.bodySmall(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }
}
