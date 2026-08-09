import 'package:flutter/material.dart';

import 'profile_menu_tile.dart';
import 'section_card.dart';

class SettingsSection extends StatelessWidget {
  final VoidCallback onTheme;
  final VoidCallback onLanguage;
  final VoidCallback onPrivacy;
  final VoidCallback onSecurity;
  final VoidCallback onTerms;
  final VoidCallback onAbout;

  const SettingsSection({
    super.key,
    required this.onTheme,
    required this.onLanguage,
    required this.onPrivacy,
    required this.onSecurity,
    required this.onTerms,
    required this.onAbout,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'SETTINGS',
      children: [
        ProfileMenuTile(
          icon: Icons.palette_outlined,
          title: 'Theme',
          onTap: onTheme,
        ),
        ProfileMenuTile(
          icon: Icons.language_rounded,
          title: 'Language',
          onTap: onLanguage,
        ),
        ProfileMenuTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy',
          onTap: onPrivacy,
        ),
        ProfileMenuTile(
          icon: Icons.lock_outline_rounded,
          title: 'Security',
          onTap: onSecurity,
        ),
        ProfileMenuTile(
          icon: Icons.description_outlined,
          title: 'Terms & Conditions',
          onTap: onTerms,
        ),
        ProfileMenuTile(
          icon: Icons.info_outline_rounded,
          title: 'About App',
          onTap: onAbout,
        ),
      ],
    );
  }
}