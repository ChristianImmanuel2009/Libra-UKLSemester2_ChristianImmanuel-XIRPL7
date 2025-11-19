import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/news_screen.dart';
import '../screens/profile_screen.dart';
// Note: You might need to import screens for index 0 (Add) and 3 (Fav) as well

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  const BottomNavbar({super.key, required this.currentIndex});

  // Define the dark brown color used in the app
  static const Color darkBrown = Color(0xFF5D4037); 
  // Define the background color for the navbar (darker than white)
  static const Color navbarBackgroundColor = Color(0xFFEFEBE9); 
  // Define the inactive icon color (grey-brown)
  static const Color inactiveColor = Color(0xFFA1887F); 

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      // Use the defined light brown/cream background color
      color: navbarBackgroundColor,
      // You can keep CircularNotchedRectangle if you have a FloatingActionButton, 
      // but it doesn't appear to be used in the visual prototype provided.
      shape: const CircularNotchedRectangle(), 
      notchMargin: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [          
          // Index 1: News (Prototype shows a list/document icon)
          _navItem(context, Icons.format_list_bulleted, "News", 1), 
          // Index 2: Home (Prototype shows a solid house icon)
          _navItem(context, Icons.home, "Home", 2),
          // Index 4: Account (Prototype shows a person icon)
          _navItem(context, Icons.person_outline, "Account", 4), 
        ],
      ),
    );
  }

  // --- Nav Item Widget ---
  Widget _navItem(BuildContext context, IconData icon, String label, int index) {
    bool active = index == currentIndex;

    // --- Navigation Logic (same as before) ---
    void navigateToScreen() {
      // Use a Map for cleaner navigation logic
      final Map<int, Widget> screenMap = {
        2: const HomeScreen(),
        1: const NewsScreen(),
        4: const ProfileScreen(),
        // Add screens for 0 and 3 here
      };

      if (screenMap.containsKey(index)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screenMap[index]!),
        );
      }
    }

    // --- Visual Styling ---
    Widget iconWidget;
    
    // Custom styling for Add icon (Plus inside a Circle)
    if (index == 0) {
      iconWidget = Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: active ? darkBrown : Colors.transparent, // Active state has color
          shape: BoxShape.circle,
          border: Border.all(
            color: active ? darkBrown : inactiveColor,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? Colors.white : inactiveColor,
        ),
      );
    } 
    // Custom styling for Home icon (Solid House)
    else if (index == 2) {
      // Use the solid home icon for the home screen (active or inactive)
      iconWidget = Icon(
        active ? Icons.home : Icons.home_outlined, 
        size: 18,
        color: active ? darkBrown : inactiveColor,
      );
    }
    // Default styling for other icons (News, Fav, Account)
    else {
      iconWidget = Icon(
        icon,
        size: 18,
        color: active ? darkBrown : inactiveColor,
      );
    }

    // Wrap in GestureDetector for tap functionality
    return GestureDetector(
      onTap: navigateToScreen,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget, // Use the dynamically styled icon
            const SizedBox(height: 4), // Space between icon and text
            Text(
              label,
              style: TextStyle(
                color: active ? darkBrown : inactiveColor,
                fontWeight: FontWeight.w600,
                fontSize: 10, // Smaller font size for better fit
              ),
            ),
          ],
        ),
      ),
    );
  }
}