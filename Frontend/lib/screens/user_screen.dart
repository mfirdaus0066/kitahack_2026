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
                padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 20.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Logo icon
                    _LogoIcon(),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              SizedBox(
                width: 200,
                height: 300,
                child: Image.asset(
                  'assets/icons/user_icon.png',
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
        // Bottom navigation bar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
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