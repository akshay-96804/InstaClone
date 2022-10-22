import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resources/firestoreMethds.dart';

class ChatRoom extends StatefulWidget {
  String chatRoomId;
  ChatRoom(this.chatRoomId);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  String recieverName = "Loading.." ;
  String recieverId = "" ;

  void initState() {
    super.initState();
    fetchInfo();
  }

  fetchInfo() async{
    DocumentSnapshot userInfo = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('chats')
                    .doc(widget.chatRoomId).get();
    recieverName = (userInfo.data() as Map<String,dynamic>)['reciever'];    
    recieverId = (userInfo.data() as Map<String,dynamic>)['recieveruid'];
    setState(() {
          
    });         
  }
  TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text(recieverName,style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('chats')
                    .doc(widget.chatRoomId)
                    .collection('messages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.size > 0) {
                                          List<Widget> msgWidget = [];
                                           var data = snapshot.data!.docs.reversed ;
                    for(var msg in data){
                       var sender = msg.data()['sender'];
                        var message = msg.data()['message'];
                       var msgText = msgBubble(sender!=recieverName , message);
                                               msgWidget.add(msgText);

                    }
                    return ListView(
                          reverse: true,
                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                          children: msgWidget,
                        );                       
                     
                    
                  }
                  return Text("No Chats Found");
                }),
          ),
          Container(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: msgController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        DocumentSnapshot _data = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                        String userName =
                            (_data.data() as Map<String, dynamic>)['username'];

                        FirestoreMethods()
                            .sendMessage(userName, recieverName,msgController.text,widget.chatRoomId,recieverId);

                        msgController.clear();
                      },
                      icon: Icon(Icons.send)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  hintText: "Enter Message To Sent..."),
            ),
          )
        ],
      ),
    );
  }
}


class msgBubble extends StatelessWidget {
  String message ; 
  bool isMe ; 

  msgBubble(this.isMe,this.message);
  // const msgWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isMe? BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)
            ) : BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)
          )),
          child: Text(message,style: TextStyle(color: Colors.black),),
        )
      ],
    );
  }
}



/* 
// return ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: snapshot.data!.docs.length,
                    //     itemBuilder: (context, index) {
                    //       if (snapshot.hasData) {
                    //         return msgWidget(snapshot.data!.docs[index].data()['sender'] != recieverName , snapshot.data!.docs[index].data()['message']); 
                            
                    //         ListTile(
                    //           title: Text(
                    //               snapshot.data!.docs[index].data()['sender']),
                    //           subtitle: Text(
                    //               snapshot.data!.docs[index].data()['message']),
                    //         );
                    //       }
                    //       return SizedBox();
                    //     });
*/