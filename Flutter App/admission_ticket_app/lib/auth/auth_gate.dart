import 'package:admission_ticket_app/screens/admin_screens/admin_home_screen.dart';
import 'package:admission_ticket_app/screens/student_screens/signup_screen.dart';
import 'package:admission_ticket_app/screens/student_screens/student_home_screen.dart';
import 'package:admission_ticket_app/screens/teacher_screens/teacher_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_service/database.dart';

class AuthWrapper extends StatefulWidget {
  final bool tutorial;
  const AuthWrapper({super.key, required this.tutorial});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
        {

          return FutureBuilder(
            future: DatabaseMethods().UserRole(snapshot.data) ,
            builder: (context, AsyncSnapshot roleSnapshot) {

              if (roleSnapshot.connectionState == ConnectionState.waiting)
              {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(child: CircularProgressIndicator()),
                );

              }

              else if (roleSnapshot.hasError)
              {
                return Text('Error: ${roleSnapshot.error}');
              }

              else {

                if (roleSnapshot.data == "Student") {
                  return StudentHomePage(); // User is a patient
                } else if(roleSnapshot.data == "Teacher"){
                  return const TeacherHomePage();
                }
                else
                {
                  return const AdminPage();
                }
              }
            },
          );

        }

        else {
          return const SignUpPage();
        }
      },
    );
  }
}
