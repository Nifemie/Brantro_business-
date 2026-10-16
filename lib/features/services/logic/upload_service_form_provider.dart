import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadServiceFormState {
  final String? selectedType;
  final int? selectedCategoryId;
  final String? selectedPricingUnit;
  final String? selectedTimeUnit;
  final String? selectedDeliveryFormat;
  final List<String> coverageAreas;
  final List<String> tags;
  final List<String> features;
  final List<String> requirements;
  final String? thumbnailPath;
  final String? sampleFilePath;
  final List<String> galleryPaths;

  UploadServiceFormState({
    this.selectedType,
    this.selectedCategoryId,
    this.selectedPricingUnit,
    this.selectedTimeUnit,
    this.selectedDeliveryFormat,
    this.coverageAreas = const [],
    this.tags = const [],
    this.features = const [],
    this.requirements = const [],
    this.thumbnailPath,
    this.sampleFilePath,
    this.galleryPaths = const [],
  });

  UploadServiceFormState copyWith({
    String? selectedType,
    int? selectedCategoryId,
    String? selectedPricingUnit,
    String? selectedTimeUnit,
    String? selectedDeliveryFormat,
    List<String>? coverageAreas,
    List<String>? tags,
    List<String>? features,
    List<String>? requirements,
    String? thumbnailPath,
    String? sampleFilePath,
    List<String>? galleryPaths,
  }) {
    return UploadServiceFormState(
      selectedType: selectedType ?? this.selectedType,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedPricingUnit: selectedPricingUnit ?? this.selectedPricingUnit,
      selectedTimeUnit: selectedTimeUnit ?? this.selectedTimeUnit,
      selectedDeliveryFormat: selectedDeliveryFormat ?? this.selectedDeliveryFormat,
      coverageAreas: coverageAreas ?? this.coverageAreas,
      tags: tags ?? this.tags,
      features: features ?? this.features,
      requirements: requirements ?? this.requirements,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      sampleFilePath: sampleFilePath ?? this.sampleFilePath,
      galleryPaths: galleryPaths ?? this.galleryPaths,
    );
  }
}

class UploadServiceFormNotifier extends StateNotifier<UploadServiceFormState> {
  UploadServiceFormNotifier() : super(UploadServiceFormState());

  void setType(String? type) => state = state.copyWith(selectedType: type);
  void setCategory(int? id) => state = state.copyWith(selectedCategoryId: id);
  void setPricingUnit(String? unit) => state = state.copyWith(selectedPricingUnit: unit);
  void setTimeUnit(String? unit) => state = state.copyWith(selectedTimeUnit: unit);
  void setDeliveryFormat(String? format) => state = state.copyWith(selectedDeliveryFormat: format);
  void setCoverageAreas(List<String> areas) => state = state.copyWith(coverageAreas: areas);
  void setTags(List<String> tags) => state = state.copyWith(tags: tags);
  void setFeatures(List<String> features) => state = state.copyWith(features: features);
  void setRequirements(List<String> reqs) => state = state.copyWith(requirements: reqs);
  void setThumbnailPath(String? path) => state = state.copyWith(thumbnailPath: path);
  void setSampleFilePath(String? path) => state = state.copyWith(sampleFilePath: path);
  void setGalleryPaths(List<String> paths) => state = state.copyWith(galleryPaths: paths);

  void reset() {
    state = UploadServiceFormState();
  }
}

final uploadServiceFormProvider = StateNotifierProvider.autoDispose<UploadServiceFormNotifier, UploadServiceFormState>((ref) {
  return UploadServiceFormNotifier();
});
