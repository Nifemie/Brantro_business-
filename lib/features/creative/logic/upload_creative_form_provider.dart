import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadCreativeFormState {
  final int? selectedCategoryId;
  final String? selectedType;
  final String? selectedFormat;
  final List<String> features;
  final List<String> tags;
  final String? thumbnailPath;
  final String? creativeFilePath;
  final String? creativeFileUrl;

  UploadCreativeFormState({
    this.selectedCategoryId,
    this.selectedType,
    this.selectedFormat,
    this.features = const [],
    this.tags = const [],
    this.thumbnailPath,
    this.creativeFilePath,
    this.creativeFileUrl,
  });

  UploadCreativeFormState copyWith({
    int? selectedCategoryId,
    String? selectedType,
    String? selectedFormat,
    List<String>? features,
    List<String>? tags,
    String? thumbnailPath,
    String? creativeFilePath,
    String? creativeFileUrl,
  }) {
    return UploadCreativeFormState(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedType: selectedType ?? this.selectedType,
      selectedFormat: selectedFormat ?? this.selectedFormat,
      features: features ?? this.features,
      tags: tags ?? this.tags,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      creativeFilePath: creativeFilePath ?? this.creativeFilePath,
      creativeFileUrl: creativeFileUrl ?? this.creativeFileUrl,
    );
  }
}

class UploadCreativeFormNotifier extends StateNotifier<UploadCreativeFormState> {
  UploadCreativeFormNotifier() : super(UploadCreativeFormState());

  void setCategory(int? id) => state = state.copyWith(selectedCategoryId: id);
  void setType(String? type) => state = state.copyWith(selectedType: type);
  void setFormat(String? format) => state = state.copyWith(selectedFormat: format);
  void setFeatures(List<String> features) => state = state.copyWith(features: features);
  void setTags(List<String> tags) => state = state.copyWith(tags: tags);
  void setThumbnailPath(String? path) => state = state.copyWith(thumbnailPath: path);
  void setCreativeFilePath(String? path) => state = state.copyWith(creativeFilePath: path);
  void setCreativeFileUrl(String? url) => state = state.copyWith(creativeFileUrl: url);

  void reset() {
    state = UploadCreativeFormState();
  }
}

final uploadCreativeFormProvider = StateNotifierProvider.autoDispose<UploadCreativeFormNotifier, UploadCreativeFormState>((ref) {
  return UploadCreativeFormNotifier();
});
