import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  int _selectedIndex = 2;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/garden');
        break;
      case 1:
        Navigator.pushNamed(context, '/home');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushNamed(context, '/user');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      backgroundColor: const Color(0xFF20854F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 10.0,
                right: 20.0,
                bottom: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_LogoIcon()],
              ),
            ),

            const Spacer(flex: 1),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: plantId == null
                  ? const Center(
                      child: Text(
                        'Tap a plant in your garden\nto view its info',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5A7C5A),
                        ),
                      ),
                    )
                  : FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('plants')
                          .doc(plantId)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final plant = snapshot.data!;
                        final imagePath = plant['goodImagePath'] ??
                            'assets/images/plant_sample.png';
                        final name = plant['name'] ?? 'Plant name';
                        final habitat = plant['habitat'] ?? '??';
                        final lifespan =
                            plant['lifespan']?.toString() ?? '??';
                        final funFact = plant['funfact'] ?? '???';

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFB8CFAF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset(
                                imagePath,
                                height: 150,
                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B5D3B),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Container(
                              width: double.infinity,
                              height:
                                  MediaQuery.of(context).size.height * 0.28,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFA8C3B5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'habitat: $habitat\n'
                                'lifespan: $lifespan\n'
                                'fun fact: $funFact',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2F4F3A),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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

class _LogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }
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