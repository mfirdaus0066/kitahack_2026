import 'package:flutter/material.dart';
import '../screens/collection.dart';
import '../controller/garden_controller.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  int _selectedIndex = 0;
  final Map<int, Map<String, dynamic>> _gardenSpots =
      GardenController.instance.spots;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/home');
        break;
      case 2:
        Navigator.pushNamed(context, '/info');
        break;
      case 3:
        Navigator.pushNamed(context, '/user');
        break;
    }
  }

  Future<void> _onSpotTapped(int spotIndex) async {
    final placedIds = _gardenSpots.values
        .map((p) => p['plantId'] as String)
        .toList();

    final selectedPlant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CollectionScreen(placedPlantIds: placedIds),
      ),
    );

    if (selectedPlant != null) {
      setState(() {
        _gardenSpots[spotIndex] = selectedPlant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20854F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_CollaborationIcon(), _GlovesIcon()],
              ),
            ),

            const Spacer(flex: 1),

            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.76,
                  color: Colors.green,
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: CustomPaint(painter: _sandDivider()),
                ),

                /*Positioned(
                  top: 500,
                  right: -10,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..scale(-1.0, 1.0),
                    child: _stone(),
                  ),
                ),*/
                Positioned(
                  top: 490,
                  left: 75,
                  child: _emptySpot(
                    spotIndex: 0,
                    plantData: _gardenSpots[0],
                    onTap: _onSpotTapped,
                  ),
                ),

                Positioned(
                  top: 370,
                  left: 20,
                  child: _emptySpot(
                    spotIndex: 1,
                    plantData: _gardenSpots[1],
                    onTap: _onSpotTapped,
                  ),
                ),

                Positioned(
                  top: 250,
                  left: 5,
                  child: _emptySpot(
                    spotIndex: 2,
                    plantData: _gardenSpots[2],
                    onTap: _onSpotTapped,
                  ),
                ),

                Positioned(
                  top: 360,
                  right: 45,
                  child: _emptySpot(
                    spotIndex: 3,
                    plantData: _gardenSpots[3],
                    onTap: _onSpotTapped,
                  ),
                ),

                Positioned(
                  top: 500,
                  right: 5,
                  child: _emptySpot(
                    spotIndex: 4,
                    plantData: _gardenSpots[4],
                    onTap: _onSpotTapped,
                  ),
                ),

                Positioned(
                  top: 160,
                  left: 85,
                  child: _emptySpot(
                    spotIndex: 5,
                    plantData: _gardenSpots[5],
                    onTap: _onSpotTapped,
                  ),
                ),
                Positioned(
                  top: 240,
                  right: 10,
                  child: _emptySpot(
                    spotIndex: 6,
                    plantData: _gardenSpots[6],
                    onTap: _onSpotTapped,
                  ),
                ),
                Positioned(
                  top: 130,
                  right: 15,
                  child: _emptySpot(
                    spotIndex: 7,
                    plantData: _gardenSpots[7],
                    onTap: _onSpotTapped,
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 5,
                  child: _emptySpot(
                    spotIndex: 8,
                    plantData: _gardenSpots[8],
                    onTap: _onSpotTapped,
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: _emptySpot(
                    spotIndex: 9,
                    plantData: _gardenSpots[9],
                    onTap: _onSpotTapped,
                  ),
                ),
              ],
            ),

            const Spacer(flex: 1),
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

class _emptySpot extends StatelessWidget {
  final int spotIndex;
  final Map<String, dynamic>? plantData;
  final Function(int) onTap;

  const _emptySpot({
    super.key,
    required this.spotIndex,
    required this.plantData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(spotIndex),
      child: SizedBox(
        width: 100,
        height: 100,
        child: Column(
          children: [
            plantData != null
                ? SizedBox(
                    width: 65,
                    height: 65,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: -2,
                          child: Image.asset(
                            plantData!['imagePath'],
                            width: 65,
                            height: 65,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/icons/add_plant_icon.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
            const SizedBox(height: 5),
            _rock(),
          ],
        ),
      ),
    );
  }
}

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

class _stone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 175,
      child: Image.asset('assets/images/stone.png', fit: BoxFit.contain),
    );
  }
}

class _sandDivider extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 225, 205, 173)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(size.width * 0, size.height * 0);

    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.10,
      size.width * 0.5,
      size.height * 0.20,
    );

    path.quadraticBezierTo(
      size.width * 0.60,
      size.height * 0.45,
      size.width * 0.4,
      size.height * 0.45,
    );

    path.quadraticBezierTo(
      size.width * 0.20,
      size.height * 0.50,
      size.width * 0.40,
      size.height * 0.70,
    );

    path.quadraticBezierTo(
      size.width * 0.40,
      size.height * 0.70,
      size.width * 0.49,
      size.height * 0.80,
    );

    path.quadraticBezierTo(
      size.width * 0.60,
      size.height * 0.90,
      size.width * 0.40,
      size.height,
    );

    path.lineTo(size.width * 0.6, size.height * 1.6);
    path.lineTo(size.width * 0.6, size.height * 1.1);
    path.lineTo(size.width * 0.4, size.height * 1.1);

    path.quadraticBezierTo(
      size.width * 0.90,
      size.height * 0.98,
      size.width * 0.70,
      size.height * 0.75,
    );

    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.70,
      size.width * 0.65,
      size.height * 0.55,
    );

    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.40,
      size.width * 0.7,
      size.height * 0.35,
    );

    path.quadraticBezierTo(
      size.width * 0.64,
      size.height * 0.30,
      size.width * 0.64,
      size.height * 0.3,
    );

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.05,
      size.width * 1,
      size.height * 0,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
          color: isSelected ? const Color(0xFF5A7C5A) : null,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
