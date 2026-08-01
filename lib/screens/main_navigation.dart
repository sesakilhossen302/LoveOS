import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/app_state.dart';
import '../core/theme.dart';
import '../widgets/starfield_background.dart';

import 'tabs/home_tab.dart';
import 'tabs/mood_tab.dart';
import 'tabs/contacts_tab.dart';
import 'tabs/games_tab.dart';
import 'tabs/memories_tab.dart';
import 'tabs/profile_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<LoveAppState>(context, listen: false);
    _pageController = PageController(initialPage: appState.currentTabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    final appState = Provider.of<LoveAppState>(context, listen: false);
    appState.setTabIndex(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<LoveAppState>(context);
    final currentIndex = appState.currentTabIndex;

    final List<Widget> tabs = [
      HomeTab(onNavigateToTab: _onTabSelected),
      const MoodTab(),
      const ContactsTab(),
      const GamesTab(),
      const MemoriesTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      body: StarfieldBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Tab Body View
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    appState.setTabIndex(index);
                  },
                  children: tabs,
                ),
              ),

              // Glassmorphic Bottom Navigation Bar
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      border: const Border(
                        top: BorderSide(
                          color: LoveTheme.cardBorderGlass,
                          width: 1,
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(width: 8),
                          _buildNavItem(0, Icons.home_rounded, 'Home', currentIndex),
                          _buildNavItem(1, Icons.spa_rounded, 'Mood', currentIndex),
                          _buildNavItem(2, Icons.contacts_rounded, 'Contacts', currentIndex),
                          _buildNavItem(3, Icons.sports_esports_rounded, 'Arcade', currentIndex),
                          _buildNavItem(4, Icons.favorite_rounded, 'Memories', currentIndex),
                          _buildNavItem(5, Icons.person_rounded, 'Profile', currentIndex),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, String label, int currentIndex) {
    final isSelected = index == currentIndex;

    return InkWell(
      onTap: () => _onTabSelected(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? LoveTheme.primaryNeonPink.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? LoveTheme.primaryNeonPink : Colors.white54,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
