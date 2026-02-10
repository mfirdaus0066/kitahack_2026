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
              // Top decoration row (sun and watering can)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Sun icon
                    _SunIcon(),
                    // Watering can icon
                    _WateringCanIcon(),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // Speech bubble text input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFABCBBA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _textController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF5A7C5A),
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'tell me about your day',
                          hintStyle: const TextStyle(
                            color: Color(0xFF5A7C5A),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        maxLines: 3,
                        minLines: 1,
                      ),
                      // Speech bubble pointer
                      CustomPaint(
                        size: const Size(40, 20),
                        painter: _SpeechBubblePointer(),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Plant illustration
              // _PlantIllustration(),
              // Plant illustration (image)
              SizedBox(
                width: 200,   // adjust size to match your UI
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

  // Sun icon widget
  class _SunIcon extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: 60,
        height: 60,
        child: Image.asset(
          'assets/icons/sun_icon.png',
          fit: BoxFit.contain,
        ),
      );
    }
  }

  // Watering can icon widget
  class _WateringCanIcon extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: 60,
        height: 60,
        child: Image.asset(
          'assets/icons/wateringCan_icon.png',
          fit: BoxFit.contain,
        ),
      );
    }
  }

  // Speech bubble pointer painter
  class _SpeechBubblePointer extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      final paint = Paint()
        ..color = const Color(0xFFABCBBA)
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(size.width / 2 - 10, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width / 2 + 10, 0)
        ..close();

      canvas.drawPath(path, paint);
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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