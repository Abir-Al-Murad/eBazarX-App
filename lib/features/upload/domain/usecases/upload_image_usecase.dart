import 'package:ebazarx/features/upload/domain/repository/image_upload_repository.dart';
import 'package:ebazarx/features/upload/models/upload_file_model.dart';
import 'package:ebazarx/features/upload/models/upload_response.dart';

class UploadImageUseCase {
  final ImageUploadRepository _repository;

  UploadImageUseCase(this._repository);

  Future<UploadResponse> call(UploadFile file) {
    return _repository.uploadImage(file);
  }
}