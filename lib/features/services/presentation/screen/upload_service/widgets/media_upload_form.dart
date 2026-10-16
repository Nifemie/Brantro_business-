import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../controllers/re_useable/app_color.dart';

class MediaUploadForm extends StatelessWidget {
  final String? thumbnailPath;
  final String? sampleFilePath;
  final TextEditingController sampleUrlController;
  final List<String> galleryPaths;
  final ValueChanged<String?> onThumbnailChanged;
  final ValueChanged<String?> onSampleFileChanged;
  final ValueChanged<List<String>> onGalleryChanged;

  const MediaUploadForm({
    super.key,
    required this.thumbnailPath,
    required this.sampleFilePath,
    required this.sampleUrlController,
    required this.galleryPaths,
    required this.onThumbnailChanged,
    required this.onSampleFileChanged,
    required this.onGalleryChanged,
  });

  Future<void> _pickThumbnail(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        onThumbnailChanged(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking thumbnail: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _pickSampleFile(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickMedia(); // Supporting image/video
      if (file != null) {
        onSampleFileChanged(file.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking sample file: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _pickGalleryImage(BuildContext context) async {
    if (galleryPaths.length >= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 8 gallery images allowed'), backgroundColor: Colors.orange),
      );
      return;
    }
    try {
      final picker = ImagePicker();
      final images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        final current = List<String>.from(galleryPaths);
        for (var image in images) {
          if (current.length < 8 && !current.contains(image.path)) {
            current.add(image.path);
          }
        }
        onGalleryChanged(current);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking gallery images: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Media Uploads', isDark),
        SizedBox(height: 16.h),
        
        // Thumbnail Picker
        _buildLabel('Upload Thumbnail *', isDark),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () => _pickThumbnail(context),
          child: Container(
            width: double.infinity,
            height: 160.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: thumbnailPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Stack(
                      children: [
                        Image.file(
                          File(thumbnailPath!),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: () => onThumbnailChanged(null),
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 40.sp, color: Colors.grey[400]),
                      SizedBox(height: 8.h),
                      Text(
                        'Click to upload service thumbnail',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
                      ),
                    ],
                  ),
          ),
        ),
        
        SizedBox(height: 20.h),
        
        // Sample File Picker
        _buildLabel('Upload Sample File', isDark),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () => _pickSampleFile(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: sampleFilePath != null
                ? Row(
                    children: [
                      Icon(Icons.insert_drive_file_outlined, color: AppColors.primaryColor, size: 28.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          sampleFilePath!.split('/').last,
                          style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary, fontSize: 14.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onSampleFileChanged(null),
                        child: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, color: Colors.grey[400], size: 24.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Upload service sample work/preview',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
                      ),
                    ],
                  ),
          ),
        ),
        
        SizedBox(height: 12.h),
        
        Text(
          'OR Enter Sample URL',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[500], fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        
        TextFormField(
          controller: sampleUrlController,
          style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'https://example.com/sample',
            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400]),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
        ),
        
        SizedBox(height: 20.h),
        
        // Gallery multi image picker
        _buildLabel('Gallery (Upload up to 8 images)', isDark),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
          ),
          itemCount: galleryPaths.length + 1,
          itemBuilder: (context, index) {
            if (index == galleryPaths.length) {
              return InkWell(
                onTap: () => _pickGalleryImage(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!, width: 1.5),
                  ),
                  child: Center(
                    child: Icon(Icons.add_a_photo_outlined, size: 24.sp, color: Colors.grey[500]),
                  ),
                ),
              );
            }
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    File(galleryPaths[index]),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 2.h,
                  right: 2.w,
                  child: GestureDetector(
                    onTap: () {
                      final updated = List<String>.from(galleryPaths)..removeAt(index);
                      onGalleryChanged(updated);
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 12),
                    ),
                  ),
                ),
              ],
            );
          },
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

  Widget _buildLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }
}
