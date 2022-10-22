// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insta_clone/providers/authProvider.dart';
import 'package:insta_clone/providers/userProvider.dart';
import 'package:insta_clone/screens/homeScreen.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/screens/signup_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AuthProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.dark()
        //     .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        title: 'Instagram Clone', 
        home: Wrapper()
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  // const Wrapper({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Provider.of<AuthProvider>(context,listen: false).getCurrUser==null ? LoginScreen():HomeScreen();
  }
}
