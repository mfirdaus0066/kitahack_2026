import 'package:arnima/main.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExpanded = false;
  String _lastMessage = '';
  final TextEditingController _textController = TextEditingController();
  int _selectedIndex = 1; // Home is selected by default

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
      resizeToAvoidBottomInset: false,
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
                  GestureDetector(
                    onTap: () {
                      MyApp.of(context).toggleTheme();
                    },
                    child: _SunIcon(),
                  ),
                  // Watering can icon
                  _WateringCanIcon(),
                ],
              ),
            ),

            const Spacer(flex: 1),

            // Speech bubble text input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: _isExpanded ? 140 : 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFB8CFAF),
                          width: 6,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: _isExpanded
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Message display area
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Message text
                                      Text(
                                        'How is your day?',
                                        style: const TextStyle(
                                          color: Color(0xFF3B5D3B),
                                          fontSize: 13,
                                        ),
                                      ),
                                      // "user" label top right
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _lastMessage.isNotEmpty ? _lastMessage : 'user',
                                          style: const TextStyle(
                                            color: Color(0xFF2F4F3A),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Input bar
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFA8C3B5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _textController,
                                            style: const TextStyle(
                                              color: Color(0xFF2F4F3A),
                                              fontSize: 13,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: 'user input',
                                              hintStyle: TextStyle(
                                                color: Color(0xFF3B5D3B),
                                                fontSize: 13,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                            ),
                                            onSubmitted: (value) {
                                              if (value.isNotEmpty) {
                                                setState(() {
                                                  _lastMessage = value;
                                                  _textController.clear();
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        // Arrow button
                                        GestureDetector(
                                          onTap: () {
                                            if (_textController.text.isNotEmpty) {
                                              setState(() {
                                                _lastMessage = _textController.text;
                                                _textController.clear();
                                              });
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Text(
                                              '>',
                                              style: TextStyle(
                                                color: Color(0xFF3B5D3B),
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          // Collapsed state — just show a hint
                          : const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 70, vertical: 14),
                              child: Text(
                                'Tell me about your day',
                                style: TextStyle(
                                  color: Color(0xFF3B5D3B),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                    ),
                  ),
                  // Speech bubble pointer (always visible)
                  CustomPaint(
                    size: const Size(40, 20),
                    painter: _SpeechBubblePointer(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 2),

            // Plant illustration
            // _PlantIllustration(),
            // Plant illustration (image)
            SizedBox(
              width: 200, // adjust size to match your UI
              height: 300,
              child: Image.asset(
                'assets/images/plant_sample.png',
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
          color: Theme.of(context).colorScheme.surfaceContainer,
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
      child: Image.asset('assets/icons/sun_icon.png', fit: BoxFit.contain),
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
  final Color color;
  const _SpeechBubblePointer({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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