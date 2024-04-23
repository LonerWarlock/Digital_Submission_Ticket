import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../auth/auth_gate.dart';
import '../../auth/auth_services.dart';
import '../../colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/wdget_support.dart';
import '../student_screens/login_screen.dart';


class TeacherSignUpPage extends StatefulWidget {
  const TeacherSignUpPage({super.key});

  @override
  State<TeacherSignUpPage> createState() => _TeacherSignUpPageState();
}

class _TeacherSignUpPageState extends State<TeacherSignUpPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController qualificationContoller = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController divController = TextEditingController();
  TextEditingController labController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // void signUp() async {
  //   AuthService authService = AuthService();
  //
  //   if (passwordController.text.isEmpty ||
  //       nameController.text.isEmpty ||
  //       passwordController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Fill all Fields"),
  //       ),
  //     );
  //   } else {
  //     try {
  //       await authService.TeachersignUpWithEmailPassword(
  //         email: emailController.text.toString(),
  //         password: passwordController.text.toString(),
  //         name: nameController.text.toString(),
  //         div: divController.text.toString(),
  //         lab: labController.text.toString(),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Registered Successfully"),
  //         ),
  //       );
  //
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthWrapper(tutorial: true,)));
  //
  //       // No need to call setState here, as the authentication state change
  //       // will automatically trigger a rebuild in widgets listening to the authStateChanges stream
  //     } catch (e) {
  //       String errorMessage = "An error occurred, please try again later."; // Default error message
  //       switch (e.toString()) {
  //         case 'weak-password':
  //           errorMessage = 'The password provided is too weak.';
  //           break;
  //         case 'email-already-in-use':
  //           errorMessage = 'The account already exists for that email.';
  //           break;
  //         case 'invalid-email':
  //           errorMessage = 'The email address is invalid.';
  //           break;
  //         case 'operation-not-allowed':
  //           errorMessage = 'Error occurred during sign up.';
  //           break;
  //         default:
  //           errorMessage = 'An error occurred while signing up.';
  //           break;
  //       }
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(errorMessage),
  //         ),
  //       );
  //     }
  //   }
  // }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  createTeacherPendingRequest() async
  {
    try
    {
      await _firestore.collection("Pending_Approvals").add(
          {
            "name" : nameController.text,
            "qualification" : qualificationContoller.text,
            "experience" : experienceController.text,
            "email" : emailController.text,
            "division assigned" : divController.text,
          }
      );

      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text("Request Sent Successfully"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ));
    }
    catch(e)
    {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred while submitting the request."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: NetworkImage("https://content.api.news/v3/images/bin/1f87bbc89609030e1712d09c411769f6", ), fit: BoxFit.cover)
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(" Teacher Sign Up", style: AppWidget.headlineTextStyle(),),
                            SizedBox(height: 30,),
                            CustomTextField(hintText: "Name", icon: Icon(Icons.person_outline), obscureText: false, textEditingController: nameController, ),
                            SizedBox(height: 15,),
                            CustomTextField(hintText: "Email", icon: Icon(Icons.email_outlined), obscureText: false, textEditingController: emailController,),
                            SizedBox(height: 15,),
                            CustomTextField(hintText: "Qualification", icon: Icon(Icons.school_outlined), obscureText: false, textEditingController: qualificationContoller,),
                            SizedBox(height: 15,),
                            CustomTextField(hintText: "Experience", icon: Icon(Icons.work_history_outlined), obscureText: false, textEditingController: experienceController,),
                            SizedBox(height: 15,),
                            CustomTextField(hintText: "Division Assigned", icon: Icon(Icons.meeting_room_outlined), obscureText: false, textEditingController: divController, ),


                            SizedBox(height: 60,),

                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),

                              child: InkWell(
                                onTap: createTeacherPendingRequest,
                                child: Container(

                                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: appBarColor,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text("Send Request", style: AppWidget.boldTextStyle().copyWith(color: Colors.white,),),

                                ),
                              ),
                            ),

                            SizedBox(height: 80,),


                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(

                                children: [
                                  Text("Already Have an Account ?", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                                  GestureDetector(
                                      onTap: ()
                                      {
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
                                      },
                                      child: Text("  Login Now", style: TextStyle(fontSize: 18, color: appBarColor))),
                                ],
                              ),
                            ),

                            SizedBox(height: 15,),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image.asset("assets/images/logo.png",
                    //     width: MediaQuery.of(context).size.width/1.3),

                    Container(
                      width: MediaQuery.of(context).size.width/1.3,
                      margin: EdgeInsets.only(top: 30),
                      alignment: Alignment.center,

                      child: Text("", style: AppWidget.headlineTextStyle().copyWith(fontSize: 30),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
