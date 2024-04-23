import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? getCurrentUser() {

    return _auth.currentUser;
  }

  String? getCurrentUserId() {

    return _auth.currentUser!.uid;
  }

  List Subjects = ["EM 3", "CG", "DBMS", "MP"];

  Future<UserCredential> signUpWithEmailPassword({required String email, required String password, required String name,  required String div,  required String lab}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Map approvalStatus = {};
      Map UT_Marks = {};
      Map UT_1 = {};
      Map UT_2 = {};

      for (String subject in Subjects) {
        approvalStatus[subject] = {"message": "", "status": "Pending"};
        UT_1[subject] = -1;
        UT_2[subject] = -1;
      }

      Map Attendance = {"DBMS": {"attended": -1, "total": -1}, "EM 3": {"attended": -1, "total": -1}, "CG": {"attended": -1, "total": -1}, "MP": {"attended": -1, "total": -1}};

      print(Attendance);

      UT_Marks["UT 1"] = UT_1;
      UT_Marks["UT 2"] = UT_2;

      print(
          {
            'uid': userCredential.user!.uid,
            'email': email,
            'name': name,
            'division' : div,
            'lab' : lab,
            'role' : 'Student',
            'Approval Status' : approvalStatus,
            "UT Marks" : UT_Marks,
            "Attendance" : Attendance

          }
      );

      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'division' : div,
        'lab' : lab,
        'role' : 'Student',
        'Approval Status' : approvalStatus,
        "UT Marks" : UT_Marks,
        "Attendance" : Attendance,
        "defaulter" : false,
      });


      print("Online Updated");

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Error ${e.code}");
      throw e.code;
    }
  }

  Future<UserCredential> TeachersignUpWithEmailPassword({required String email, required String password, required String name,  required String div,  required String lab}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'division assigned' : div,
        'role' : 'Teacher',
      });
      print("Online Updated");

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Error ${e.code}");
      throw e.code;
    }
  }

  Future<UserCredential> loginEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Error ${e.code}");
      throw e.code;
    }
  }

  Future<void> logout() async {
    try {
      print("Offline Updated");
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print("Error ${e.code}");
      throw e.code;
    }
  }

  Future<UserCredential> createNewTeacher(String email, String name, String qualification, String div, String experience) async
  {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: "Teacher1234");
    _firestore.collection("Users").doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
      'name': name,
      'qualification' : qualification,
      'experience' : experience,
      'division assigned' : div,
      'role' : 'Teacher',
    });
    return userCredential;
  }
}
