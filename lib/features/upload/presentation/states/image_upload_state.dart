import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/upload/models/upload_image_item.dart';

class ImageUploadState {
  final bool isUploading;

  final List<UploadImageItem> images;

  final Failure? failure;

  const ImageUploadState({
    this.isUploading = false,
    this.images = const [],
    this.failure,
  });

  ImageUploadState copyWith({
    bool? isUploading,
    List<UploadImageItem>? images,
    Failure? failure,
    bool clearError = false,
  }) {
    return ImageUploadState(
      isUploading: isUploading ?? this.isUploading,
      images: images ?? this.images,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}