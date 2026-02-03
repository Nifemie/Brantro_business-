import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/ad_slot/logic/ad_slot_notifier.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearch;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enableAdSlotSearch; // New parameter to enable ad slot search
  final Color? iconColor; // New parameter for icon color

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search campaigns',
    this.controller,
    this.onChanged,
    this.onSearch,
    this.readOnly = false,
    this.onTap,
    this.enableAdSlotSearch = false,
    this.iconColor,
  });

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _performSearch(String query) {
    if (widget.enableAdSlotSearch) {
      // Search ad slots using the notifier
      ref.read(adSlotProvider.notifier).searchAdSlots(query: query);
    }
    widget.onSearch?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.readOnly ? widget.onTap : null,
      child: AbsorbPointer(
        absorbing: widget.readOnly,
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              widget.onChanged?.call(value);
              // Optional: perform search on every change with debounce
            },
            onSubmitted: (_) => _performSearch(_controller.text),
            readOnly: widget.readOnly,
            enableInteractiveSelection: !widget.readOnly,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
              prefixIcon: Icon(
                Icons.search,
                color: widget.iconColor ?? Colors.grey,
                size: 20.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      ),
    );
  }
}
