import 'package:ebazarx/features/upload/data/datasource/image_upload_remote_data_source.dart';
import 'package:ebazarx/features/upload/data/repository/image_upload_repository_impl.dart';
import 'package:ebazarx/features/upload/domain/repository/image_upload_repository.dart';
import 'package:ebazarx/features/upload/presentation/notifiers/image_upload_notifier.dart';
import 'package:ebazarx/features/upload/presentation/states/image_upload_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/upload/domain/usecases/upload_image_usecase.dart';

final imageUploadRemoteDataSourceProvider =
    Provider<ImageUploadRemoteDataSource>((ref) {
      return ImageUploadRemoteDataSource(ref.read(apiClientProvider));
    });

final imageUploadRepositoryProvider = Provider<ImageUploadRepository>((ref) {
  return ImageUploadRepositoryImpl(
    ref.read(imageUploadRemoteDataSourceProvider),
  );
});

final uploadImageUseCaseProvider = Provider<UploadImageUseCase>((ref) {
  return UploadImageUseCase(ref.read(imageUploadRepositoryProvider));
});

final imageUploadNotifierProvider = StateNotifierProvider<ImageUploadNotifier, ImageUploadState>((ref) {
  return ImageUploadNotifier(ref.read(uploadImageUseCaseProvider));
});