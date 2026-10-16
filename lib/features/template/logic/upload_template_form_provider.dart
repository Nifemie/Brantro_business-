import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadTemplateFormState {
  final String? selectedType;
  final int? selectedCategoryId;
  final bool agreeToTerms;
  final File? thumbnailFile;
  final File? designFile;
  final String? designFileUrl;
  final File? videoFile;
  final String? videoUrl;

  UploadTemplateFormState({
    this.selectedType,
    this.selectedCategoryId,
    this.agreeToTerms = false,
    this.thumbnailFile,
    this.designFile,
    this.designFileUrl,
    this.videoFile,
    this.videoUrl,
  });

  UploadTemplateFormState copyWith({
    String? selectedType,
    int? selectedCategoryId,
    bool? agreeToTerms,
    File? thumbnailFile,
    File? designFile,
    String? designFileUrl,
    File? videoFile,
    String? videoUrl,
  }) {
    return UploadTemplateFormState(
      selectedType: selectedType ?? this.selectedType,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      thumbnailFile: thumbnailFile ?? this.thumbnailFile,
      designFile: designFile ?? this.designFile,
      designFileUrl: designFileUrl ?? this.designFileUrl,
      videoFile: videoFile ?? this.videoFile,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }
}

class UploadTemplateFormNotifier extends StateNotifier<UploadTemplateFormState> {
  UploadTemplateFormNotifier() : super(UploadTemplateFormState());

  void setType(String? type) => state = state.copyWith(selectedType: type);
  
  void setCategory(int? id) => state = state.copyWith(selectedCategoryId: id);
  
  void setAgreeToTerms(bool agree) => state = state.copyWith(agreeToTerms: agree);
  
  void setThumbnail(File? file) => state = state.copyWith(thumbnailFile: file);
  
  void setDesignFile(File? file) {
    state = state.copyWith(
      designFile: file,
      // If file is selected, clear URL
      designFileUrl: file != null ? null : state.designFileUrl,
    );
  }
  
  void setDesignUrl(String? url) {
    state = state.copyWith(
      designFileUrl: url,
      // If URL is set, clear file
      designFile: (url != null && url.isNotEmpty) ? null : state.designFile,
    );
  }
  
  void setVideoFile(File? file) {
    state = state.copyWith(
      videoFile: file,
      videoUrl: file != null ? null : state.videoUrl,
    );
  }
  
  void setVideoUrl(String? url) {
    state = state.copyWith(
      videoUrl: url,
      videoFile: (url != null && url.isNotEmpty) ? null : state.videoFile,
    );
  }

  void reset() {
    state = UploadTemplateFormState();
  }
}

final uploadTemplateFormProvider = StateNotifierProvider.autoDispose<UploadTemplateFormNotifier, UploadTemplateFormState>((ref) {
  return UploadTemplateFormNotifier();
});
