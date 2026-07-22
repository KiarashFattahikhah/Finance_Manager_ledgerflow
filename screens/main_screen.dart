import "package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_project/constant.dart";
import "package:flutter_project/screens/home_screen.dart";
import "package:flutter_project/screens/info_screen.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  Widget body = const HomeScreen();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          backgroundColor: kPurpleColor,
          inactiveColor: Colors.black54, 
          activeColor: Colors.white,
          icons: const [Icons.home,Icons.info], 
          activeIndex: currentIndex, 
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.smoothEdge,
          onTap: (index) {
            setState(() {
              if(index == 0){
                body = const HomeScreen();
              }
              else{
                body = const InfoScreen();
              }
              currentIndex = index;
            });
          },
          ),
          body: body,
      ),
    );
  }
}