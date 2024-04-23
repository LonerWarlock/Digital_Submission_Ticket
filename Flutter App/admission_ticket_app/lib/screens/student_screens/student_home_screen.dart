import 'package:admission_ticket_app/auth/auth_services.dart';
import 'package:admission_ticket_app/colors.dart';
import 'package:admission_ticket_app/services/report%20service/report.dart';
import 'package:admission_ticket_app/widgets/wdget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../widgets/menuDrawer.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Map ApprovalStatus = {};
  Map Attendance = {};
  Map UT_1_marks = {};
  Map UT_2_marks = {};
  int total_attended = 0;
  int total_present = 0;
  String name = '';
  String div = '';

  double totPercent = 0.0;



  List Subjects = ["EM 3", "CG", "DBMS", "MP"];

  Future<void> _refresh() async {
    getUserData();
    return await Future.delayed(Duration(seconds: 2));
  }

  getUserData() async {
    DocumentSnapshot studentSnapShot =
        await firestore.collection("Users").doc(auth.currentUser!.uid).get();
    if (studentSnapShot.exists) {
      final data = studentSnapShot.data() as Map;
      ApprovalStatus = data["Approval Status"];
      Attendance = data["Attendance"];
      final UT_Data = data["UT Marks"];
      UT_1_marks = UT_Data["UT 1"];
      UT_2_marks = UT_Data["UT 2"];
      name = data["name"];
      div =  data["division"];


      Attendance.forEach((key, value){
          // total_attended += int.parse("${value["attended"]}");
          // total_present += int.parse("${value["present"]}");
        int val_a = value["attended"] != -1 ? int.parse("${value["attended"]}") : 0;
        int val_t = value["total"] != -1 ? int.parse("${value["total"]}") : 0;

        total_present += val_t;
        total_attended += val_a;
      });
      totPercent =  total_attended != 0 ? (total_attended / total_present)*100 : 0;
      totPercent = double.parse(totPercent.toStringAsFixed(2));

      print("Percent : $totPercent %");
      print(total_present);
      print(total_attended);


    }
    setState(() {});
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submission Ticket Status",
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
                          "https://cdn.imgbin.com/18/7/14/imgbin-university-of-south-asia-student-tutor-course-lecturer-student-B85zQNkhssf8AEqwNtNMAQcvx.jpg"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            );
          },

        ),
          actions: [
            IconButton(onPressed: (){
              generatePDF(UT_1_marks, UT_2_marks, Attendance, ApprovalStatus, name, div );
            }, icon: Icon(Icons.download, size: 30,))
          ]
      ),
      drawer: CustomMenuDrawer(
        profile_pic:
            "https://cdn.imgbin.com/18/7/14/imgbin-university-of-south-asia-student-tutor-course-lecturer-student-B85zQNkhssf8AEqwNtNMAQcvx.jpg",
        userName: authService.getCurrentUser()!.email!,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: LiquidPullToRefresh(
          onRefresh: _refresh,
          height: 250,
          animSpeedFactor: 1.5,
          color: appBarColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text("Submission Overview", style: AppWidget.boldTextStyle(),),
                SizedBox(
                  height: 20,
                ),
                Table(
                  columnWidths: {
                    0: FixedColumnWidth(80),
                    1: FixedColumnWidth(65), // Adjust the width of the UT 1 column
                    2: FixedColumnWidth(65), // Adjust the width of the UT 2 column
                    3: FlexColumnWidth(
                        2), // Increase the width of the Approval column
                  },
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text(
                                'Subject',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text('UT 1',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text('UT 2',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text('Approval',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
            
                    for (int i = 0; i < Subjects.length; i++)
                      TableRow(children: [
                        TableCell(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Subjects[i],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                            child: Center(
                          child:
                              UT_1_marks != null && UT_1_marks[Subjects[i]] != null
                                  ? UT_1_marks[Subjects[i]] != -1
                                      ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${UT_1_marks[Subjects[i]]}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                                                    textAlign: TextAlign.center,
                                          ),
                                      )
                                      : Text(
                                          "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )
                                  : Text(""),
                        )),
                        TableCell(
                            child: Center(
                          child:
                              UT_2_marks != null && UT_2_marks[Subjects[i]] != null
                                  ? UT_2_marks[Subjects[i]] != -1
                                      ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${UT_2_marks[Subjects[i]]}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                                                    textAlign: TextAlign.center,
                                          ),
                                      )
                                      : Text(
                                          "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        )
                                  : Text(""),
                        )),
                        TableCell(
                          child: Center(
                              child: ApprovalStatus != {} &&
                                      ApprovalStatus[Subjects[i]] != null
                                  ? InkWell(
                                onTap: ()
                                {
                                  showDialog(context: context, builder: (context)=>AlertDialog(
                                    backgroundColor: dialogboxColor,
                                    title: Text(ApprovalStatus[Subjects[i]]["status"], style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: ApprovalStatus[Subjects[i]]
                                        ["status"] ==
                                            "Completed"
                                            ? Colors.green
                                            : Colors.red)),
            
                                    content:  ApprovalStatus[Subjects[i]]["message"] != "" ? Text(ApprovalStatus[Subjects[i]]["message"], style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,))  : Text("You Have Not Submitted Assignment", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,)) ,
                                  )
                                  );
                                },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(ApprovalStatus[Subjects[i]]["status"],
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: ApprovalStatus[Subjects[i]]
                                                          ["status"] ==
                                                      "Completed"
                                                  ? Colors.green
                                                  : Colors.red), textAlign: TextAlign.right,),
                                    ),
                                  )
                                  : Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                        ),
                      ])
            
                    // Add more TableRow widgets as needed
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Attendance Overview", style: AppWidget.boldTextStyle(),),
                SizedBox(
                  height: 20,
                ),
                Table(
                  columnWidths: {
                    0: FixedColumnWidth(80),
                    1: FixedColumnWidth(75), // Adjust the width of the UT 1 column
                    2: FixedColumnWidth(75), // Adjust the width of the UT 2 column
                    3: FlexColumnWidth(
                        2), // Increase the width of the Approval column
                  },
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text(
                                'Subject',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text('Present',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text('Total',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text('Percent',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
            
                    for (int i = 0; i < Subjects.length; i++)
                      TableRow(children: [
                        TableCell(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Subjects[i],
                                style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                            child: Center(
                              child:
                              Attendance != null &&  Attendance[Subjects[i]] != null && Attendance[Subjects[i]]["attended"] != null
                                  ? Attendance[Subjects[i]]["attended"] != -1
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${Attendance[Subjects[i]]["attended"]}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )
                                  : Text(
                                "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )
                                  : Text(""),
                            )),
                        TableCell(
                            child: Center(
                              child:
                              Attendance != null && Attendance[Subjects[i]] !=null && Attendance[Subjects[i]]["total"] != null
                                  ? Attendance[Subjects[i]]["total"] != -1
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${Attendance[Subjects[i]]["total"]}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )
                                  : Text(
                                "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              )
                                  : Text(""),
                            )),
                        TableCell(
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Attendance != null &&
                                    Attendance[Subjects[i]] != null &&
                                    Attendance[Subjects[i]]["total"] != null
                                    ? Attendance[Subjects[i]]["attended"] >= 0 && Attendance[Subjects[i]]["total"] > 0
                                    ? Text(
                                  '${(Attendance[Subjects[i]]["attended"] / Attendance[Subjects[i]]["total"] * 100).toStringAsFixed(2)} %',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold),
                                )
                                    : Text(
                                  "NA",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold),
                                ) : Text(""),
                              )
                              )),
                      ]),

                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text("$total_attended",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text("$total_present",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            color: appBarColor,
                            child: Center(
                              child: Text('$totPercent %',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),

                SizedBox(height: 30,),

                Visibility(
                  visible: totPercent < 75,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Grey background color
                      borderRadius: BorderRadius.circular(2.0), // Border radius of 2
                    ),
                    padding: EdgeInsets.all(16.0), // Padding for content
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DEFAULTER',
                          style: TextStyle(
                            color: Colors.red, // Red title color
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0), // Spacer
                        Text(
                          'You should increase your attendance before the end of the semester to 75%.',
                          style: TextStyle(
                            color: Colors.black, // Black description color
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                Container(height: 400,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
