import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linkedin_clone/jobs/job_details.dart';
import 'package:linkedin_clone/services/global_methods.dart';

class JobWidget extends StatefulWidget {

  final String taskTitle;
  final String taskDescription;
  final String taskId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobWidget({
    required this.taskTitle,
    required this.taskDescription,
    required this.taskId,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location});


  @override
  _JobWidgetState createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => JobDetailsScreen(
                  uploadedBy: widget.uploadedBy,
                  taskId: widget.taskId)));
        },
        onLongPress: _deleteDialog(),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(widget.name,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            SizedBox(height: 6,),
            Text(widget.taskDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_right, size: 30,color: Colors.grey,),
      ),

    );
  }

  _deleteDialog(){
    User? user = _auth.currentUser;
    final _uid = user!.uid;

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    try{
                      if(widget.uploadedBy == _uid){
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.taskId)
                            .delete();

                        await Fluttertoast.showToast(
                            msg: "Task has been deleted",
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.grey,
                            fontSize: 18
                        );
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                      }else{
                        GlobalMethod.showErrorDialog(error: "You cannot perform this action", ctx: context);
                      }
                    }catch(error){
                      GlobalMethod.showErrorDialog(error: "this task can't be deleted", ctx: context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: Colors.red,),
                      Text("Delete", style: TextStyle(color: Colors.red),),
                    ],
                  ),
              ),
            ],
          );
        });
  }
}
