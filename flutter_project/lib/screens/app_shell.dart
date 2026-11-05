import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/auth_controller.dart';
import 'auth/login_screen.dart';
import '../widgets/neuralbiz_transitions.dart';
import '../widgets/navigation/neuralbiz_bottom_nav.dart';
import 'auth/profile_setup.dart';
import 'home/home_feed_screen.dart';
import 'market/market_screen.dart';
import 'network/network_screen.dart';
import 'opportunities/opportunity_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  static final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

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
  void initState() {
    super.initState();
    AppShell.selectedIndex.addListener(_syncSelectedIndex);
  }

  void _syncSelectedIndex() {
    if (mounted && _selectedIndex != AppShell.selectedIndex.value) {
      setState(() => _selectedIndex = AppShell.selectedIndex.value);
    }
  }

  @override
  void dispose() {
    AppShell.selectedIndex.removeListener(_syncSelectedIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: _selectedIndex, children: _destinations),
      bottomNavigationBar: SafeArea(
        top: false,
        child: _buildBottomNavigation(),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
      NeuralBizBottomNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_filled,
        label: 'Home',
      ),
      NeuralBizBottomNavItem(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        label: 'Network',
      ),
      NeuralBizBottomNavItem(
        icon: Icons.storefront_outlined,
        activeIcon: Icons.storefront,
        label: 'Market',
      ),
      NeuralBizBottomNavItem(
        icon: Icons.lightbulb_outline,
        activeIcon: Icons.lightbulb,
        label: 'Opp',
      ),
      NeuralBizBottomNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: NeuralBizBottomNav(
        items: items,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          AppShell.selectedIndex.value = index;
        },
      ),
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
                  NeuralBizTransitions.fadeSlide(
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
