import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/chatRoom.dart';

class ChatsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Chats",style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('chats')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            if (snapshot.data!.size > 0) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    // DocumentSnapshot _doc = FirebaseFirestore.instance.collection('users').doc().get();
                    return ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ChatRoom(snapshot.data!.docs[index].id); 
                        }));
                      },
                      // leading: CircleAvatar(
                      //   backgroundImage: NetworkImage(snapshot.data),
                      // ),
                      title:
                          Text(snapshot.data!.docs[index].data()['reciever']),
                    );
                  });
            }
          }
          return Center(child: Text("No Chats were found."));
        }),
    );
  }
}
