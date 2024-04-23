import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../auth/auth_services.dart';
import '../../colors.dart';
import '../../widgets/wdget_support.dart';

class TeacherCard extends StatelessWidget {
  String email;
  String name;
  String qualification;
  String experience;
  String div;
  String id;

  AuthService authService = AuthService();



  TeacherCard({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.qualification,
    required this.experience,
    required this.div,
  });


  approveTeacher(String email, String name, String qualification,
      String location, String experience) async {
    try {
      print("Pending id : $id");

      UserCredential userCredential = await authService.createNewTeacher(
          email, name, qualification, location, experience);
      await authService.loginEmailPassword("admin@pict.edu", "Admin1234");
      await FirebaseFirestore.instance.collection("Pending_Approvals")
          .doc(id)
          .delete();


    } catch (e) {
      print("Error approving Teacher: $e");
    }
  }

  rejectTeacher(String email, String name, String qualification,
      String location, String experience) async {
    try {
      print("Pending id : $id");

      await FirebaseFirestore.instance.collection("Pending_Approvals")
          .doc(id)
          .delete();

    } catch (e) {
      print("Error rejecting Teacher: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 230,
        color: Colors.grey.shade200,
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://cdn-icons-png.freepik.com/512/5360/5360344.png",
                              ),
                              // Assuming _image is a File
                              fit: BoxFit.cover,
                              alignment: Alignment
                                  .topCenter,
                            ),
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        )),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: AppWidget.boldTextStyle(),
                              ),
                              Text(
                                qualification,
                                style: TextStyle(fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text("Exp : $experience",
                                  style: const TextStyle(fontSize: 17)),

                              Text("Division : $div",
                                  style: const TextStyle(fontSize: 17)),

                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () async
                          {
                            HapticFeedback.mediumImpact();
                            await rejectTeacher(email, name, qualification,
                                div, experience);
                            showDialog(context: context, builder: (context)=>AlertDialog(
                              title: Text("Teacher Rejected"),
                            ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2 - 50,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: Align(alignment: Alignment.center, child: Text("Reject", style: AppWidget.boldTextStyle().copyWith(fontSize: 17, color: Colors.white),)),
                          )),


                      InkWell(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            await approveTeacher(email, name, qualification,
                                div, experience);
                            // showDialog(context: context, builder: (context)=>AlertDialog(
                            //   title: Text("Teacher Approved"),
                            // ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: Align(alignment: Alignment.center, child: Text("Approve", style: AppWidget.boldTextStyle().copyWith(fontSize: 17, color: Colors.white),)),))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
