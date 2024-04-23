import 'package:admission_ticket_app/colors.dart';
import 'package:admission_ticket_app/services/report%20service/report.dart';
import 'package:admission_ticket_app/widgets/custom_text_field.dart';
import 'package:admission_ticket_app/widgets/wdget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentInfoPage extends StatefulWidget {
  final String userId;
  final String userName;
  final String profile_pic;
  const StudentInfoPage(
      {super.key,
      required this.userId,
      required this.userName,
      required this.profile_pic});

  @override
  State<StudentInfoPage> createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map ApprovalStatus = {};
  Map UT_Marks = {};
  Map UT_1_marks = {};
  Map UT_2_marks = {};
  Map Attendance = {};
  bool defaulter = false;
  int total_attended = 0;
  int total_present = 0;
  double totPercent = 0.0;
  String div = "";

  List Subjects = ["EM 3", "CG", "DBMS", "MP"];

  refresh() async {
    await getUserData();
  }

  getUserData() async {
    DocumentSnapshot studentSnapShot =
        await firestore.collection("Users").doc(widget.userId).get();
    if (studentSnapShot.exists) {
      final data = studentSnapShot.data() as Map;
      ApprovalStatus = data["Approval Status"];
      Attendance = data["Attendance"];
      final UT_Data = data["UT Marks"];
      UT_1_marks = UT_Data["UT 1"];
      UT_2_marks = UT_Data["UT 2"];
      defaulter = data["defaulter"];
      div = data["division"];

      Attendance.forEach((key, value){
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

      print(defaulter);

      if(totPercent < 75)
        {
          defaulter = true;
          updateData();
        }
      else
        {
          defaulter = false;
        }
    }
    setState(() {});
  }

  updateData() async {
    await firestore.collection("Users").doc(widget.userId).update({
      "UT Marks": {
        "UT 1": UT_1_marks,
        "UT 2": UT_2_marks,
      },
      "Attendance": Attendance,
      "defaulter" : defaulter,
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController msgController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          scrolledUnderElevation: 0.0,
          toolbarHeight: MediaQuery.of(context).size.height * 0.17,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.profile_pic),
                      radius: MediaQuery.of(context).size.height * 0.055,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.userName,
                          style: AppWidget.headlineTextStyle()
                              .copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          leading: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new, size: 30),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    generatePDF(UT_1_marks, UT_2_marks, Attendance, ApprovalStatus, widget.userName, div);
                  },
                  icon: const Icon(
                    Icons.download,
                    size: 35,
                    color: Colors.white60,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(children: [
          Table(
            columnWidths: {
              0: FixedColumnWidth(90),
              1: FixedColumnWidth(80), // Adjust the width of the UT 1 column
              2: FixedColumnWidth(80), // Adjust the width of the UT 2 column
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
                                color: Colors.white)),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: UT_1_marks[Subjects[i]] != null
                          ? UT_1_marks[Subjects[i]] == -1
                              ? TextField(
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    UT_1_marks[Subjects[i]] = int.parse(value);
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "${UT_1_marks[Subjects[i]]}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : Text(
                              "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: UT_1_marks[Subjects[i]] != null
                          ? UT_2_marks[Subjects[i]] == -1
                              ? TextField(
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    UT_2_marks[Subjects[i]] = int.parse(value);
                                  },
                                  keyboardType: TextInputType.number,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${UT_2_marks[Subjects[i]]}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : Text(""),
                    ),
                  ),
                  TableCell(
                    child: Center(
                        child: ApprovalStatus != {} &&
                                ApprovalStatus[Subjects[i]] != null
                            ? ApprovalStatus[Subjects[i]]["status"] !=
                                    "Completed"
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                appBarColor)),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (builder) => AlertDialog(
                                                backgroundColor: dialogboxColor,
                                                content: CustomTextField(
                                                  hintText: 'message',
                                                  icon: Icon(
                                                      Icons.message_outlined),
                                                  obscureText: false,
                                                  textEditingController:
                                                      msgController,
                                                ),
                                                title: Text(
                                                  "Action for ${Subjects[i]} Submission",
                                                  style:
                                                      AppWidget.boldTextStyle(),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    appBarColor)),
                                                    onPressed: () {},
                                                    child: Text(
                                                      "Revise",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      ApprovalStatus[
                                                                  Subjects[i]]
                                                              ["status"] =
                                                          "Completed";
                                                      ApprovalStatus[
                                                                  Subjects[i]]
                                                              ["message"] =
                                                          msgController.text
                                                              .toString();
                                                      await firestore
                                                          .collection("Users")
                                                          .doc(widget.userId)
                                                          .update({
                                                        "Approval Status":
                                                            ApprovalStatus
                                                      });
                                                      refresh();
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    appBarColor)),
                                                    child: Text(
                                                      "Approve",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              ));
                                    },
                                    child: Text(
                                      "Action",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.white),
                                    ),
                                  )
                                : Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Text(
                                        "Approved",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.green),
                                      ),
                                    ),
                                  )
                            : Text("")),
                  ),
                ])
            ],
          ),
          Table(
            columnWidths: {
              0: FixedColumnWidth(90),
              1: FixedColumnWidth(80), // Adjust the width of the UT 1 column
              2: FixedColumnWidth(80), // Adjust the width of the UT 2 column
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Attendance != null &&
                              Attendance[Subjects[i]] != null &&
                              Attendance[Subjects[i]]["attended"] != null
                          ? Attendance[Subjects[i]]["attended"] == -1
                              ? TextField(
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    Attendance[Subjects[i]]["attended"] =
                                        int.parse(value);
                                    print(Attendance);
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "${Attendance[Subjects[i]]["attended"]}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : Text(
                              "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Attendance != null &&
                              Attendance[Subjects[i]] != null &&
                              Attendance[Subjects[i]]["total"] != null
                          ? Attendance[Subjects[i]]["total"] == -1
                              ? TextField(
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    Attendance[Subjects[i]]["total"] =
                                        int.parse(value);
                                    print(Attendance);
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "${Attendance[Subjects[i]]["total"]}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : Text(
                              "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
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
                      )
                  )
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
                        child: Text('$total_attended',
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
                        child: Text('$total_present',
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
          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: defaulter,
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
                    'Student should increase his attendance before the end of the semester to 75%.',
                    style: TextStyle(
                      color: Colors.black, // Black description color
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(appBarColor)),
            onPressed: () async {
              await updateData();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Updated Data to Database")));
              refresh();
            },
            child: Text(
              "Update Student Data",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white),
            ),
          ),
        ]));
  }
}
