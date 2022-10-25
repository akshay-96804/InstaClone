import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/authProvider.dart';
import 'package:insta_clone/resources/firestoreMethds.dart';
import 'package:insta_clone/screens/comment_screen.dart';
import 'package:insta_clone/screens/profileScreen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({@required this.snap});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = query.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap:  widget.snap['uid'] == Provider.of<AuthProvider>(context,listen: false).getUserId?null:(){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return ProfileScreen(uid: widget.snap['uid']);
                      }
                    ));
                  },
                  child: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(widget.snap['profImage'])
                      ),
                ),
                // ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
            // IMAGE SECTION
          ),
          GestureDetector(
            onDoubleTap: () {
              FirestoreMethods().likePost(
                  widget.snap['postId'],
                  Provider.of<AuthProvider>(context, listen: false).userid,
                  widget.snap['likes']);
            },
            child:Container(
            height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(widget.snap['postUrl'])), 
          ),

          // LIKE COMMENT SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                IconButton(
                    icon: widget.snap['likes'].contains(
                      Provider.of<AuthProvider>(context, listen: false).userid,
                    )
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border_outlined),
                    onPressed: () async {
                      FirestoreMethods().likePost(
                          widget.snap['postId'],
                          Provider.of<AuthProvider>(context, listen: false)
                              .userid,
                          widget.snap['likes']);
                    }),
              IconButton(
                  icon: Icon(Icons.comment_outlined),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              snap: widget.snap,
                            )));
                  }),
            ],
          ),
          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.snap['likes'].length} likes'),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: '${widget.snap['username']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CommentsScreen(snap: widget.snap);
                    }));
                  },
                  child: Container(
                      child: Text(
                    'View all ${commentLen} comments',
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  )),
                ),
                Container(
                  child: Text(DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate())
                     
                      ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
