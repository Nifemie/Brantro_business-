import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_picker/country_picker.dart';

/// Reusable Country Picker Widget
class CountryPickerField extends StatefulWidget {
  final String label;
  final Function(Country) onCountryChanged;
  final Country? initialCountry;
  final bool isRequired;

  const CountryPickerField({
    required this.label,
    required this.onCountryChanged,
    this.initialCountry,
    this.isRequired = true,
    super.key,
  });

  @override
  State<CountryPickerField> createState() => _CountryPickerFieldState();
}

class _CountryPickerFieldState extends State<CountryPickerField> {
  late Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: false,
              onSelect: (Country country) {
                setState(() => _selectedCountry = country);
                widget.onCountryChanged(country);
              },
              countryListTheme: CountryListThemeData(
                borderRadius: BorderRadius.circular(8.r),
                inputDecoration: InputDecoration(
                  labelText: 'Search countries',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              children: [
                if (_selectedCountry != null) ...[
                  Text(
                    _selectedCountry!.flagEmoji,
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      _selectedCountry!.name,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Text(
                      'Select country',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
                Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
        if (widget.isRequired && _selectedCountry == null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              '${widget.label} is required',
              style: TextStyle(fontSize: 12.sp, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
