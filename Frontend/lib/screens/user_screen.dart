import 'package:flutter/material.dart';

  class UserScreen extends StatefulWidget {
    const UserScreen({super.key});

    @override
    State<UserScreen> createState() => _UserScreenState();
  }

  class _UserScreenState extends State<UserScreen> {
    final TextEditingController _textController = TextEditingController();
    int _selectedIndex = 3; // For bottom navigation bar

    @override
    void dispose() {
      _textController.dispose();
      super.dispose();
    }

    void _onNavItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      
      // Handle navigation based on selected index
      switch (index) {
        case 0:
          // Navigate to garden screen
          Navigator.pushNamed(context, '/garden');
          break;
        case 1:
          // Already on home screen
          Navigator.pushNamed(context, '/home');
          break;
        case 2:
          // Navigate to info screen
          Navigator.pushNamed(context, '/info');
          break;
        case 3:
          // Already on user screen
          break;
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFF20854F), // Green background
        body: SafeArea(
          child: Column(
            children: [
              // Top decoration row (logo icon)
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 20.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Logo icon
                    _LogoIcon(),
                  ],
                ),
              ),

              // Profile Card with Flexible to prevent overflow
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFB8CFAF),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/icons/profile_pic_icon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Profile Name
                          const Text(
                            'profile name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5A7C5A),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Account Info Section
                          _SectionTitle(title: 'account info'),
                          const SizedBox(height: 8),
                          _MenuItem(
                            label: 'profile',
                            onTap: () {
                              // TODO: Navigate to profile edit
                              Navigator.pushNamed(context, '/edit_user');
                            },
                          ),
                          const SizedBox(height: 8),
                          _MenuItem(
                            label: 'email',
                            onTap: () {
                              // TODO: Navigate to email settings
                            },
                          ),
                          const SizedBox(height: 16),

                          // Appearance Section
                          _SectionTitle(title: 'appearance'),
                          const SizedBox(height: 8),
                          _MenuItem(
                            label: 'theme',
                            onTap: () {
                              // TODO: Navigate to theme settings
                            },
                          ),
                          const SizedBox(height: 16),

                          // Others Section
                          _SectionTitle(title: 'others'),
                          const SizedBox(height: 8),
                          _MenuItem(
                            label: 'about us',
                            onTap: () {
                              // TODO: Navigate to about us
                            },
                          ),
                          const SizedBox(height: 8),
                          _MenuItem(
                            label: 'sign out',
                            onTap: () {
                              // TODO: Implement sign out
                              Navigator.pushReplacementNamed(context, '/login');
                            },
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
        // Bottom navigation bar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  imagePath: 'assets/icons/garden_icon.png',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onNavItemTapped(0),
                ),
                _NavBarItem(
                  imagePath: 'assets/icons/home_icon.png',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onNavItemTapped(1),
                ),
                _NavBarItem(
                  imagePath: 'assets/icons/info_icon.png',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onNavItemTapped(2),
                ),
                _NavBarItem(
                  imagePath: 'assets/icons/user_icon.png',
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onNavItemTapped(3),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // Logo icon widget
  class _LogoIcon extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: 60,
        height: 60,
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      );
    }
  }

  // Section Title widget
  class _SectionTitle extends StatelessWidget {
    final String title;

    const _SectionTitle({required this.title});

    @override
    Widget build(BuildContext context) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  // Menu Item widget
  class _MenuItem extends StatelessWidget {
    final String label;
    final VoidCallback onTap;

    const _MenuItem({
      required this.label,
      required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFB8CFAF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5A7C5A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF5A7C5A),
                size: 14,
              ),
            ],
          ),
        ),
      );
    }
  }

  // Navigation bar item
  class _NavBarItem extends StatelessWidget {
    final String imagePath;
    final bool isSelected;
    final VoidCallback onTap;

    const _NavBarItem({
      required this.imagePath,
      required this.isSelected,
      required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            imagePath,
            color: isSelected ? Color(0xFF5A7C5A) : null,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }