import 'package:flutter/material.dart';
import 'package:xrun/screens/home_screens/home_screen_list_view.dart';
import 'package:xrun/screens/home_screens/profile_view.dart';
import 'package:xrun/screens/home_screens/results_and_stats_view.dart';
import 'package:xrun/screens/home_screens/trailing_and_workout_view.dart';
import 'package:xrun/screens/home_screens/upcomming_event_view.dart';
import 'package:xrun/shared/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreenListView(),
      ProfileView(),
      ResultsAndStatsView(),
      UpcommingEventView(),
      TrailingAndWorkoutView(),
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/app_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _screens[currentIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: xrunMediumGreen,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                selectedItemColor: xrunBlue,
                currentIndex: currentIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: xrunMediumGreen,
                unselectedItemColor: xrunWhite,
                iconSize: 30,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.meeting_room_rounded),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: '',
                  ),
                ],
                onTap: onTabTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
