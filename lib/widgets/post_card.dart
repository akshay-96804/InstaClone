import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/providers/authProvider.dart';
import 'package:insta_clone/providers/userProvider.dart';
import 'package:insta_clone/resources/firestoreMethds.dart';
import 'package:insta_clone/screens/comment_screen.dart';
import 'package:insta_clone/screens/profileScreen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/like_animation.dart';
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
  // bool isLikeAnimating = false;

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
    // final User user = Provider.of<UserProvider>(context).getuser;

    return Container(
      // color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0)
                .copyWith(right: 0),
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
                      // widget.snap['profImage'].toString(),
                      ),
                ),
                // ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    // mainAxisAlignment: MainAxisAlignment.,
                    children: <Widget>[
                      Text(
                        widget.snap['username'],
                        // widget.snap['username'].toString(),
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
              IconButton(icon: Icon(Icons.send), onPressed: () {}),
            ],
          ),
          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyText2,
                    )),
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
                          text: 'username',
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
                      // DateFormat.yMMMd()
                      //     .format(widget.snap['datePublished'].toDate()),
                      // style: const TextStyle(
                      //   color: secondaryColor,
                      // ),
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


// class LikeButton extends StatelessWidget {
//   // const LikeButton({ Key? key }) : super(key: key);
//   bool isLiked ;
//   final snap ;
//   LikeButton(this.isLiked,this.snap);

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: isLiked?Icon(Icons.favorite):Icon(Icons.favorite_border_outlined), 
//       onPressed: isLiked ? snap['likes'].remove(snap[Provider.of<AuthProvider>(context, listen: false).userid]):
//               FieldValue.arrayUnion([Provider.of<AuthProvider>(context, listen: false).userid])
//       );
//   }
// }