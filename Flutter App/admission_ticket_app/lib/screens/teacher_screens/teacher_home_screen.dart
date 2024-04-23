


import 'package:admission_ticket_app/auth/auth_services.dart';
import 'package:admission_ticket_app/colors.dart';
import 'package:admission_ticket_app/widgets/user_profile_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_service/database.dart';
import '../../widgets/menuDrawer.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  Stream<QuerySnapshot>? studentStream;
  String TeacherDiv = "";
  String TeacherLab= "";
  String TeacherName= "";
  FirebaseAuth auth = FirebaseAuth.instance;
  Map ApprovalStatus = {};
  Map UT_1_marks = {};
  Map UT_2_marks = {};
  
  AuthService authService = AuthService();

  getOnLoad() async{

    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("Users").doc(auth.currentUser!.uid).get();

    if(snapshot.exists)
      {
        final data = snapshot.data() as Map;

        TeacherDiv = data["division assigned"];
        TeacherName = data["name"];
        print(TeacherLab);
        print(TeacherDiv);
      }
    studentStream = await DatabaseMethods().getUserDetails(TeacherDiv);

    setState(() {
    });
  }
  
  @override
  void initState() {
    getOnLoad();
    super.initState();
  }

  Widget allStudentDetails()
  {
    return StreamBuilder(stream: studentStream, builder: (context, snapshot)
    {
          if(snapshot.hasData)
            {
              List<DocumentSnapshot> documents = snapshot.data!.docs;



              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = documents[index];
                  if (documentSnapshot["division"] == TeacherDiv) {
                    print(documents.length);
                    print(documentSnapshot["name"]);

                    bool completionStatus  = true;

                    Map ApprovalStatus = documentSnapshot["Approval Status"];
                    ApprovalStatus.forEach((key, value) {
                      if(value["status"]=="Pending")
                        completionStatus = false;
                    });

                    return UserProfileContainer(
                      profilePhotoUrl: "https://cdn.imgbin.com/18/7/14/imgbin-university-of-south-asia-student-tutor-course-lecturer-student-B85zQNkhssf8AEqwNtNMAQcvx.jpg",
                      userName: documentSnapshot["name"],
                      completionStatus: completionStatus, // or false based on completion status
                      userId: documentSnapshot.id,
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          return Container();
    }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teacher Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leadingWidth: 90,
        leading: Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                width: 5,
                margin: EdgeInsets.only(left: 30),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
            "https://img.freepik.com/premium-vector/young-nerd-guy-character_667918-1253.jpg"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            );
          },
        ),
      ),
      drawer: CustomMenuDrawer(
        profile_pic:
        "https://img.freepik.com/premium-vector/young-nerd-guy-character_667918-1253.jpg",
        userName: authService.getCurrentUser()!.email!,
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,


            decoration: BoxDecoration(
              color: appBarColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$TeacherName", textAlign : TextAlign.center,style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                SizedBox(height: 20,),
                Text("Class Assigned : $TeacherDiv", textAlign : TextAlign.start,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                SizedBox(height: 20,),
                Text("Lab Assigned : $TeacherLab", textAlign : TextAlign.center,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),

              ],
            ),
          ),
          SizedBox(height: 15,),
          Expanded(child: allStudentDetails()),
        ],
      ),
    );
  }
}
