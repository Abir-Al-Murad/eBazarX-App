import 'dart:ui';

import 'package:ebazarx/theme/app_colors.dart';

Color statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'active':
      return AppColors.success;
    case 'pending':
      return AppColors.pending;
    case 'draft':
      return AppColors.draft;
    case 'rejected':
      return AppColors.error;
    case 'archived':
      return AppColors.archived;
    case 'out of stock':
      return AppColors.outOfStock;
    default:
      return AppColors.pending;
  }
}