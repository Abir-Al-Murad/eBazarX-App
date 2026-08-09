import 'package:flutter/material.dart';

import 'profile_menu_tile.dart';
import 'section_card.dart';

class AccountSection extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onOrders;
  final VoidCallback onWishlist;
  final VoidCallback onAddresses;
  final VoidCallback onPayments;
  final VoidCallback onNotifications;

  const AccountSection({
    super.key,
    required this.onEditProfile,
    required this.onOrders,
    required this.onWishlist,
    required this.onAddresses,
    required this.onPayments,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'ACCOUNT',
      children: [
        ProfileMenuTile(
          icon: Icons.person_outline_rounded,
          title: 'Edit Profile',
          onTap: onEditProfile,
        ),
        ProfileMenuTile(
          icon: Icons.receipt_long_rounded,
          title: 'My Orders',
          onTap: onOrders,
        ),
        ProfileMenuTile(
          icon: Icons.favorite_border_rounded,
          title: 'Wishlist',
          onTap: onWishlist,
        ),
        ProfileMenuTile(
          icon: Icons.location_on_outlined,
          title: 'Addresses',
          onTap: onAddresses,
        ),
        ProfileMenuTile(
          icon: Icons.payment_rounded,
          title: 'Payment Methods',
          onTap: onPayments,
        ),
        ProfileMenuTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          onTap: onNotifications,
        ),
      ],
    );
  }
}