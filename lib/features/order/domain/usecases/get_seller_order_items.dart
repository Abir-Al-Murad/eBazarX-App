import 'package:ebazarx/features/order/domain/entities/order_item_entity.dart';
import 'package:ebazarx/features/order/domain/repositories/order_repository.dart';

class GetSellerOrderItems {
  final OrderRepository _repository;
  GetSellerOrderItems(this._repository);

  Future<List<OrderItemEntity>> call(int skip, int limit){
    return _repository.getSellerOrderItems();
  }
}