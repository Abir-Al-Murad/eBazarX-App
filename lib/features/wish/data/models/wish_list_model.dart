import 'package:ebazarx/features/wish/data/models/wish_item_model.dart';
import 'package:ebazarx/features/wish/domain/entities/wishlist_entity.dart';

class WishListModel {
  final String? id;
  final List<WishlistItemModel> items;
  final int totalItems;

  const WishListModel({
    required this.id,
    required this.items,
    required this.totalItems,
  });

  factory WishListModel.fromJson(Map<String, dynamic> json) {
    return WishListModel(
      id: json['id'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => WishlistItemModel.fromJson(e))
          .toList(),
      totalItems: json['total_items'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'total_items': totalItems,
    };
  }

  WishlistEntity toEntity() {
    return WishlistEntity(
      id: id,
      items: items.map((e) => e.toEntity()).toList(),
      totalItems: totalItems,
    );
  }

  factory WishListModel.fromEntity(WishlistEntity entity) {
    return WishListModel(
      id: entity.id,
      items: entity.items
          .map(WishlistItemModel.fromEntity)
          .toList(),
      totalItems: entity.totalItems,
    );
  }

  WishListModel copyWith({
    String? id,
    List<WishlistItemModel>? items,
    int? totalItems,
  }) {
    return WishListModel(
      id: id ?? this.id,
      items: items ?? this.items,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}