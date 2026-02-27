import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/collection.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  int _selectedIndex = 0;
  final Map<int, String> _gardenSpots = {};
  bool isDeleteMode = false;
  String _currentMood = 'neutral';

  @override
  void initState() {
    super.initState();
    _loadGardenSpots();
    _loadCurrentMood();
  }

  Future<void> _loadCurrentMood() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final mood = userDoc.data()?['currentMood'] ?? 'neutral';
    setState(() {
      _currentMood = mood;
    });
  }

  Future<void> _loadGardenSpots() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('gardenSpots')
        .get();

    final Map<int, String> loaded = {};
    for (final doc in snapshot.docs) {
      final spotIndex = int.tryParse(doc.id);
      if (spotIndex != null && doc.data()['plantId'] != null) {
        loaded[spotIndex] = doc.data()['plantId'] as String;
      }
    }

    setState(() {
      _gardenSpots.addAll(loaded);
    });
  }

  Future<void> _saveSpotToFirestore(int spotIndex, String plantId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('gardenSpots')
        .doc(spotIndex.toString())
        .set({'plantId': plantId});
  }

  Future<void> _deleteSpotFromFirestore(int spotIndex) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('gardenSpots')
        .doc(spotIndex.toString())
        .delete();
  }

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
    if (_gardenSpots.containsKey(spotIndex)) {
      final plantId = _gardenSpots[spotIndex]!;

      final plantDoc = await FirebaseFirestore.instance
          .collection('plants')
          .doc(plantId)
          .get();

      if (!plantDoc.exists) return;

      final plantName = plantDoc['name'] ?? 'Plant';
      final imagePath = _currentMood == 'sad'
          ? (plantDoc['badImagePath'] ?? 'assets/images/plant_sample.png')
          : (plantDoc['goodImagePath'] ?? 'assets/images/plant_sample.png');

      if (!mounted) return;

      final action = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          title: Text(
            plantName,
            style: const TextStyle(
              color: Color(0xFF20854F),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'info'),
                  child: const Text(
                    'View Info',
                    style: TextStyle(color: Color(0xFF5A7C5A)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'change'),
                  child: const Text(
                    'Change Plant',
                    style: TextStyle(
                      color: Color(0xFF20854F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      if (action == 'info') {
        Navigator.pushNamed(context, '/info', arguments: plantId);
        return;
      } else if (action == 'change') {
        // fall through to collection picker
      } else {
        return;
      }
    }

    final placedIds = _gardenSpots.values.toList();

    final selectedPlant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CollectionScreen(placedPlantIds: placedIds),
      ),
    );

    if (selectedPlant != null) {
      final plantId = selectedPlant['plantId'] as String;
      setState(() {
        _gardenSpots[spotIndex] = plantId;
      });
      await _saveSpotToFirestore(spotIndex, plantId);
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
                children: [
                  _CollaborationIcon(),
                  _GlovesIcon(
                    isDeleteMode: isDeleteMode,
                    onTap: () {
                      setState(() {
                        isDeleteMode = !isDeleteMode;
                      });
                    },
                  ),
                ],
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

                Positioned(
                  top: 490,
                  left: 75,
                  child: _emptySpot(
                    spotIndex: 0,
                    plantId: _gardenSpots[0],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(0);
                      setState(() => _gardenSpots.remove(0));
                    },
                  ),
                ),
                Positioned(
                  top: 370,
                  left: 20,
                  child: _emptySpot(
                    spotIndex: 1,
                    plantId: _gardenSpots[1],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(1);
                      setState(() => _gardenSpots.remove(1));
                    },
                  ),
                ),
                Positioned(
                  top: 250,
                  left: 5,
                  child: _emptySpot(
                    spotIndex: 2,
                    plantId: _gardenSpots[2],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(2);
                      setState(() => _gardenSpots.remove(2));
                    },
                  ),
                ),
                Positioned(
                  top: 360,
                  right: 45,
                  child: _emptySpot(
                    spotIndex: 3,
                    plantId: _gardenSpots[3],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(3);
                      setState(() => _gardenSpots.remove(3));
                    },
                  ),
                ),
                Positioned(
                  top: 500,
                  right: 5,
                  child: _emptySpot(
                    spotIndex: 4,
                    plantId: _gardenSpots[4],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(4);
                      setState(() => _gardenSpots.remove(4));
                    },
                  ),
                ),
                Positioned(
                  top: 160,
                  left: 85,
                  child: _emptySpot(
                    spotIndex: 5,
                    plantId: _gardenSpots[5],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(5);
                      setState(() => _gardenSpots.remove(5));
                    },
                  ),
                ),
                Positioned(
                  top: 240,
                  right: 10,
                  child: _emptySpot(
                    spotIndex: 6,
                    plantId: _gardenSpots[6],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(6);
                      setState(() => _gardenSpots.remove(6));
                    },
                  ),
                ),
                Positioned(
                  top: 130,
                  right: 15,
                  child: _emptySpot(
                    spotIndex: 7,
                    plantId: _gardenSpots[7],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(7);
                      setState(() => _gardenSpots.remove(7));
                    },
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 5,
                  child: _emptySpot(
                    spotIndex: 8,
                    plantId: _gardenSpots[8],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(8);
                      setState(() => _gardenSpots.remove(8));
                    },
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: _emptySpot(
                    spotIndex: 9,
                    plantId: _gardenSpots[9],
                    onTap: _onSpotTapped,
                    isDeleteMode: isDeleteMode,
                    currentMood: _currentMood,
                    onDelete: () async {
                      await _deleteSpotFromFirestore(9);
                      setState(() => _gardenSpots.remove(9));
                    },
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
          padding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
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
  final VoidCallback onTap;
  final bool isDeleteMode;

  const _GlovesIcon({
    super.key,
    required this.onTap,
    required this.isDeleteMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Image.asset(
          'assets/icons/gloves_icon.png',
          fit: BoxFit.contain,
          color: isDeleteMode ? const Color(0xFF5A7C5A) : null,
        ),
      ),
    );
  }
}

class _emptySpot extends StatelessWidget {
  final int spotIndex;
  final String? plantId;
  final Function(int) onTap;
  final bool isDeleteMode;
  final String currentMood;
  final VoidCallback onDelete;

  const _emptySpot({
    super.key,
    required this.spotIndex,
    required this.plantId,
    required this.onTap,
    required this.isDeleteMode,
    required this.currentMood,
    required this.onDelete,
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
            plantId != null
                ? FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('plants')
                        .doc(plantId)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox(width: 65, height: 65);
                      }
                      // Switch image based on mood
                      final imagePath = currentMood == 'sad'
                          ? (snapshot.data!['badImagePath'] ??
                              'assets/images/plant_sample.png')
                          : (snapshot.data!['goodImagePath'] ??
                              'assets/images/plant_sample.png');

                      return SizedBox(
                        width: 65,
                        height: 65,
                        child: Stack(
                          children: [
                            Image.asset(
                              imagePath,
                              width: 65,
                              height: 65,
                              fit: BoxFit.contain,
                            ),
                            if (isDeleteMode)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: onDelete,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(3),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
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
      child:
          Image.asset('assets/images/garden_rock.png', fit: BoxFit.contain),
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