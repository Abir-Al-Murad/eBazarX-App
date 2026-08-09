import 'package:equatable/equatable.dart';
import 'wish_item_entity.dart';

class WishlistEntity extends Equatable {
  final String? id;
  final List<WishlistItem> items;
  final int totalItems;

  const WishlistEntity({
    this.id,
    required this.items,
    required this.totalItems,
  });

  WishlistEntity copyWith({
    String? id,
    List<WishlistItem>? items,
    int? totalItems,
  }) {
    return WishlistEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  @override
  List<Object?> get props => [
    id,
    items,
    totalItems,
  ];
}