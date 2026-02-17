  import 'package:arnima/main.dart';
import 'package:flutter/material.dart';

  class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
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
                      onTap:(){
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

  // Plant illustration widget
  // Not needed now, using image instead

  // class _PlantIllustration extends StatelessWidget {
  //   @override
  //   Widget build(BuildContext context) {
  //     return Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         // Plant leaves
  //         SizedBox(
  //           width: 150,
  //           height: 180,
  //           child: Stack(
  //             alignment: Alignment.bottomCenter,
  //             children: [
  //               // Back leaves
  //               Positioned(
  //                 bottom: 0,
  //                 child: _Leaf(
  //                   width: 50,
  //                   height: 120,
  //                   color: const Color(0xFF81C784),
  //                 ),
  //               ),
  //               // Middle back leaves
  //               Positioned(
  //                 bottom: 20,
  //                 left: 30,
  //                 child: Transform.rotate(
  //                   angle: -0.2,
  //                   child: _Leaf(
  //                     width: 45,
  //                     height: 110,
  //                     color: const Color(0xFF81C784),
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 20,
  //                 right: 30,
  //                 child: Transform.rotate(
  //                   angle: 0.2,
  //                   child: _Leaf(
  //                     width: 45,
  //                     height: 110,
  //                     color: const Color(0xFF81C784),
  //                   ),
  //                 ),
  //               ),
  //               // Front middle leaves
  //               Positioned(
  //                 bottom: 10,
  //                 left: 20,
  //                 child: Transform.rotate(
  //                   angle: -0.3,
  //                   child: _Leaf(
  //                     width: 48,
  //                     height: 115,
  //                     color: const Color(0xFF9CCC65),
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 10,
  //                 right: 20,
  //                 child: Transform.rotate(
  //                   angle: 0.3,
  //                   child: _Leaf(
  //                     width: 48,
  //                     height: 115,
  //                     color: const Color(0xFF9CCC65),
  //                   ),
  //                 ),
  //               ),
  //               // Front center leaf
  //               Positioned(
  //                 bottom: 5,
  //                 child: _Leaf(
  //                   width: 52,
  //                   height: 125,
  //                   color: const Color(0xFFAED581),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         // Pot
  //         Container(
  //           width: 120,
  //           height: 60,
  //           decoration: BoxDecoration(
  //             color: const Color(0xFFD2936F),
  //             borderRadius: const BorderRadius.only(
  //               bottomLeft: Radius.circular(8),
  //               bottomRight: Radius.circular(8),
  //             ),
  //           ),
  //           child: CustomPaint(
  //             painter: _PotPainter(),
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         // Table
  //         _TableWidget(),
  //       ],
  //     );
  //   }
  // }

  // // Leaf widget
  // class _Leaf extends StatelessWidget {
  //   final double width;
  //   final double height;
  //   final Color color;

  //   const _Leaf({
  //     required this.width,
  //     required this.height,
  //     required this.color,
  //   });

  //   @override
  //   Widget build(BuildContext context) {
  //     return CustomPaint(
  //       size: Size(width, height),
  //       painter: _LeafPainter(color),
  //     );
  //   }
  // }

  // class _LeafPainter extends CustomPainter {
  //   final Color color;

  //   _LeafPainter(this.color);

  //   @override
  //   void paint(Canvas canvas, Size size) {
  //     final paint = Paint()
  //       ..color = color
  //       ..style = PaintingStyle.fill;

  //     final path = Path()
  //       ..moveTo(size.width / 2, size.height)
  //       ..quadraticBezierTo(0, size.height * 0.6, size.width / 2, 0)
  //       ..quadraticBezierTo(size.width, size.height * 0.6, size.width / 2, size.height)
  //       ..close();

  //     canvas.drawPath(path, paint);
  //   }

  //   @override
  //   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  // }

  // // Pot painter
  // class _PotPainter extends CustomPainter {
  //   @override
  //   void paint(Canvas canvas, Size size) {
  //     final paint = Paint()
  //       ..color = const Color(0xFFBF8660)
  //       ..style = PaintingStyle.fill;

  //     // Rim
  //     final rimRect = RRect.fromRectAndRadius(
  //       Rect.fromLTWH(0, 0, size.width, 8),
  //       const Radius.circular(4),
  //     );
  //     canvas.drawRRect(rimRect, paint);
  //   }

  //   @override
  //   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  // }

  // // Table widget
  // class _TableWidget extends StatelessWidget {
  //   @override
  //   Widget build(BuildContext context) {
  //     return CustomPaint(
  //       size: const Size(250, 120),
  //       painter: _TablePainter(),
  //     );
  //   }
  // }

  // class _TablePainter extends CustomPainter {
  //   @override
  //   void paint(Canvas canvas, Size size) {
  //     final paint = Paint()
  //       ..color = const Color(0xFF6D4C41)
  //       ..style = PaintingStyle.fill;

  //     // Table top
  //     final tableTop = RRect.fromRectAndRadius(
  //       Rect.fromLTWH(30, 0, size.width - 60, 20),
  //       const Radius.circular(4),
  //     );
  //     canvas.drawRRect(tableTop, paint);

  //     // Inner line on table top
  //     paint.color = const Color(0xFF8D6E63);
  //     final innerRect = RRect.fromRectAndRadius(
  //       Rect.fromLTWH(40, 5, size.width - 80, 10),
  //       const Radius.circular(2),
  //     );
  //     canvas.drawRRect(innerRect, paint);

  //     // Legs
  //     paint.color = const Color(0xFF5D4037);
  //     final legWidth = 12.0;
      
  //     // Left leg
  //     final leftLegPath = Path()
  //       ..moveTo(50, 20)
  //       ..lineTo(30, size.height)
  //       ..lineTo(30 + legWidth, size.height)
  //       ..lineTo(50 + legWidth, 20)
  //       ..close();
  //     canvas.drawPath(leftLegPath, paint);

  //     // Right leg
  //     final rightLegPath = Path()
  //       ..moveTo(size.width - 50 - legWidth, 20)
  //       ..lineTo(size.width - 30 - legWidth, size.height)
  //       ..lineTo(size.width - 30, size.height)
  //       ..lineTo(size.width - 50, 20)
  //       ..close();
  //     canvas.drawPath(rightLegPath, paint);

  //     // Cross support
  //     paint.strokeWidth = 8;
  //     paint.style = PaintingStyle.stroke;
  //     canvas.drawLine(
  //       Offset(40, size.height - 30),
  //       Offset(size.width - 40, size.height - 30),
  //       paint,
  //     );
  //   }

  //   @override
  //   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  // }

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