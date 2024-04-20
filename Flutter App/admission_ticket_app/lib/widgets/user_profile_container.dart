import 'package:admission_ticket_app/colors.dart';
import 'package:admission_ticket_app/screens/teacher_screens/student_info_page.dart';
import 'package:flutter/material.dart';

class UserProfileContainer extends StatelessWidget {
  final String profilePhotoUrl;
  final String userName;
  final bool completionStatus;
  final String userId;

  UserProfileContainer({
    required this.profilePhotoUrl,
    required this.userName,
    required this.completionStatus,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StudentInfoPage(userId: userId, userName: userName, profile_pic: profilePhotoUrl,)));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        elevation: 4,
        color: Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile photo
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(profilePhotoUrl),
              ),
              SizedBox(width: 16.0), // Spacing between photo and text
              // User info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0), // Spacing between name and status
                  Text(
                    completionStatus ? 'Completed' : 'Pending',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
      
                      color: completionStatus ? Colors.green : Colors.red,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
