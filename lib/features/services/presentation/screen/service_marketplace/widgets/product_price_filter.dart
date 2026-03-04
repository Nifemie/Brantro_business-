import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductPriceFilter extends StatefulWidget {
  final ValueChanged<RangeValues>? onPriceChanged;

  const ProductPriceFilter({super.key, this.onPriceChanged});

  @override
  State<ProductPriceFilter> createState() => _ProductPriceFilterState();
}

class _ProductPriceFilterState extends State<ProductPriceFilter> {
  RangeValues _currentRange = const RangeValues(0, 1500);
  final TextEditingController _minController = TextEditingController(text: '0');
  final TextEditingController _maxController = TextEditingController(
    text: '1500',
  );

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _updateFromTextInputs() {
    final minVal = double.tryParse(_minController.text) ?? 0;
    final maxVal = double.tryParse(_maxController.text) ?? 1500;

    if (minVal <= maxVal && maxVal <= 1500) {
      setState(() {
        _currentRange = RangeValues(minVal, maxVal);
      });
      widget.onPriceChanged?.call(_currentRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final outerBgColor = isDark ? const Color(0xFF22272B) : Colors.white;
    final headerBgColor = isDark ? const Color(0xFF2D333B) : Colors.grey[100]!;
    final inputBgColor = isDark ? const Color(0xFF22272B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF3E444C) : Colors.grey[300]!;
    final textColor = isDark ? Colors.grey[400]! : Colors.grey[700]!;
    final headerTextColor = isDark ? Colors.grey[300]! : Colors.black87;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: outerBgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: headerBgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'Product Price',
              style: TextStyle(
                color: headerTextColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Custom Price Range Label
          Text(
            'Custom Price Range :',
            style: TextStyle(
              color: headerTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4.h,
              activeTrackColor: const Color(0xFF00388B),
              inactiveTrackColor: isDark
                  ? const Color(0xFF1E2125)
                  : Colors.grey[200],
              thumbColor: const Color(0xFF00388B),
              overlayColor: const Color(0xFF00388B).withOpacity(0.2),
              rangeThumbShape: RoundRangeSliderThumbShape(
                enabledThumbRadius: 8.r,
              ),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
            ),
            child: RangeSlider(
              values: _currentRange,
              min: 0,
              max: 1500, // Updated to precisely 1500
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRange = values;
                  _minController.text = values.start.round().toString();
                  _maxController.text = values.end.round().toString();
                });
                widget.onPriceChanged?.call(values);
              },
            ),
          ),
          SizedBox(height: 16.h),

          // Number Inputs
          Row(
            children: [
              // Min Input
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: inputBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onSubmitted: (_) => _updateFromTextInputs(),
                    style: TextStyle(
                      color: headerTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'to',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Max Input
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: inputBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onSubmitted: (_) => _updateFromTextInputs(),
                    style: TextStyle(
                      color: headerTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 32.h),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                _updateFromTextInputs();
                // Optionally show a snackbar or trigger search
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00388B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Apply',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
