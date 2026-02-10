  import 'package:flutter/material.dart';

  class GardenScreen extends StatefulWidget {
    const GardenScreen({super.key});

    @override
    State<GardenScreen> createState() => _GardenScreenState();
  }

  class _GardenScreenState extends State<GardenScreen> {
    final TextEditingController _textController = TextEditingController();
    int _selectedIndex = 0; // For bottom navigation bar

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
          // Navigate to user screen
          Navigator.pushNamed(context, '/user');
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
              // Top decoration row (collaboration and gloves icons)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Collaboration icon
                    _CollaborationIcon(),
                    // Gloves icon
                    _GlovesIcon(),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              SizedBox(
                width: 200,
                height: 300,
                child: Image.asset(
                  'assets/icons/garden_icon.png',
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

  // Collaboration icon widget
  class _CollaborationIcon extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: 60,
        height: 60,
        child: Image.asset(
          'assets/icons/collaboration_icon.png',
          fit: BoxFit.contain,
        ),
      );
    }
  }

  // Gloves icon widget
  class _GlovesIcon extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: 60,
        height: 60,
        child: Image.asset(
          'assets/icons/gloves_icon.png',
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