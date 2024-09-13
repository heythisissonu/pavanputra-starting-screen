import 'package:flutter/material.dart';
import 'dart:async'; 
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; 
import 'package:animated_text_kit/animated_text_kit.dart'; 
import 'dart:ui'; 
import 'login_page.dart'; // Import the LoginPage 
import 'register_page.dart'; // Import the RegisterPage 
import 'guest_page.dart'; // Import the GuestPage 

void main() => runApp( 
  const MaterialApp( 
    home: OnBoardingScreen(), 
    debugShowCheckedModeBanner: false, // Disable the debug banner 
  ), 
);

class OnBoardingScreen extends StatefulWidget { 
  const OnBoardingScreen({super.key}); 

  @override 
  OnBoardingScreenState createState() => OnBoardingScreenState(); 
} 

class OnBoardingScreenState extends State<OnBoardingScreen> { 
  final PageController _pageController = PageController(); // PageController for handling page swipes 
  int _currentPage = 0; // Tracks the current page 
  Timer? _autoScrollTimer; // Timer for automatic page scrolling 
  double _opacity = 0.5; // Initial opacity value for glowing effect 
  Timer? _glowTimer; // Timer for glowing effect animation 

  final List<Map<String, String>> _onBoardingData = [ 
    { 
      'image': 'lib/images/00.webp', 
      'title': ' ', 
      'description': ' ', 
    }, 
    { 
      'image': 'lib/images/01.webp', 
      'title': ' ', 
      'description': ' ', 
    }, 
    { 
      'image': 'lib/images/02.webp', 
      'title': 'NO ADS', 
      'description':'Focus on your fitness!', 
    }, 
    { 
      'image': 'lib/images/03.webp', 
      'title': 'YOU vs YOU', 
      'description': 'Start today!', 
    }, 
  ];

  @override 
  void initState() { 
    super.initState(); 
    _startAutoScroll(); // Start automatic scrolling of pages 
    _startGlowEffect(); // Start glowing animation 
  } 

  @override 
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages(); // Preload images for smooth scrolling, called in didChangeDependencies
  }

  @override 
  void dispose() { 
    _autoScrollTimer?.cancel(); // Cancel auto-scroll timer when disposed 
    _glowTimer?.cancel(); // Cancel glow timer when disposed 
    _pageController.dispose(); // Dispose page controller 
    super.dispose(); 
  }

  // Preload images to ensure they are available before display
  void _preloadImages() {
    for (var data in _onBoardingData) {
      precacheImage(AssetImage(data['image']!), context);
    }
  }

  void _startAutoScroll() { 
    // Set auto-scroll to move pages every 3 seconds
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) { 
      if (_currentPage < _onBoardingData.length - 1) { 
        _currentPage++; // Move to next page 
      } else { 
        _currentPage = 0; // Loop back to first page 
      } 
      _pageController.animateToPage( 
        _currentPage, 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut, // Smooth transition animation 
      ); 
    }); 
  }

  void _startGlowEffect() { 
    // Alternate the opacity between 0.5 and 1.0 to create a glowing effect
    _glowTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) { 
      setState(() { 
        _opacity = _opacity == 0.5 ? 1.0 : 0.5; 
      }); 
    }); 
  }

  // Handles manual page swipe events
  void _onPageChanged(int index) { 
    setState(() { 
      _currentPage = index; 
    }); 
    _autoScrollTimer?.cancel(); // Cancel auto-scroll when manually swiped 
    _startAutoScroll(); // Restart auto-scroll after swipe 
  }

  // Navigate to login page
  void _login() { 
    Navigator.push( 
      context, 
      MaterialPageRoute(builder: (context) => const LoginPage()), 
    ); 
  }

  // Navigate to register page
  void _register() { 
    Navigator.push( 
      context, 
      MaterialPageRoute(builder: (context) => const RegisterPage()), 
    ); 
  }

  // Navigate to guest page
  void _continueAsGuest() { 
    Navigator.push( 
      context, 
      MaterialPageRoute(builder: (context) => const GuestPage()), 
    ); 
  }

  // Colors used for the animated text
  static const colorizeColors = [ 
    Color.fromARGB(255, 246, 248, 255), 
    Color.fromARGB(255, 255, 102, 0), 
    Color.fromARGB(255, 255, 124, 1), 
    Color.fromARGB(255, 245, 12, 12), 
  ];

  @override 
  Widget build(BuildContext context) { 
    return Directionality( 
      textDirection: TextDirection.ltr, // Set text direction for UI 
      child: Scaffold( 
        body: Stack( // Stack the widgets on top of each other 
          children: [ 
            // Full-screen background image
            PageView.builder( 
              controller: _pageController, 
              itemCount: _onBoardingData.length, 
              onPageChanged: _onPageChanged, 
              itemBuilder: (context, index) { 
                final data = _onBoardingData[index]; 
                return Stack( 
                  fit: StackFit.expand, 
                  children: [ 
                    Image.asset( 
                      data['image']!, 
                      fit: BoxFit.cover, 
                      width: double.infinity, 
                      height: double.infinity, 
                    ), 
                    SafeArea( 
                      child: Padding( 
                        padding: const EdgeInsets.only(left: 10.0, top: 110.0, right: 10.0, bottom: 0.0), 
                        child: Column( 
                          mainAxisSize: MainAxisSize.min, 
                          children: [ 
                            AnimatedTextKit( 
                              animatedTexts: [ 
                                ColorizeAnimatedText( 
                                  data['title']!, 
                                  textStyle: const TextStyle( 
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                  ), 
                                  colors: colorizeColors, 
                                ), 
                              ], 
                              isRepeatingAnimation: false, // Stop repeating animation
                            ), 
                            const SizedBox(height: 1), 
                            Padding( 
                              padding: const EdgeInsets.symmetric(horizontal: 10.0), 
                              child: AnimatedTextKit( 
                                animatedTexts: [ 
                                  ColorizeAnimatedText( 
                                    data['description']!, 
                                    textAlign: TextAlign.center, 
                                    textStyle: const TextStyle(fontSize: 16, wordSpacing: -1), 
                                    colors: colorizeColors, 
                                    speed: const Duration(milliseconds: 50), 
                                  ), 
                                ], 
                                isRepeatingAnimation: false, 
                              ), 
                            ), 
                          ], 
                        ), 
                      ), 
                    ), 
                  ], 
                ); 
              }, 
            ), 
            // Blur and translucent container
            Positioned( 
              bottom: 0, 
              left: 0, 
              right: 0, 
              child: ClipRRect( 
                borderRadius: const BorderRadius.only( 
                  topLeft: Radius.circular(25.0), 
                  topRight: Radius.circular(25.0), 
                ), 
                child: BackdropFilter( 
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
                  child: Stack( 
                    children: [ 
                      Container( 
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), 
                        decoration: BoxDecoration( 
                          gradient: LinearGradient( 
                            begin: Alignment.topCenter, 
                            end: Alignment.bottomCenter, 
                            colors: [
                              const Color.fromARGB(255, 255, 72, 0).withOpacity(0.6), // 100% opacity
                              const Color.fromARGB(255, 0, 0, 0).withOpacity(0.0), // 0% opacity
                            ], 
                          ), 
                          border: const Border( 
                            top: BorderSide( 
                              color: Color.fromARGB(235, 255, 60, 0), 
                              width: 1.0, 
                            ), 
                            left: BorderSide( 
                              color: Color.fromARGB(235, 255, 60, 0), 
                              width: 1.0, 
                            ), 
                            right: BorderSide( 
                              color: Color.fromARGB(235, 255, 60, 0), 
                              width: 1.0, 
                            ), 
                          ), 
                          borderRadius: const BorderRadius.only( 
                            topLeft: Radius.circular(25), 
                            topRight: Radius.circular(25), 
                          ), 
                        ), 
                        child: Column( 
                          mainAxisSize: MainAxisSize.min, 
                          children: [ 
                            SmoothPageIndicator( 
                              controller: _pageController, 
                              count: _onBoardingData.length, 
                              effect: const ExpandingDotsEffect( 
                                expansionFactor: 3, 
                                spacing: 8, 
                                radius: 16, 
                                dotWidth: 16, 
                                dotHeight: 8, 
                                dotColor: Color.fromARGB(255, 241, 181, 166), 
                                activeDotColor: Color.fromARGB(255, 243, 82, 33), 
                              ), 
                            ), 
                            const SizedBox(height: 24), 
                                    ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        minimumSize: const Size(double.infinity, 50),
                                        backgroundColor: const Color.fromARGB(255, 255, 66, 8),  // Button background color
                                        foregroundColor: Colors.white, // Button text (and icon) color
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login), // Icon for login button
                                          SizedBox(width: 10),
                                          Text('Login'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: _register,
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        minimumSize: const Size(double.infinity, 50),
                                        backgroundColor: const Color.fromARGB(255, 255, 66, 8), // Button background color
                                        foregroundColor: Colors.white, // Button text (and icon) color
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.person_add), // Icon for register button
                                          SizedBox(width: 10),
                                          Text('Register'),
                                        ],
                                      ),
                                    ),

                            const SizedBox(height: 12),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 16, right: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Divider(
                                                    thickness: 2,
                                                    color: Color.fromARGB(255, 255, 102, 0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Text(
                                                    "Or",
                                                    style: TextStyle(
                                                      color: Colors.white,  // Set color to white
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Divider(
                                                    thickness: 2,
                                                    color: Color.fromARGB(255, 255, 102, 0)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
              
                            const SizedBox(height: 12), 
                            ElevatedButton( 
                              onPressed: _continueAsGuest, 
                              style: ElevatedButton.styleFrom( 
                                minimumSize: const Size(double.infinity, 50), 
                                backgroundColor: const Color.fromARGB(255, 240, 240, 240), 
                                textStyle: const TextStyle( 
                                  color: Color.fromARGB(255, 255, 254, 254), 
                                  fontSize: 16, 
                                  fontWeight: FontWeight.normal, 
                                ), 
                              ), 
                              child: const Text('Continue as Guest'), 
                            ), 
                            const SizedBox(height: 40), 
                          ], 
                        ), 
                      ), 
                    ], 
                  ), 
                ), 
              ), 
            ), 
            // Glowing logo with animated opacity
            Stack( 
              children: [ 
                Positioned( 
                  top: 0, 
                  left: 0, 
                  child: AnimatedOpacity( 
                    opacity: _opacity, // Apply opacity to create glowing effect
                    duration: const Duration(milliseconds: 1000), 
                    child: Image.asset( 
                      'lib/images/glow.png', 
                      fit: BoxFit.cover, 
                      width: 320, 
                      height: 320, 
                    ), 
                  ), 
                ), 
                Positioned( 
                  top: 0, 
                  left: 10, 
                  child: SafeArea( 
                    child: Padding( 
                      padding: const EdgeInsets.all(16.0), 
                      child: Image.asset( 
                        'lib/images/logo.webp', // Display logo at the top left
                        fit: BoxFit.cover, 
                        width: 90, 
                        height: 90, 
                      ), 
                    ), 
                  ), 
                ), 
              ], 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}
