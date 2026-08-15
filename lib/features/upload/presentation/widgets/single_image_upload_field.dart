// lib/features/upload/presentation/widgets/single_image_upload_field.dart
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebazarx/core/utils/responsive.dart';
import 'package:ebazarx/features/upload/domain/usecases/upload_image_usecase.dart';
import 'package:ebazarx/features/upload/models/upload_file_model.dart';
import 'package:ebazarx/features/upload/presentation/providers/image_upload_provider.dart';
import 'package:ebazarx/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// A single-image upload field with fully independent, per-instance state.
///
/// Unlike ReusableImageUploader (which appears to share state across
/// instances — uploading one image updates every uploader on screen),
/// this widget owns its own upload state in a plain StatefulWidget, so
/// two of these on the same screen (e.g. logo + cover) never interfere
/// with each other.
class SingleImageUploadField extends ConsumerStatefulWidget {
  const SingleImageUploadField({
    super.key,
    required this.label,
    required this.hint,
    required this.onUploaded,
    this.aspectRatio = 1,
    this.initialUrl,
  });

  final String label;
  final String hint;
  final ValueChanged<String?> onUploaded;
  final double aspectRatio;
  final String? initialUrl;

  @override
  ConsumerState<SingleImageUploadField> createState() => _SingleImageUploadFieldState();
}

enum _UploadStatus { idle, uploading, uploaded, error }

class _SingleImageUploadFieldState extends ConsumerState<SingleImageUploadField> {
  _UploadStatus _status = _UploadStatus.idle;
  String? _imageUrl;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null && widget.initialUrl!.isNotEmpty) {
      _imageUrl = widget.initialUrl;
      _status = _UploadStatus.uploaded;
    }
  }

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    setState(() {
      _status = _UploadStatus.uploading;
      _errorMessage = null;
    });

    try {
      final Uint8List bytes = await picked.readAsBytes();

      // Adjust this to match your actual UploadFile constructor.
      final uploadFile = UploadFile(
        bytes: bytes,
        fileName: '${DateTime.now().millisecondsSinceEpoch}_${picked.name}',
      );

      final useCase = ref.read(uploadImageUseCaseProvider);
      final response = await useCase(uploadFile);

      if (!mounted) return;

      if (response.url != null && response.url!.isNotEmpty) {
        setState(() {
          _imageUrl = response.url;
          _status = _UploadStatus.uploaded;
        });
        widget.onUploaded(response.url);
      } else {
        setState(() {
          _status = _UploadStatus.error;
          _errorMessage = response.message.isNotEmpty ? response.message : 'Upload failed';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _UploadStatus.error;
        _errorMessage = 'Upload failed. Please try again.';
      });
    }
  }

  void _remove() {
    setState(() {
      _imageUrl = null;
      _status = _UploadStatus.idle;
    });
    widget.onUploaded(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 2),
        Text(
          widget.hint,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        SizedBox(height: context.paddingSizeSmall),
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.radiusDefault),
            child: _buildContent(theme),
          ),
        ),
        if (_status == _UploadStatus.error && _errorMessage != null) ...[
          SizedBox(height: context.paddingSizeExtraSmall),
          Text(_errorMessage!, style: TextStyle(color: AppColors.error, fontSize: context.fontSizeSmall)),
        ],
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    switch (_status) {
      case _UploadStatus.uploading:
        return Container(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );

      case _UploadStatus.uploaded:
        return Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(imageUrl: _imageUrl!, fit: BoxFit.cover),
            Positioned(
              top: 6,
              right: 6,
              child: Material(
                color: Colors.black.withValues(alpha: 0.5),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: _remove,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.close_rounded, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );

      case _UploadStatus.idle:
      case _UploadStatus.error:
        return InkWell(
          onTap: _pickAndUpload,
          child: DottedBorderContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 28,
                ),
                const SizedBox(height: 6),
                Text(
                  'Tap to upload',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}

/// Simple dashed-border placeholder container for the empty upload state.
class DottedBorderContainer extends StatelessWidget {
  const DottedBorderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(context.radiusDefault),
        border: Border.all(color: theme.dividerColor, width: 1.2),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}