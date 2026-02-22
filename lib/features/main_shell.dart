import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/re_useable/bottom_nav_bar.dart';

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({
    required this.child,
    super.key,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the corresponding route
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/explore');
        break;
      case 2:
        context.go('/campaigns');
        break;
      case 3:
        context.go('/wallet');
        break;
      case 4:
        context.go('/account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update current index based on current route
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      _currentIndex = 0;
    } else if (location.startsWith('/explore')) {
      _currentIndex = 1;
    } else if (location.startsWith('/campaigns')) {
      _currentIndex = 2;
    } else if (location.startsWith('/wallet')) {
      _currentIndex = 3;
    } else if (location.startsWith('/account')) {
      _currentIndex = 4;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
