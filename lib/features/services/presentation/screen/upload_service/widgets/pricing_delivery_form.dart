import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/widgets/option_picker_sheet.dart';

class PricingDeliveryForm extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController discountController;
  final TextEditingController deliveryTimeController;
  final TextEditingController revisionCountController;
  final TextEditingController estimatedReachController;
  final String? selectedPricingUnit;
  final String? selectedTimeUnit;
  final ValueChanged<String?> onPricingUnitChanged;
  final ValueChanged<String?> onTimeUnitChanged;

  const PricingDeliveryForm({
    super.key,
    required this.priceController,
    required this.discountController,
    required this.deliveryTimeController,
    required this.revisionCountController,
    required this.estimatedReachController,
    required this.selectedPricingUnit,
    required this.selectedTimeUnit,
    required this.onPricingUnitChanged,
    required this.onTimeUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Pricing & Delivery', isDark),
        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: priceController,
                label: 'Price *',
                hint: '₦ 0.00',
                isDark: isDark,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTextField(
                controller: discountController,
                label: 'Discount (Optional)',
                hint: '₦ 0.00',
                isDark: isDark,
                keyboardType: TextInputType.number,
                isRequired: false,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        _buildDropdownField(
          context: context,
          label: 'Pricing Unit *',
          value: selectedPricingUnit,
          hint: 'Select billing cycle...',
          onTap: () => _showPricingUnitPicker(context),
          isDark: isDark,
        ),
        
        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: deliveryTimeController,
                label: 'Delivery Time *',
                hint: 'e.g. 5',
                isDark: isDark,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildDropdownField(
                context: context,
                label: 'Time Unit *',
                value: selectedTimeUnit,
                hint: 'Select...',
                onTap: () => _showTimeUnitPicker(context),
                isDark: isDark,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: revisionCountController,
                label: 'Revision Count (Optional)',
                hint: 'e.g. 3',
                isDark: isDark,
                keyboardType: TextInputType.number,
                isRequired: false,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTextField(
                controller: estimatedReachController,
                label: 'Estimated Reach (Optional)',
                hint: 'e.g. 10000',
                isDark: isDark,
                keyboardType: TextInputType.number,
                isRequired: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String? value,
    required String hint,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: value == null
                          ? (isDark ? Colors.white38 : Colors.grey[400])
                          : (isDark ? Colors.white : AppColors.textPrimary),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showPricingUnitPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OptionPickerSheet(
        title: 'Select Pricing Unit',
        options: ['Per Project', 'Per Design', 'Per Hour', 'Per Day', 'Per Week', 'Per Month'],
      ),
    );
    if (result != null) {
      onPricingUnitChanged(result);
    }
  }

  Future<void> _showTimeUnitPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OptionPickerSheet(
        title: 'Select Time Unit',
        options: ['Hours', 'Days', 'Weeks', 'Months'],
      ),
    );
    if (result != null) {
      onTimeUnitChanged(result);
    }
  }
}
