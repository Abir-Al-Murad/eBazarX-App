class UploadImageItem {
  final String url;
  final bool isPrimary;
  final int order;

  const UploadImageItem({
    required this.url,
    required this.order,
    this.isPrimary = false,
  });

  UploadImageItem copyWith({
    String? url,
    bool? isPrimary,
    int? order,
  }) {
    return UploadImageItem(
      url: url ?? this.url,
      order: order ?? this.order,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}