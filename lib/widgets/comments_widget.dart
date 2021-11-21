import 'package:flutter/material.dart';
import 'package:linkedin_clone/search/profile_company.dart';

class CommentWidget extends StatefulWidget {

  final String commentId;
  final String commenterId;
  final String commenterName;
  final String commentBody;
  final String commenterImageUrl;

  const CommentWidget({
    required this.commentId,
    required this.commenterId,
    required this.commenterName,
    required this.commentBody,
    required this.commenterImageUrl
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  List<Color> _colors = [
    Colors.amber,
    Colors.orange,
    Colors.pink.shade200,
    Colors.brown,
    Colors.cyan,
    Colors.blue,
    Colors.deepOrange,

  ];
  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ProfileScreen(userID: widget.commenterId)));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: _colors[1]
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(widget.commenterImageUrl),
                    fit: BoxFit.fill,
                  )
                ),
              ) ,
          ),
          SizedBox(
            width: 6,
          ),
          Flexible(
            flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.commenterName,
                    style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  Text(widget.commentBody,
                    maxLines: 5,
                    style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                ],
              ),),
        ],
      ),
    );
  }
}
