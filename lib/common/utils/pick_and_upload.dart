// import 'package:ebazarx/features/product/domain/entities/product_image_entity.dart';
// import 'package:ebazarx/features/upload/models/upload_file_model.dart';
// import 'package:file_picker/file_picker.dart';
//
// Future<void> pickAndUpload() async {
//   final result = await FilePicker.platform.pickFiles(
//     type: FileType.image,
//     allowMultiple: true,
//     withData: true,
//   );
//
//   if (result == null) return;
//
//   final notifier =
//   ref.read(imageUploadNotifierProvider.notifier);
//
//   for (final file in result.files) {
//     if (file.bytes == null) continue;
//
//     final response = await notifier.upload(
//       UploadFile(
//         fileName: file.name,
//         bytes: file.bytes!,
//       ),
//     );
//
//     final image = ProductImage(
//       id: '',
//       url: response.url,
//       isPrimary: widget.images.isEmpty,
//       sortOrder: widget.images.length,
//     );
//
//     widget.onImagesChanged([
//       ...widget.images,
//       image,
//     ]);
//   }
// }