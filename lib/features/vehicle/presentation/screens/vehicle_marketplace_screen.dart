import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/search_filter_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/filter_sheet.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../core/widgets/delete_location_dialog.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_menu_sheet.dart';
import '../../logic/vehicle_provider.dart';

class VehicleMarketplaceScreen extends ConsumerStatefulWidget {
  const VehicleMarketplaceScreen({super.key});

  @override
  ConsumerState<VehicleMarketplaceScreen> createState() => _VehicleMarketplaceScreenState();
}

class _VehicleMarketplaceScreenState extends ConsumerState<VehicleMarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (mounted) {
      context.go('/dashboard');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vehicleState = ref.watch(vehicleProvider);
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: const SidebarMenu(),
        body: SafeArea(
          child: Column(
            children: [
              const DashboardAppBar(title: 'VEHICLES'),
              
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(vehicleProvider.notifier).refreshVehicles();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SearchFilterCard(
                          title: 'All Vehicles',
                          searchController: _searchController,
                          searchHint: 'Search vehicles...',
                          onFilterTap: _showFilters,
                          onActionButtonTap: _uploadVehicle,
                          actionButtonLabel: 'Upload Vehicle',
                          actionButtonIcon: Icons.upload,
                          selectedFilters: ref.read(vehicleProvider.notifier).selectedFilters,
                          onRemoveFilter: (key) => ref.read(vehicleProvider.notifier).removeFilter(key),
                          onClearFilters: () => ref.read(vehicleProvider.notifier).clearFilters(),
                          onChanged: (query) => ref.read(vehicleProvider.notifier).updateSearch(query),
                        ),
                      ),
                      
                      vehicleState.isInitialLoading
                          ? SliverPadding(
                              padding: EdgeInsets.all(16.w),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => const SkeletonCampaignCard(),
                                  childCount: 3,
                                ),
                              ),
                            )
                          : vehicleState.message != null
                              ? SliverFillRemaining(
                                  child: EmptyState(
                                    icon: Icons.wifi_off_outlined,
                                    title: 'Connection Error',
                                    message: vehicleState.message!.contains('SocketException') || vehicleState.message!.contains('Failed host lookup')
                                        ? 'Failed to load vehicles. Please check your internet connection and try again.'
                                        : vehicleState.message!,
                                    showIconBackground: true,
                                  ),
                                )
                              : (vehicleState.data ?? []).isEmpty
                                  ? const SliverFillRemaining(
                                      child: EmptyState(
                                        icon: Icons.directions_car_filled_outlined,
                                        title: 'No Vehicles Yet',
                                        message: 'Start by uploading your first vehicle',
                                        showIconBackground: false,
                                      ),
                                    )
                                  : SliverPadding(
                                      padding: EdgeInsets.all(16.w),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final sortedData = List.of(vehicleState.data ?? [])..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                                            final vehicle = sortedData[index];
                                            return VehicleCard(
                                              vehicle: vehicle,
                                              onViewSlots: () {
                                                context.push('/ad-slots', extra: {
                                                  'parentId': vehicle.id,
                                                  'parentType': 'vehicle',
                                                  'parentName': vehicle.name,
                                                });
                                              },
                                              onMenuTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) => VehicleMenuSheet(
                                                    vehicleName: vehicle.name,
                                                    onEdit: () {
                                                      Navigator.pop(context);
                                                      context.push('/upload-vehicle', extra: {
                                                        'isUpdate': true,
                                                        'vehicle': vehicle,
                                                      });
                                                    },
                                                    onDelete: () async {
                                                      Navigator.pop(context);
                                                      final confirm = await _showDeleteConfirmation(context, vehicle.name);
                                                      if (confirm == true) {
                                                        try {
                                                          await ref.read(vehicleProvider.notifier).deleteVehicle(vehicle.id);
                                                          if (context.mounted) {
                                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(
                                                                content: Text('Vehicle deleted successfully'),
                                                                backgroundColor: Colors.green,
                                                                duration: Duration(seconds: 3),
                                                              ),
                                                            );
                                                          }
                                                        } catch (e) {
                                                          if (context.mounted) {
                                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: Text('Delete failed: ${e.toString().replaceAll('Exception: ', '')}'),
                                                                backgroundColor: Colors.red,
                                                                duration: const Duration(seconds: 3),
                                                              ),
                                                            );
                                                          }
                                                        }
                                                      }
                                                    },
                                                    onViewDetails: () {
                                                      Navigator.pop(context);
                                                      context.push('/vehicle-details', extra: {'vehicle': vehicle});
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          childCount: vehicleState.data?.length ?? 0,
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
      ),
    );
  }

  Future<void> _showFilters() async {
    final currentFilters = ref.read(vehicleProvider.notifier).selectedFilters;

    await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => FilterSheet(
          title: 'Vehicle Filters',
          sections: [
            FilterSection(
              title: 'Location',
              options: ['All', 'Abuja', 'Lagos', 'Port Harcourt', 'Kano', 'Ibadan'],
              selectedValue: currentFilters['Location'],
            ),
            FilterSection(
              title: 'Vehicle Type',
              options: ['All', 'Sedan', 'SUV', 'Bus', 'Truck', 'Transit'],
              selectedValue: currentFilters['Vehicle Type'],
            ),
            FilterSection(
              title: 'Status',
              options: ['All', 'Active', 'Inactive', 'Maintenance'],
              selectedValue: currentFilters['Status'],
            ),
            FilterSection(
              title: 'Price Range',
              options: ['All', 'Under ₦100k', '₦100k - ₦250k', '₦250k - ₦500k', 'Above ₦500k'],
              selectedValue: currentFilters['Price Range'],
            ),
          ],
          onApply: (selectedFilters) {
            ref.read(vehicleProvider.notifier).updateFilters(selectedFilters);
          },
        ),
      ),
    );
  }

  void _uploadVehicle() {
    context.push('/upload-vehicle');
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, String vehicleName) {
    return DeleteLocationDialog.show(context);
  }
}
