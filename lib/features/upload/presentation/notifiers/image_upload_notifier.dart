import 'package:ebazarx/core/failures/failure.dart';
import 'package:ebazarx/features/upload/domain/usecases/upload_image_usecase.dart';
import 'package:ebazarx/features/upload/models/upload_file_model.dart';
import 'package:ebazarx/features/upload/models/upload_image_item.dart';
import 'package:ebazarx/features/upload/presentation/states/image_upload_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageUploadNotifier extends StateNotifier<ImageUploadState> {
  final UploadImageUseCase _uploadImageUseCase;

  ImageUploadNotifier(this._uploadImageUseCase)
      : super(const ImageUploadState());

  /// Upload a single image
  Future<void> upload(UploadFile file) async {
    state = state.copyWith(
      isUploading: true,
      clearError: true,
    );

    try {
      final response = await _uploadImageUseCase(file);

      final images = List<UploadImageItem>.from(state.images);

      images.add(
        UploadImageItem(
          url: response.url!,
          order: images.length,
          isPrimary: images.isEmpty,
        ),
      );

      state = state.copyWith(
        isUploading: false,
        images: images,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isUploading: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  /// Upload multiple images
  Future<void> uploadMultiple(List<UploadFile> files) async {
    if (files.isEmpty) return;

    state = state.copyWith(
      isUploading: true,
      clearError: true,
    );

    try {
      final images = List<UploadImageItem>.from(state.images);

      for (final file in files) {
        final response = await _uploadImageUseCase(file);

        images.add(
          UploadImageItem(
            url: response.url!,
            order: images.length,
            isPrimary: images.isEmpty,
          ),
        );
      }

      state = state.copyWith(
        isUploading: false,
        images: images,
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isUploading: false,
        failure: e,
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        failure: UnknownFailure(e.toString()),
      );
    }
  }

  /// Delete image
  void deleteImage(int index) {
    final images = List<UploadImageItem>.from(state.images);

    if (index < 0 || index >= images.length) return;

    images.removeAt(index);

    for (int i = 0; i < images.length; i++) {
      images[i] = images[i].copyWith(order: i);
    }

    if (images.isNotEmpty && !images.any((e) => e.isPrimary)) {
      images[0] = images[0].copyWith(isPrimary: true);
    }

    state = state.copyWith(images: images);
  }

  /// Set primary image
  void setPrimary(int index) {
    if (index < 0 || index >= state.images.length) return;

    final images = state.images
        .asMap()
        .entries
        .map(
          (entry) => entry.value.copyWith(
        isPrimary: entry.key == index,
      ),
    )
        .toList();

    state = state.copyWith(images: images);
  }

  /// Reorder images
  void reorder(int oldIndex, int newIndex) {
    final images = List<UploadImageItem>.from(state.images);

    if (newIndex > oldIndex) {
      newIndex--;
    }

    final item = images.removeAt(oldIndex);
    images.insert(newIndex, item);

    for (int i = 0; i < images.length; i++) {
      images[i] = images[i].copyWith(order: i);
    }

    state = state.copyWith(images: images);
  }

  /// Replace all images (useful for edit screen)
  void setImages(List<UploadImageItem> images) {
    state = state.copyWith(images: images);
  }

  /// Remove everything
  void clear() {
    state = const ImageUploadState();
  }
}