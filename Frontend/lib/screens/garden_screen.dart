import 'package:firebase_auth/firebase_auth.dart';
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

            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.75,
                  color: Colors.green,
                ),

                Positioned(
                  top: 400,
                  left: 20,
                  child: _emptySpot(
                    topWidget: _plantBtn(),
                    bottomWidget: _rock(),
                  ),
                ),

                Positioned(
                  top: 280,
                  left: 50,
                  child: _emptySpot(
                    topWidget: _plantBtn(),
                    bottomWidget: _rock(),
                  ),
                ),

                Positioned(
                  top: 160,
                  left: 35,
                  child: _emptySpot(
                    topWidget: _plantBtn(),
                    bottomWidget: _rock(),
                  ),
                ),
              ],
            ),

            const Spacer(flex: 1),
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
      child: Image.asset('assets/icons/gloves_icon.png', fit: BoxFit.contain),
    );
  }
}

class _plantBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/icons/add_plant_icon.png',
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// rock widget
class _rock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 30,
      child: Image.asset('assets/images/garden_rock.png', fit: BoxFit.contain),
    );
  }
}

class _emptySpot extends StatelessWidget {
  final Widget topWidget;
  final Widget bottomWidget;

  const _emptySpot({
    super.key,
    required this.topWidget,
    required this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Column(
        children: [topWidget, const SizedBox(height: 5), bottomWidget],
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
        width: 55,
        height: 55,
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
