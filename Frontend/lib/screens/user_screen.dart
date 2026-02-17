import 'package:flutter/material.dart';
import 'package:arnima/main.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _selectedIndex = 3;

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0: Navigator.pushNamed(context, '/garden'); break;
      case 1: Navigator.pushNamed(context, '/home');   break;
      case 2: Navigator.pushNamed(context, '/info');   break;
      case 3: break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20854F),
      body: SafeArea(
        child: Column(
          children: [
            // Top logo row
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 10),
              child: Row(
                children: [_LogoIcon()],
              ),
            ),

            // Profile Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Profile Picture
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFB8CFAF),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icons/profile_pic_icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          'profile name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5A7C5A),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Account Info ──
                        const _SectionTitle(title: 'account info'),
                        const SizedBox(height: 8),
                        _MenuItem(
                          label: 'profile',
                          onTap: () => Navigator.pushNamed(context, '/edit_user'),
                        ),
                        const SizedBox(height: 8),
                        _MenuItem(label: 'email', onTap: () {}),
                        const SizedBox(height: 16),

                        // ── Appearance ──
                        const _SectionTitle(title: 'appearance'),
                        const SizedBox(height: 8),
                        const _ThemeDropdownItem(), // ✅ theme dropdown
                        const SizedBox(height: 16),

                        // ── Others ──
                        const _SectionTitle(title: 'others'),
                        const SizedBox(height: 8),
                        _MenuItem(label: 'about us', onTap: () {}),
                        const SizedBox(height: 8),
                        _MenuItem(
                          label: 'sign out',
                          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(imagePath: 'assets/icons/garden_icon.png', isSelected: _selectedIndex == 0, onTap: () => _onNavItemTapped(0)),
              _NavBarItem(imagePath: 'assets/icons/home_icon.png',   isSelected: _selectedIndex == 1, onTap: () => _onNavItemTapped(1)),
              _NavBarItem(imagePath: 'assets/icons/info_icon.png',   isSelected: _selectedIndex == 2, onTap: () => _onNavItemTapped(2)),
              _NavBarItem(imagePath: 'assets/icons/user_icon.png',   isSelected: _selectedIndex == 3, onTap: () => _onNavItemTapped(3)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Theme Dropdown
// ─────────────────────────────────────────────
class _ThemeDropdownItem extends StatefulWidget {
  const _ThemeDropdownItem();

  @override
  State<_ThemeDropdownItem> createState() => _ThemeDropdownItemState();
}

class _ThemeDropdownItemState extends State<_ThemeDropdownItem> {
  bool _isOpen = false;

  static const _options = [
    {'label': 'system', 'mode': ThemeMode.system, 'icon': Icons.brightness_auto},
    {'label': 'light',  'mode': ThemeMode.light,  'icon': Icons.wb_sunny},
    {'label': 'dark',   'mode': ThemeMode.dark,   'icon': Icons.nights_stay},
  ];

  String _labelFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:  return 'light';
      case ThemeMode.dark:   return 'dark';
      case ThemeMode.system: return 'system';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Uses the PUBLIC getter — no more error
    final currentLabel = _labelFor(MyApp.of(context).themeMode);

    return Column(
      children: [
        // Header row
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFB8CFAF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'theme',
                  style: TextStyle(fontSize: 15, color: Color(0xFF5A7C5A), fontWeight: FontWeight.w500),
                ),
                AnimatedRotation(
                  turns: _isOpen ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.arrow_forward_ios, color: Color(0xFF5A7C5A), size: 14),
                ),
              ],
            ),
          ),
        ),

        // Options list
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFB8CFAF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: _options.map((opt) {
                final label = opt['label'] as String;
                final mode  = opt['mode']  as ThemeMode;
                final icon  = opt['icon']  as IconData;
                final isSelected = label == currentLabel;

                return GestureDetector(
                  onTap: () {
                    MyApp.of(context).setTheme(mode);
                    setState(() => _isOpen = false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF5A7C5A).withOpacity(0.18) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, size: 16, color: const Color(0xFF5A7C5A)),
                        const SizedBox(width: 10),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF5A7C5A),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                        if (isSelected) ...[
                          const Spacer(),
                          const Icon(Icons.check, size: 14, color: Color(0xFF5A7C5A)),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────
class _LogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60, height: 60,
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 13, color: Color(0xFF666666), fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _MenuItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: const Color(0xFFB8CFAF), borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 15, color: Color(0xFF5A7C5A), fontWeight: FontWeight.w500)),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF5A7C5A), size: 14),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavBarItem({required this.imagePath, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80, height: 80,
        padding: const EdgeInsets.all(5),
        child: Image.asset(imagePath, color: isSelected ? const Color(0xFF5A7C5A) : null, fit: BoxFit.contain),
      ),
    );
  }
}