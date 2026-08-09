class AdminTopSeller {
  final String sellerId;
  final String shopName;
  final double totalRevenue;
  final int totalOrders;

  const AdminTopSeller({
    required this.sellerId,
    required this.shopName,
    required this.totalRevenue,
    required this.totalOrders,
  });
}