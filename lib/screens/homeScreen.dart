import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/userProvider.dart';
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
  int _page = 0;
  late PageController pageController ;

  @override
  void initState() {
    super.initState();
    addData() ;
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
          _page = page ;
        });
  }

  addData() async{
    UserProvider _userProvider = Provider.of<UserProvider>(context,listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    
    // model.User user = Provider.of<UserProvider>(context).getuser ;
    // print(user);

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
        controller: pageController,
        children: homeScreenItems
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: navigationTapped,
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _page == 0 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _page == 2 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _page == 3 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _page == 4 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
        ],
      ),
    );
  }
}
