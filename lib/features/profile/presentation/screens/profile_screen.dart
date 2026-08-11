import 'package:ebazarx/app/app_routes_name.dart';
import 'package:ebazarx/common/utils/invalidate_providers.dart';
import 'package:ebazarx/common/utils/load_necessary_data.dart';
import 'package:ebazarx/core/services/auth_storage.dart';
import 'package:ebazarx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ebazarx/features/profile/presentation/providers/profile_provider.dart';
import 'package:ebazarx/features/profile/presentation/widgets/admin_dashboard_card.dart';
import 'package:ebazarx/features/profile/presentation/widgets/empty_profile.dart';
import 'package:ebazarx/features/profile/presentation/widgets/error_profile.dart';
import 'package:ebazarx/features/profile/presentation/widgets/guest_profile_widget.dart';
import 'package:ebazarx/features/profile/presentation/widgets/logout_button.dart';
import 'package:ebazarx/features/profile/presentation/widgets/profile_header.dart';
import 'package:ebazarx/features/profile/presentation/widgets/seller_shop_card.dart';
import 'package:ebazarx/features/profile/presentation/widgets/account_section.dart';
import 'package:ebazarx/features/profile/presentation/widgets/setting_section.dart';
import 'package:ebazarx/features/profile/presentation/widgets/support_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileNotifierProvider);
    final theme = Theme.of(context);
    print("Building ProfileScreen with state: ${state.profile?.fullName}");
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.profile == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.failure != null && state.profile == null) {
              return ErrorProfile(
                message: state.failure.toString(),
                onRetry: () {
                  ref.read(profileNotifierProvider.notifier).fetchProfile();
                },
              );
            }

            final profile = state.profile;
            print("ProfileScreen: profile is ${profile?.email}");

            if (profile == null) {
              return GuestProfileWidget(
                onLogin: () async{
                  final result = await context.pushNamed(AppRoutesName.login);
                  if(result == true){
                    await loadNecessaryData(ref);
                  }
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await ref.read(profileNotifierProvider.notifier).fetchProfile();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: theme.colorScheme.surface,
                    title: const Text('My Profile'),
                  ),

                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      profile: profile,
                      onEditProfile: () {

                      },
                    ),
                  ),

                  if (profile.isSeller && profile.shop != null)
                    SliverToBoxAdapter(
                      child: SellerShopCard(
                        shop: profile.shop!,
                        onViewShop: () {},
                        onManageShop: () {},
                      ),
                    ),

                  if (profile.isAdmin && profile.admin != null)
                    SliverToBoxAdapter(
                      child: AdminDashboardCard(
                        admin: profile.admin!,
                      ),
                    ),

                  SliverToBoxAdapter(
                    child: AccountSection(
                      onEditProfile: () {},
                      onOrders: () {},
                      onWishlist: () {},
                      onAddresses: () {
                        context.pushNamed(AppRoutesName.address);
                      },
                      onPayments: () {},
                      onNotifications: () {},
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SettingsSection(
                      onTheme: () {},
                      onLanguage: () {},
                      onPrivacy: () {},
                      onSecurity: () {},
                      onTerms: () {},
                      onAbout: () {},
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SupportSection(
                      onHelp: () {},
                      onContact: () {},
                      onReport: () {},
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: LogoutButton(
                      onLogout: () async {
                        final refreshToken = await AuthStorage.instance.getRefreshToken();
                        if (refreshToken != null) {
                          await ref.read(authNotifierProvider.notifier).logout(refreshToken: refreshToken);
                        }
                        invalidateUserProviders(ref.read);
                        if (context.mounted) {
                          context.goNamed(AppRoutesName.login);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}