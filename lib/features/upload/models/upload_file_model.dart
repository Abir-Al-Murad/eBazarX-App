import 'dart:typed_data';

class UploadFile {
  final String fileName;
  final Uint8List bytes;

  const UploadFile({
    required this.fileName,
    required this.bytes,
  });
}