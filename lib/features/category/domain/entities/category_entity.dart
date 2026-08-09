import 'package:equatable/equatable.dart';

class Category extends Equatable{
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final String? parentId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    this.parentId,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });


  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    imageUrl,
    parentId,
    isActive,
    createdAt,
    updatedAt,
  ];

}