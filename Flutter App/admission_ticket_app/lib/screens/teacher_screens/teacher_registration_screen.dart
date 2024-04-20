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
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController divController = TextEditingController();
  TextEditingController labController = TextEditingController();

  void signUp() async {
    AuthService authService = AuthService();

    if (passwordController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fill all Fields"),
        ),
      );
    } else {
      try {
        await authService.TeachersignUpWithEmailPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString(),
          name: nameController.text.toString(),
          div: divController.text.toString(),
          lab: labController.text.toString(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registered Successfully"),
          ),
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthWrapper(tutorial: true,)));

        // No need to call setState here, as the authentication state change
        // will automatically trigger a rebuild in widgets listening to the authStateChanges stream
      } catch (e) {
        String errorMessage = "An error occurred, please try again later."; // Default error message
        switch (e.toString()) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The account already exists for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is invalid.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Error occurred during sign up.';
            break;
          default:
            errorMessage = 'An error occurred while signing up.';
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
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
                            CustomTextField(hintText: "Password", icon: Icon(Icons.lock_outlined), obscureText: true, textEditingController: passwordController,),
                            SizedBox(height: 15,),
                            CustomTextField(hintText: "Division Assigned", icon: Icon(Icons.meeting_room_outlined), obscureText: false, textEditingController: divController, ),
                            SizedBox(height: 15,),
                            CustomTextField(hintText: "Lab Assigned", icon: Icon(Icons.meeting_room_outlined), obscureText: false, textEditingController: labController,),



                            SizedBox(height: 60,),

                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),

                              child: InkWell(
                                onTap: signUp,
                                child: Container(

                                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: appBarColor,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text("Sign Up", style: AppWidget.boldTextStyle().copyWith(color: Colors.white,),),

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
