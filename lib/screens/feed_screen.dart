import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  // const FeedScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Text('Instagram',style: TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
         body: StreamBuilder(
           builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
             if(snapshot.connectionState == ConnectionState.waiting){
               return Center(child: CircularProgressIndicator());
             }
             return ListView.builder(
               itemCount: snapshot.data!.docs.length,
               itemBuilder: (context,index){
                 return PostCard(
                   snap : snapshot.data!.docs[index]
                 );
             });
           },
           stream: FirebaseFirestore.instance.collection('posts').snapshots(),
         ),   
    );
  }
}