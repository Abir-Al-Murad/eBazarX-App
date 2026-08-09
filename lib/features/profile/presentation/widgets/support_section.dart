import 'package:flutter/material.dart';

import 'profile_menu_tile.dart';
import 'section_card.dart';

class SupportSection extends StatelessWidget {
  final VoidCallback onHelp;
  final VoidCallback onContact;
  final VoidCallback onReport;

  const SupportSection({
    super.key,
    required this.onHelp,
    required this.onContact,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'SUPPORT',
      children: [
        ProfileMenuTile(
          icon: Icons.help_outline_rounded,
          title: 'Help Center',
          onTap: onHelp,
        ),
        ProfileMenuTile(
          icon: Icons.mail_outline_rounded,
          title: 'Contact Us',
          onTap: onContact,
        ),
        ProfileMenuTile(
          icon: Icons.flag_outlined,
          title: 'Report a Problem',
          onTap: onReport,
          iconColor: Colors.orange.shade700,
        ),
      ],
    );
  }
}