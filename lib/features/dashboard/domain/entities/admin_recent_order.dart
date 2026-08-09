class AdminRecentOrder {
  final String id;
  final String orderNumber;
  final double grandTotal;
  final String orderStatus;
  final DateTime createdAt;
  final String? customerName;

  const AdminRecentOrder({
    required this.id,
    required this.orderNumber,
    required this.grandTotal,
    required this.orderStatus,
    required this.createdAt,
    this.customerName,
  });
}