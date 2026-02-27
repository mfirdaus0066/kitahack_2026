import 'package:arnima/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/journal_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExpanded = false;
  String _lastMessage = '';
  final TextEditingController _textController = TextEditingController();
  int _selectedIndex = 1;

  final JournalService _journalService = JournalService();
  bool _isAnalyzing = false;
  String _aiConclusion = '';
  bool _hasRespondedToday = false;
  String _currentMood = 'neutral';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAndShowPopupIfNeeded();
      _checkTodayResponse();
      _loadCurrentMood();
    });
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

  Future<void> _checkTodayResponse() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final currentPlantId = userDoc.data()?['currentPlantId'];
    if (currentPlantId == null) return;

    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final existing = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('dailyResponses')
        .doc(todayStr)
        .get();

    if (existing.exists) {
      setState(() {
        _hasRespondedToday = true;
        _lastMessage = existing.data()?['userMessage'] ?? '';
        _aiConclusion = existing.data()?['aiResponse'] ?? '';
      });
    }
  }

  Future<void> _loadAndShowPopupIfNeeded() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = userDoc.data();
    if (data == null) return;

    final currentPlantId = data['currentPlantId'];
    if (currentPlantId == null) return;

    final plantAssignedAt =
        (data['plantAssignedAt'] as Timestamp?)?.toDate();
    final popupShownAt = (data['popupShownAt'] as Timestamp?)?.toDate();

    if (plantAssignedAt == null) return;
    if (popupShownAt != null && !plantAssignedAt.isAfter(popupShownAt))
      return;

    final plantDoc = await FirebaseFirestore.instance
        .collection('plants')
        .doc(currentPlantId)
        .get();

    if (!plantDoc.exists) return;

    final plantName = plantDoc['name'] ?? '';
    final imagePath =
        plantDoc['goodImagePath'] ?? 'assets/images/plant_sample.png';

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'popupShownAt': FieldValue.serverTimestamp()});

    if (!mounted) return;
    _showWeeklyPlantPopup(plantName, imagePath);
  }

  void _showWeeklyPlantPopup(String plantName, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor:
            Theme.of(context).colorScheme.surfaceContainerHighest,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Image.asset(imagePath,
                width: 100, height: 100, fit: BoxFit.contain),
            const SizedBox(height: 12),
            const Text(
              'This week you got',
              style: TextStyle(fontSize: 14, color: Color(0xFF5A7C5A)),
            ),
            const SizedBox(height: 4),
            Text(
              plantName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF20854F),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Yay!',
                style: TextStyle(
                    color: Color(0xFF20854F),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlreadyRespondedPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor:
            Theme.of(context).colorScheme.surfaceContainerHighest,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌿', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            const Text(
              'Come back tomorrow!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF20854F),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You\'ve already shared your thoughts today. Your plant is happy!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF5A7C5A)),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                    color: Color(0xFF20854F),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit(String text) async {
    if (text.isEmpty) return;

    if (_hasRespondedToday) {
      _showAlreadyRespondedPopup();
      return;
    }

    setState(() {
      _lastMessage = text;
      _textController.clear();
      _isAnalyzing = true;
      _aiConclusion = '';
    });

    try {
      final result = await _journalService.submitJournalEntry(text);
      final aiResponse = result['conclusion'] ?? '';
      final mood = result['mood'] ?? 'neutral';

      setState(() {
        _isAnalyzing = false;
        _aiConclusion = aiResponse;
        _hasRespondedToday = true;
        _currentMood = mood;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/garden');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, '/info');
        break;
      case 3:
        Navigator.pushNamed(context, '/user');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF20854F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => MyApp.of(context).toggleTheme(),
                    child: _SunIcon(),
                  ),
                  _WateringCanIcon(),
                ],
              ),
            ),

            const Spacer(flex: 1),

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
                      constraints: BoxConstraints(
                        minHeight: _isExpanded ? 120 : 70,
                        maxHeight: _isExpanded ? 300 : 70,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFB8CFAF), width: 6),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: _isExpanded
                          ? SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 12, 16, 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'How is your day?',
                                          style: TextStyle(
                                              color: Color(0xFF3B5D3B),
                                              fontSize: 13),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            _lastMessage.isNotEmpty
                                                ? _lastMessage
                                                : '',
                                            style: const TextStyle(
                                                color: Color(0xFF2F4F3A),
                                                fontSize: 13),
                                          ),
                                        ),
                                        if (_isAnalyzing)
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(top: 4),
                                            child: LinearProgressIndicator(
                                              color: Color(0xFF20854F),
                                              backgroundColor:
                                                  Color(0xFFB8CFAF),
                                            ),
                                          ),
                                        if (_aiConclusion.isNotEmpty &&
                                            !_isAnalyzing)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4),
                                            child: Text(
                                              _aiConclusion,
                                              style: const TextStyle(
                                                color: Color(0xFF20854F),
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (!_hasRespondedToday)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 0, 8, 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFA8C3B5),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: SizedBox(
                                          height: 30,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller:
                                                      _textController,
                                                  maxLines: 1,
                                                  textAlignVertical:
                                                      TextAlignVertical
                                                          .center,
                                                  style: const TextStyle(
                                                    color:
                                                        Color(0xFF2F4F3A),
                                                    fontSize: 12,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Tell me about your day...',
                                                    hintStyle: TextStyle(
                                                      color:
                                                          Color(0xFF3B5D3B),
                                                      fontSize: 13,
                                                    ),
                                                    border:
                                                        InputBorder.none,
                                                    isCollapsed: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 6,
                                                    ),
                                                  ),
                                                  onSubmitted: (value) {
                                                    if (value.isNotEmpty) {
                                                      _handleSubmit(value);
                                                    }
                                                  },
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (_textController
                                                      .text.isNotEmpty) {
                                                    _handleSubmit(
                                                        _textController
                                                            .text);
                                                  }
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_circle_right_outlined,
                                                    color:
                                                        Color(0xFF3B5D3B),
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_hasRespondedToday)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 0, 8, 8),
                                      child: Center(
                                        child: Text(
                                          'Come back tomorrow 🌿',
                                          style: const TextStyle(
                                            color: Color(0xFF5A7C5A),
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 70, vertical: 14),
                              child: Text(
                                'Tell me about your day',
                                style: TextStyle(
                                    color: Color(0xFF3B5D3B), fontSize: 13),
                              ),
                            ),
                    ),
                  ),
                  CustomPaint(
                    size: const Size(40, 20),
                    painter: _SpeechBubblePointer(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
            ),

            // Plant of the week — switches image based on mood
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const SizedBox(
                    width: 200,
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final currentPlantId =
                    userSnapshot.data?.get('currentPlantId');
                if (currentPlantId == null) {
                  return const SizedBox(
                    width: 200,
                    height: 300,
                    child: Center(child: Text('No plant yet')),
                  );
                }

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('plants')
                      .doc(currentPlantId)
                      .get(),
                  builder: (context, plantSnapshot) {
                    if (!plantSnapshot.hasData) {
                      return const SizedBox(
                        width: 200,
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final plant = plantSnapshot.data!;

                    // Switch image based on current mood
                    final imagePath = _currentMood == 'sad'
                        ? (plant['badImagePath'] ??
                            'assets/images/plant_sample.png')
                        : (plant['goodImagePath'] ??
                            'assets/images/plant_sample.png');

                    return Column(
                      children: [
                        SizedBox(
                          width: 240,
                          height: 250,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -6,
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _plantTable(),
                      ],
                    );
                  },
                );
              },
            ),

            const Spacer(flex: 1),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 24.0),
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

class _WateringCanIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Image.asset('assets/icons/wateringCan_icon.png',
          fit: BoxFit.contain),
    );
  }
}

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

class _plantTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 200,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child:
                Image.asset('assets/images/table.png', fit: BoxFit.contain),
          ),
        ],
      ),
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