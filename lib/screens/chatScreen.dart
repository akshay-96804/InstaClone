import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/chatRoom.dart';

class ChatsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
        title: Text("View Chats",style: TextStyle(color: Colors.black)),
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
                    return ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ChatRoom(snapshot.data!.docs[index].id); 
                        }));
                      },
                      title: Text(snapshot.data!.docs[index].data()['reciever']),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!.docs[index].data()['recieverImg']),
                      ),
                     subtitle: Text('Tap To Chat'), 
                    );
                  }
              );
            }
          }
          return Center(child: Text("No Chats were found."));
        }),
    );
  }
}
