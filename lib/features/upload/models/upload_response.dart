class UploadResponse {
  final String? url;
  final String? publicId;
  final String? formate;
  final int? width;
  final int? height;
  final String message;

  const UploadResponse({
    this.url,
    this.publicId,
    this.formate,
    this.width,
    this.height,
    required this.message,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      url: json['data']['url'] as String?,
      publicId: json['data']['public_id'] as String?,
      formate: json['data']['format'] as String?,
      width: json['data']['width'] as int?,
      height: json['data']['height'] as int?,
      message: json['message'] as String? ?? '',
    );
  }
}