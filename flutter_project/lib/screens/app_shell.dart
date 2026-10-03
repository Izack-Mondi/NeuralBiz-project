import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/auth_controller.dart';
import 'auth/login_screen.dart';
import '../widgets/nexify_transitions.dart';
import 'auth/profile_setup.dart';
import 'home/home_feed_screen.dart';
import 'market/market_screen.dart';
import 'network/network_screen.dart';
import 'opportunities/opportunity_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<Widget> _destinations = const [
    HomeFeedScreen(),
    NetworkScreen(),
    MarketScreen(),
    OpportunityScreen(),
    _ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: _selectedIndex, children: _destinations),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
      (icon: Icons.home_filled, label: 'Home'),
      (icon: Icons.people_outline, label: 'Network'),
      (icon: Icons.shopping_cart_outlined, label: 'Market'),
      (icon: Icons.lightbulb_outline, label: 'Opp.'),
      (icon: Icons.person_outline, label: 'Profile'),
    ];

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      backgroundColor: const Color(0xFF0B0D0F),
      selectedItemColor: const Color(0xFF22C55E),
      unselectedItemColor: const Color(0xFFBFC2C8),
      type: BottomNavigationBarType.fixed,
      items: [
        for (final item in items)
          BottomNavigationBarItem(icon: Icon(item.icon), label: item.label),
      ],
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  NexifyTransitions.fadeSlide(
                    const ProfileSetupScreen(isEditing: true),
                    horizontal: true,
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Complete profile'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                await context.read<AuthController>().logout();
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
