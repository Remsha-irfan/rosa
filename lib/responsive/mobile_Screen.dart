import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../screens/reusable_widget.dart';

class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({super.key});

  @override
  State<mobileScreenLayout> createState() => _mobileScreenLayoutState();
}

class _mobileScreenLayoutState extends State<mobileScreenLayout> {
  int _currentIndex = 0;
  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // getUSerData();
    super.initState();
  }

  // getUSerData() async {
  //   UserProvider userProvider = Provider.of(context, listen: false);
  //   await userProvider.refreshUser();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: homeScreenItems[_currentIndex],
        bottomNavigationBar: Container(
          color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: GNav(
              onTabChange: onTappedBar,
              backgroundColor: Colors.amber,
              activeColor: Colors.black87,
              tabBackgroundGradient: const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromARGB(255, 235, 235, 233),
                    Color.fromARGB(255, 244, 244, 242)
                  ]),
              gap: 2.0,
              padding: const EdgeInsets.all(10.0),
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.post_add,
                  text: 'Post',
                ),
                GButton(
                  icon: Icons.publish,
                  text: 'Published',
                ),
                GButton(
                  icon: Icons.account_circle_outlined,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ));
  }
}
