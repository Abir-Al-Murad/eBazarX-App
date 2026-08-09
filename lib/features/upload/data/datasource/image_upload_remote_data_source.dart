import 'package:dio/dio.dart';
import 'package:ebazarx/core/network/api_client.dart';
import 'package:ebazarx/features/upload/models/upload_file_model.dart';
import 'package:ebazarx/features/upload/models/upload_response.dart';

class ImageUploadRemoteDataSource {
  final ApiClient _apiClient;
  ImageUploadRemoteDataSource(this._apiClient);

  Future<UploadResponse> uploadImage(UploadFile file) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(file.bytes, filename: file.fileName),
    });

    final response = await _apiClient.postMultipart(
      '/upload/image',
      formData: formData,
    );

    if (response.isSuccess) {
      return UploadResponse.fromJson(response.body);
    }

    throw response.failure ??
        Exception(response.errorMessage ?? 'Failed to upload image');
  }
}