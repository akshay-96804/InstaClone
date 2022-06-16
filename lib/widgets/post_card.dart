import 'package:flutter/material.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/providers/userProvider.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class PostCard extends StatefulWidget {
  final snap ;
  PostCard({@required this.snap});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false; 

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getuser ;

    return Container(
      color: mobileBackgroundColor,
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
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage'])
                      // widget.snap['profImage'].toString(),
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
                IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                              children: [
                            'Delete',
                          ]
                                  .map(
                                    (e) => InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                        onTap: () {
                                          // deletePost(
                                          // widget.snap['postId']
                                          // .toString(),
                                          // );
                                          // remove the dialog box
                                          Navigator.of(context).pop();
                                        }),
                                  )
                                  .toList()),
                          // shrinkWrap: true,
                          // padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      );
                    })
              ],
            ),
            // IMAGE SECTION
          ),
          GestureDetector(
            onDoubleTap: (){
              setState(() {
                              isLikeAnimating = true ;
                            });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(widget.snap['postUrl']),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1:0,
                child: LikeAnimation(child: const Icon(Icons.favorite,color: Colors.white,size: 100.0), isAnimating: isLikeAnimating,
                duration: const Duration(
                  milliseconds: 400
                ),
                onEnd: (){
                  setState(() {
                                  isLikeAnimating = false ;
                                });
                },
                ),
              )
              ],
            ),
          ),

          // LIKE COMMENT SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {}),
              ),
              IconButton(
                  icon: Icon(Icons.comment_outlined),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.send), onPressed: () {}),
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
                  child: Container(
                      child: Text(
                    'View all 100 comments',
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  )),
                ),
                Container(
                  child: Text(
                     DateFormat.yMMMd().format(widget.snap['datePublished'].toDate())
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
