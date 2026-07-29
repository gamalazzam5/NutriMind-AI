import 'package:flutter/material.dart';

import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../scanner/presentation/screens/scanner_screen.dart';
import '../widgets/app_bottom_nav_bar.dart';

const _scannerTabIndex = 1;
const _chatTabIndex = 2;

/// Root app shell hosting the Home / Scanner / AI Chat / Profile tabs behind
/// the shared bottom navigation bar.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  void _goToScanner() => setState(() => _currentIndex = _scannerTabIndex);

  void _goToChat() => setState(() => _currentIndex = _chatTabIndex);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(onScanFoodTap: _goToScanner, onAskAiTap: _goToChat),
      const ScannerScreen(),
      const ChatScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
