import 'package:ebazarx/features/upload/models/upload_file_model.dart';
import 'package:ebazarx/features/upload/models/upload_image_item.dart';
import 'package:ebazarx/features/upload/presentation/providers/image_upload_provider.dart';
import 'package:ebazarx/features/upload/presentation/widgets/upload_add_button.dart';
import 'package:ebazarx/features/upload/presentation/widgets/upload_image_tile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderables/reorderables.dart';

class ReusableImageUploader extends ConsumerStatefulWidget {
  final List<UploadImageItem> initialImages;
  final int maxImages;
  final ValueChanged<List<UploadImageItem>> onChanged;

  const ReusableImageUploader({
    super.key,
    this.initialImages = const [],
    this.maxImages = 10,
    required this.onChanged,
  });

  @override
  ConsumerState<ReusableImageUploader> createState() =>
      _ReusableImageUploaderState();
}

class _ReusableImageUploaderState extends ConsumerState<ReusableImageUploader> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(imageUploadNotifierProvider.notifier)
          .setImages(widget.initialImages);
    });

    ref.listenManual(imageUploadNotifierProvider, (previous, next) {
      widget.onChanged(next.images);
    });
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    final notifier = ref.read(imageUploadNotifierProvider.notifier);

    final files = result.files
        .where((e) => e.bytes != null)
        .map(
          (e) => UploadFile(
        fileName: e.name,
        bytes: e.bytes!,
      ),
    )
        .toList();

    if (files.isEmpty) return;

    await notifier.uploadMultiple(files);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(imageUploadNotifierProvider);

    final notifier = ref.read(imageUploadNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.isUploading)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(),
          ),

        Text(
          "Images (${state.images.length}/${widget.maxImages})",
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ReorderableWrap(
              spacing: 12,
              runSpacing: 12,
              needsLongPressDraggable: false,
              onReorder: notifier.reorder,
              children: [
                ...List.generate(
                  state.images.length,
                      (index) => UploadImageTile(
                    key: ValueKey(state.images[index].url),
                    image: state.images[index],
                    onDelete: () => notifier.deleteImage(index),
                    onPrimary: () => notifier.setPrimary(index),
                  ),
                ),

                if (state.images.length < widget.maxImages)
                  UploadAddButton(
                    key: const ValueKey("add_button"),
                    onTap: _pickImages,
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }



}
