import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods{

  Future<Stream<QuerySnapshot>> getUserDetails(String div) async
  {
    return FirebaseFirestore.instance.collection("Users").where("role", isEqualTo: "Student").where("division", isEqualTo: div).snapshots();
  }


  Future<String?> getUserName() async{
    String? uid =  getCurrentUserUid();
    if (uid != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid).get();

      if (userSnapshot.exists) {
        String? name = userSnapshot['name'];
        return name;
      }
    }
    return null; // User not found or role not defined
  }


  String? getCurrentUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String? uid;

    if (user != null) {
      uid = user.uid;
      print("Current user UID: $uid");
    } else {
      print("No user is currently signed in.");
    }
    return uid;
  }

  Future<String?> getUserRole() async{
    String? uid =  getCurrentUserUid();
    if (uid != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid).get();

      if (userSnapshot.exists) {
        String? role = userSnapshot['role'];
        return role;
      }
    }
    return null; // User not found or role not defined
  }

  Future<String> UserRole(User currentUser) async
  {
    String? UserRole = await getUserRole();

    if(UserRole=="Student")
    {
      print("student");
      return "Student";
    }
    else if (UserRole=="Teacher")
    {
      return "Teacher";
    }
    else
    {
      return "Admin";
    }

  }

}