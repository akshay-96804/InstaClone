import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/authProvider.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/resources/firestoreMethds.dart';
import 'package:insta_clone/screens/chatRoom.dart';
import 'package:insta_clone/screens/chatScreen.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/follow_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Loading...';
  String userImg =  'https://t4.ftcdn.net/jpg/00/84/67/19/360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg';

  var userData = {};
  int postLen = 0;

  int followers = 0;
  int following = 0;

  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;

      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;

      userName = userSnap.data()!['username'];
      userImg = userSnap.data()!['photoUrl'];

      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      // setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
        Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 2.0,
              backgroundColor: Colors.white,
              title: Text(
                Provider.of<AuthProvider>(context,listen: false).getUserId==widget.uid? Provider.of<AuthProvider>(context,listen: false).getUsername: userName,style: TextStyle(color: Colors.black),
              ),
              centerTitle: false,
            ),
            body: isLoading
        ? Center(child: CircularProgressIndicator()):SafeArea(
              child: ListView(
                children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColumn(postLen, "posts"),
                                      buildStatColumn(followers, "followers"),
                                      buildStatColumn(following, "following"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? FollowButton(
                                              text: 'Sign Out',
                                              backgroundColor:
                                                  primaryColor,
                                              textColor: secondaryColor,
                                              borderColor: Colors.grey,
                                              function: () async {
                                                await AuthMethods().signOut();

                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                              },
                                            )
                                          : isFollowing
                                              ? Column(
                                                  children: [
                                                    FollowButton(
                                                      text: 'Unfollow',
                                                      backgroundColor: Colors.white,
                                                      textColor: Colors.black,
                                                      borderColor: Colors.grey,
                                                      function: () async {
                                                        await FirestoreMethods()
                                                            .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid'],
                                                        );

                                                        setState(() {
                                                          isFollowing = false;
                                                          followers--;
                                                        });
                                                      },
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        DocumentSnapshot _data =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection('users')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .get();
                                                        String userName =
                                                            (_data.data() as Map<
                                                                    String,
                                                                    dynamic>)[
                                                                'username'];

                                                        print(widget.uid);

                                                        String chatId = Uuid().v1();

                                                        FirestoreMethods()
                                                            .createChat(
                                                                userName,
                                                                userData[
                                                                    'username'],
                                                                chatId,
                                                                widget.uid,
                                                                userImg,
                                                                Provider.of<AuthProvider>(context,listen: false).getPhtotUrl
                                                                )
                                                            .whenComplete(() {
                                                          Navigator.push(context,
                                                              MaterialPageRoute(
                                                                  builder: (_) {
                                                            return ChatRoom(chatId);
                                                          }));
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        alignment: Alignment.center,
                                                        color: Colors.white,
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.30,
                                                        child: Text("Message",
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : FollowButton(
                                                  text: 'Follow',
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white,
                                                  borderColor: Colors.blue,
                                                  function: () async {
                                                    await FirestoreMethods()
                                                        .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid'],
                                                    );

                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                )
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15, left: 10.0),
                      child: Text(
                        userData['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 1, left: 10.0),
                      child: Text(
                        userData['bio'],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Divider(
                    color: Colors.black,
                  ),
                ),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.size > 0) {
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];

                          return GestureDetector(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      content: Text(
                                          "Do You want to delete this post ?"),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () async{
                                            await FirebaseFirestore.instance.collection('posts').doc(snapshot.data!.docs[index].id).delete().whenComplete((){
                                                                                        

                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Post Deleted Successfully")));
                                              Navigator.pop(context);
                                            });

                                          },
                                          child: Text("Yes"),
                                        ),
                                        MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No"))
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              // margin: EdgeInsets.only(left: 10.0),
                              padding: EdgeInsets.only(left: 12.0),
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text("You have not added any posts."),
                    );
                  },
                )
              ]),
            ),
          );
  }
}

Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    ],
  );
}
