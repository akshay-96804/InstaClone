import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/authProvider.dart';
import 'package:insta_clone/providers/userProvider.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/screens/add_post_screen.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/profileScreen.dart';
import 'package:insta_clone/screens/search_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/globalvar.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/models/user.dart' as model;

class HomeScreen extends StatefulWidget {
  // const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String userUid = "" ;
  
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
      // print("In ths Func");

    addData();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  addData() async {
    print("In ths Func");
    await Provider.of<AuthProvider>(context,listen: false).fetchUser();
    print("PhotoUrl is "+Provider.of<AuthProvider>(context,listen: false).getPhtotUrl);
    // // print(Provider.of<AuthProvider>(context,listen: false).getUsername);
    // // print(Provider.of<AuthProvider>(context,listen: false).getUserBio);
    // // print(Provider.of<AuthProvider>(context,listen: false).getUserEmail);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
          controller: pageController,
          children: [
            FeedScreen(),
            SearchScreen(),
            AddPostScreen(),
            Center(
              child: Text("Notification Screen"),
            ),
            ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid )
          ]),
      bottomNavigationBar: CupertinoTabBar(
        onTap: navigationTapped,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _page == 0 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.add,
                  color: _page == 2 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                  color: _page == 3 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _page == 4 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
        ],
      ),
    );
  }
}
