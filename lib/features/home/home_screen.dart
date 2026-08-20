import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../dashboard/dashboard_screen.dart';
import '../mood/mood_screen.dart';
import '../journal/journal_screen.dart';
import '../profile/profile_screen.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final screens = const [
    DashboardScreen(),
    MoodScreen(),
    JournalScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  final navItems = const [
    _NavItem(icon: Icons.home_rounded, label: "Home"),
    _NavItem(icon: Icons.favorite_rounded, label: "Mood"),
    _NavItem(icon: Icons.book_rounded, label: "Journal"),
    _NavItem(icon: Icons.chat_bubble_rounded, label: "Chat"),
    _NavItem(icon: Icons.person_rounded, label: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          bottom: false,
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(), // Only switch via bottom bar
            children: screens,
          ),
        ),
      ),
      bottomNavigationBar: _GlassNavBar(
        currentIndex: currentIndex,
        items: navItems,
        onTap: (index) {
          setState(() => currentIndex = index);
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
          );
        },
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// A floating, frosted-glass navigation bar — replaces the flat, opaque
/// BottomNavigationBar with something that reads as an object floating
/// above the gradient background, rather than a bar bolted to the
/// bottom edge of the screen.
class _GlassNavBar extends StatelessWidget {
  const _GlassNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Margin on all sides is what makes it "float" rather than
      // stick flush to the screen edges.
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        borderRadius: 28,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isSelected = index == currentIndex;
            return _NavIcon(
              item: items[index],
              isSelected: isSelected,
              onTap: () => onTap(index),
            );
          }),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // makes the whole tap area
                                          // clickable, not just the icon's
                                          // exact pixels
      child: AnimatedContainer(
        // AnimatedContainer automatically animates any change to its
        // properties (here: padding and decoration) between frames —
        // no manual AnimationController needed for this simple case.
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 18 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.accentGradient : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.pink.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isSelected ? Colors.white : Colors.white54,
              size: 22,
            ),
            // The label only appears next to the SELECTED icon — this
            // is what makes the nav bar feel alive: icons expand and
            // reveal their label as you tap between them, instead of
            // every label being visible and static all the time.
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}