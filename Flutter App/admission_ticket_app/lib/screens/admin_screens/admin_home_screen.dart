import 'dart:async';
import 'package:admission_ticket_app/screens/admin_screens/teacher_approve_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../auth/auth_services.dart';
import '../../services/firebase_service/database.dart';
import '../../widgets/menuDrawer.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String profile_pic =
      "https://static.vecteezy.com/system/resources/previews/020/429/953/original/admin-icon-vector.jpg";
  Stream? pendingTeacherStream;

  AuthService authService = AuthService();

  Future<void> getPendingDoctors() async {
    pendingTeacherStream = await DatabaseMethods().getPendingRequests();
    setState(() {});
  }
  @override
  void initState() {
    getPendingDoctors();
    super.initState();
  }

  Widget buildPendingDoctors() {
    return StreamBuilder(
      stream: pendingTeacherStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: ListView.separated(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot documentSnapshot = documents[index];
                return TeacherCard(
                  id : documentSnapshot.id,
                  name: documentSnapshot["name"],
                  qualification: documentSnapshot["qualification"],
                  experience: documentSnapshot["experience"],
                  email: documentSnapshot["email"], div: documentSnapshot["division assigned"],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 30);
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 90,
          leading: Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  width: 5,
                  margin: const EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(profile_pic), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              );
            },
          ),

          title: Text(
            "PICT Admin",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.sizeOf(context).width * 0.055),
          ),
          centerTitle: false,
        ),
        drawer: CustomMenuDrawer(
          profile_pic: profile_pic,
          userName: "PICT Admin",
        ),
        body: buildPendingDoctors());
  }
}
