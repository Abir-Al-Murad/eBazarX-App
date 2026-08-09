import 'package:ebazarx/features/dashboard/domain/usecases/get_seller_dashboard_usecase.dart';
import 'package:ebazarx/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:ebazarx/seller/dashborad/notifiers/seller_dashboard_notifier.dart';
import 'package:ebazarx/seller/dashborad/states/seller_dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getSellerDashboardUseCaseProvider = Provider((ref)=>GetSellerDashboardUseCase(ref.read(dashboardRepositoryProvider)));
final sellerDashboardNotifierProvider = StateNotifierProvider<SellerDashboardNotifier, SellerDashboardState>((ref) => SellerDashboardNotifier(ref.read(getSellerDashboardUseCaseProvider)));
