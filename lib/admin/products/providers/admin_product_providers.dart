import 'package:ebazarx/admin/products/notifiers/admin_product_action_notifier.dart';
import 'package:ebazarx/admin/products/notifiers/admin_product_list_notifier.dart';
import 'package:ebazarx/features/product/presentation/providers/product_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminProductListNotifierProvider = StateNotifierProvider((ref)=> AdminProductListNotifier(ref.read(fetchAllProductsUseCaseProvider)));
final adminProductActionNotifierProvider = StateNotifierProvider((ref)=> AdminProductActionNotifier(ref.read(updateProductApprovalUseCaseProvider),ref.read(fetchPendingProductsUseCaseProvider)));