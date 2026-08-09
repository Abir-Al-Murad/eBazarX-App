import 'package:ebazarx/features/upload/models/upload_file_model.dart';
import 'package:ebazarx/features/upload/models/upload_response.dart';

abstract class ImageUploadRepository {
  Future<UploadResponse> uploadImage(UploadFile file);
}

