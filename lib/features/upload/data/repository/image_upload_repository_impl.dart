
import 'package:ebazarx/features/upload/data/datasource/image_upload_remote_data_source.dart';
import 'package:ebazarx/features/upload/domain/repository/image_upload_repository.dart';
import 'package:ebazarx/features/upload/models/upload_file_model.dart';
import 'package:ebazarx/features/upload/models/upload_response.dart';

class ImageUploadRepositoryImpl implements ImageUploadRepository {
  final ImageUploadRemoteDataSource _remoteDataSource;

  ImageUploadRepositoryImpl(this._remoteDataSource);

  @override
  Future<UploadResponse> uploadImage(UploadFile file) {
    return _remoteDataSource.uploadImage(file);
  }
}