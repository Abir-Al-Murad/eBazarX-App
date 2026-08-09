import 'package:ebazarx/features/upload/models/upload_image_item.dart';
import 'package:flutter/material.dart';

class UploadImageTile extends StatelessWidget {
  final UploadImageItem image;

  final VoidCallback onDelete;

  final VoidCallback onPrimary;

  const UploadImageTile({
    super.key,
    required this.image,
    required this.onDelete,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image.url,
                fit: BoxFit.cover,
              ),
            ),
          ),

          if (image.isPrimary)
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "PRIMARY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),

          Positioned(
            right: 4,
            top: 4,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black54,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: onDelete,
              ),
            ),
          ),

          // Positioned(
          //   bottom: 4,
          //   left: 4,
          //   child: ElevatedButton(
          //     onPressed: onPrimary,
          //     style: ElevatedButton.styleFrom(
          //       minimumSize: const Size(60, 28),
          //       padding: EdgeInsets.zero,
          //     ),
          //     child: const Text(
          //       "Primary",
          //       style: TextStyle(fontSize: 10),
          //     ),
          //   ),
          // ),

          const Positioned(
            right: 4,
            bottom: 4,
            child: Icon(
              Icons.drag_indicator,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}