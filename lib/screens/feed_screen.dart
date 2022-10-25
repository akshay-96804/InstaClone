import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/chatScreen.dart';
import 'package:insta_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  // const FeedScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      appBar:  AppBar(
              elevation: 2.0,
              backgroundColor: Colors.white,
              centerTitle: false,
              title: Text('Photogram',style: TextStyle(color: Colors.black)),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: Colors.black
                  ),
                  onPressed: () {

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
    );
  }
}