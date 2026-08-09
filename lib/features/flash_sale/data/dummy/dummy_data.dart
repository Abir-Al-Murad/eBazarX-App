import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:ebazarx/features/flash_sale/domain/entities/flash_sale_product_entity.dart';

class FlashSaleDummy {
  static final List<FlashSale> flashSales = [
    FlashSale(
      id: 'fs-1',
      name: 'Mega Electronics Sale',
      description: 'Up to 70% OFF on electronics.',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(hours: 8)),
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      products: [
        FlashSaleProduct(
          id: 'p-1',
          flashSaleId: 'fs-1',
          productId: 'product-1',
          discountPrice: 799.0,
          stockLimit: 100,
          sold: 35,
        ),
        FlashSaleProduct(
          id: 'p-2',
          flashSaleId: 'fs-1',
          productId: 'product-2',
          discountPrice: 1599.0,
          stockLimit: 50,
          sold: 18,
        ),
        FlashSaleProduct(
          id: 'p-3',
          flashSaleId: 'fs-1',
          productId: 'product-3',
          discountPrice: 299.0,
          stockLimit: 200,
          sold: 72,
        ),
      ],
    ),

    FlashSale(
      id: 'fs-2',
      name: 'Fashion Festival',
      description: 'Flat 50% OFF on fashion.',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 1)),
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      products: [
        FlashSaleProduct(
          id: 'p-4',
          flashSaleId: 'fs-2',
          productId: 'product-4',
          discountPrice: 999.0,
          stockLimit: 120,
          sold: 52,
        ),
        FlashSaleProduct(
          id: 'p-5',
          flashSaleId: 'fs-2',
          productId: 'product-5',
          discountPrice: 499.0,
          stockLimit: 80,
          sold: 21,
        ),
      ],
    ),

    FlashSale(
      id: 'fs-3',
      name: 'Home & Kitchen Deals',
      description: 'Limited-time home essentials.',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(hours: 12)),
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      products: [
        FlashSaleProduct(
          id: 'p-6',
          flashSaleId: 'fs-3',
          productId: 'product-6',
          discountPrice: 1199.0,
          stockLimit: 40,
          sold: 12,
        ),
        FlashSaleProduct(
          id: 'p-7',
          flashSaleId: 'fs-3',
          productId: 'product-7',
          discountPrice: 699.0,
          stockLimit: 60,
          sold: 33,
        ),
        FlashSaleProduct(
          id: 'p-8',
          flashSaleId: 'fs-3',
          productId: 'product-8',
          discountPrice: 1499.0,
          stockLimit: 30,
          sold: 9,
        ),
      ],
    ),
  ];
}