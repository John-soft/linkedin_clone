import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_clone/jobs/jobs_screen.dart';
import 'auth/login.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot){
        if(userSnapshot.data == null){
          print("User is not logged in yet");
          return Login();
        }

        else if(userSnapshot.hasData){
          print("User is already logged in");
          return JobScreen();
        }

        else if(userSnapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text("An error occurred, Try again later"),
            ),
          );
        }

        else if(userSnapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: Text("Something went wrong"),
          ),
        );

      }
    );
  }
}
