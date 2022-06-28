import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/screens/chatRoom.dart';
import 'package:insta_clone/screens/chatScreen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  // const FeedScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      appBar:  AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Text('Photogram',style: TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    // print("Sign out tapped");

                    Navigator.push(context, MaterialPageRoute(builder: (_){
                      return ChatsScreen(); 
                    }));
                  },
                ),
              ],
            ),
            body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data!.size > 0){
            return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        }
        return Center(
          child: Text("No Posts To Display"),
        );
          }
        
      ),
        //  body: StreamBuilder(
        //    builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
        //      if(snapshot.hasData){
        //        return ListView.builder(
        //        itemCount: snapshot.data!.docs.length,
        //        itemBuilder: (context,index){
        //          return PostCard(
        //            snap : snapshot.data!.docs[index]
        //          );
        //       }
        //        );
        //      }
        //     //  if(snapshot.connectionState == ConnectionState.waiting){
        //     //    return Center(child: CircularProgressIndicator());
        //     //  }
        //      return  Center(child: CircularProgressIndicator());
        //     //  Container(); 
             
        //    },
        //    stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished',descending: true).snapshots(),
        //  ),   
    );
  }
}