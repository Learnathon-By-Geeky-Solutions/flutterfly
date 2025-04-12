import 'package:flutter/material.dart';
import 'package:quickdeal/features/home/client_home/presentation/screens/client_home.dart';

class ClientBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final Widget child;

  const ClientBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: child, // THIS IS NOW DYNAMIC FROM go_router
        floatingActionButton: FloatingActionButton(
          onPressed: () => onItemTapped(2),
          backgroundColor: const Color(0xFFFF4D6D),
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomAppBar(
              color: const Color(0xFF1A2639),
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(0, Icons.home_outlined, 'Home'),
                    _buildNavItem(1, Icons.description_outlined, 'My RFQs'),
                    const SizedBox(width: 40),
                    _buildNavItem(3, Icons.access_time_outlined, 'Ongoing Bids'),
                    _buildNavItem(4, Icons.person_outlined, 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = selectedIndex == index;
    final Color activeColor = const Color(0xFFFF4D6D);
    final Color inactiveColor = Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        onTap: () => onItemTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(1.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 28,
                ),
              ),
              AnimatedOpacity(
                opacity: isSelected ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? activeColor : inactiveColor,
                    fontSize: isSelected ? 0 : 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(top: isSelected ? 4 : 0),
                width: isSelected ? 6 : 0,
                height: isSelected ? 6 : 0,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
