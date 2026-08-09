import 'package:ebazarx/features/product/domain/entities/product_entity.dart';

abstract class ProductRepository {
  // ===========================
  // Public
  // ===========================

  Future<List<Product>> fetchProducts({
    int skip = 0,
    int limit = 20,
    String? categoryId,
    String? search,
  });

  Future<Product> getProduct(String productId);

  // ===========================
  // Seller
  // ===========================

  Future<Product> createProduct(
      Map<String, dynamic> data,
      );

  Future<List<Product>> fetchSellerProducts({
    int skip = 0,
    int limit = 20,
  });

  Future<Product> getSellerProduct(String productId);

  Future<Product> updateProduct({
    required String productId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteProduct(String productId);

  // ===========================
  // Admin
  // ===========================

  Future<List<Product>> fetchAllProducts({
    int skip = 0,
    int limit = 20,
    String? approvalStatus,
  });

  Future<List<Product>> fetchPendingProducts({
    int skip = 0,
    int limit = 20,
  });

  Future<Product> updateApproval({
    required String productId,
    required String approvalStatus,
    String? notes,
  });
}