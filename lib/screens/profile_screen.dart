import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';
// import '../widgets/bottom_navbar.dart'; // Ensure this path is correct

// Mock BottomNavbar for completeness since the original code relies on it

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Use a slightly lighter/more saturated brown for better contrast on text
    const Color darkBrown = Color(0xFF5D4037); 
    // Use the color from the back button background for consistency
    const Color backButtonBrown = Color.fromARGB(255, 93, 57, 44);

    return Scaffold(
      backgroundColor: Colors.white, // Ensure scaffold background is white if the Stack doesn't cover all
      // Extend the body to be behind the bottom navbar
      extendBody: true, 

      // Use Stack to place content over the background image
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.asset(
              // Assuming you have an asset named 'backgroundHome1.jpg'
              // Add this image to your 'assets' folder and update pubspec.yaml
              'assets/backgroundHome1.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Custom Header/App Bar Area (Back Button and Title)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar padding + extra space
            left: 20,
            child: Row(
              children: [
                // Back Button Container
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: backButtonBrown,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove default padding
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Profile Text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Profile Card (Centered, occupying most of the screen)
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: screenHeight * 0.15, // Push content down below the header
                bottom: screenHeight * 0.15, // Space for the bottom navbar
              ),
              child: Container(
                width: screenWidth * 0.88, // Slightly wider card
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Picture with Edit Icon
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          // Placeholder image (replace with your asset/network image)
                          // You'll need to add 'assets/profile_pic.jpg' and update pubspec.yaml
                          backgroundImage: AssetImage('assets/fotoPP.jpg'), 
                          backgroundColor: Colors.grey, // Fallback color
                        ),
                        Positioned( // Use Positioned for precise placement
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2), // Smaller padding
                            decoration: const BoxDecoration(
                              color: darkBrown, // Use dark brown color
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 4)
                              ]
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Input Fields
                    // The prototype labels are "Phone Number", "Email Address", "Phone Number"
                    // Correcting the first one to "Name" for logical UI, but keeping the prototype's placeholder text style
                    const CustomInputField(
                      label: "Name", // Label in prototype is "Phone Number"
                      hintText: "Christian Immanuel", // Placeholder for Name
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    const CustomInputField(
                      label: "Email Address",
                      hintText: "cimmanuel902@gmail.com", // Placeholder for Email
                      keyboardType: TextInputType.emailAddress,
                    ),
                    // The final input field
                    const SizedBox(height: 10),
                    const CustomInputField(
                      label: "Phone Number",
                      hintText: "085179678688", // Placeholder for Phone Number
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),

                    // Update Profile Button
                    ElevatedButton(
                      onPressed: () {
                        // Handle update profile logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBrown, 
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50), // Using 10px radius to match visual style
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Update Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Cancel Text Link
                    GestureDetector(
                      onTap: () {
                        // Handle cancel logic
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: darkBrown,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 4),
    );
  }
}

// Custom Input Field Widget to be placed at the bottom of the file
class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  // Color matching the prototype's input field background
  static const Color inputFieldBackgroundColor = Color(0xFFF7EAC7); 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (e.g., Phone Number, Email Address)
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        // Custom Styled TextField
        Container(
          height: 50, // Fixed height to match prototype's look
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: inputFieldBackgroundColor, 
            borderRadius: BorderRadius.circular(50),
            // The prototype doesn't show a strong border, so removing or using a very light one is best.
            // border: Border.all(color: Colors.brown.shade200),
          ),
          child: TextField(
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.black), // Ensure text input is visible
            decoration: InputDecoration(
              hintText: hintText,
              // Match the grey/light brown color of the placeholder text
              hintStyle: TextStyle(color: const Color.fromARGB(255, 82, 39, 23), fontWeight: FontWeight.w100, fontSize: 13), 
              border: InputBorder.none, // Remove default border
              contentPadding: EdgeInsets.zero, // Minimal padding adjustment
            ),
          ),
        ),
      ],
    );
  }
}