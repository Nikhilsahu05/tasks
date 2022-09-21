import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:tasks/data/announcements.dart';
import 'package:tasks/data/custom_user.dart';
import 'package:tasks/services/classes_db.dart';
import 'package:tasks/services/submissions_db.dart';
import 'package:tasks/services/updatealldata.dart';
import 'package:provider/provider.dart';

class AddClass extends StatefulWidget {

  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {

  String className = "";

  // for form validation
  final _formKey = GlobalKey<FormState>();


  // build func
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      // appbar part
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.5,
          title: Text(
            "Join Class",
            style: TextStyle(
                color: Colors.white, fontFamily: "Roboto", fontSize: 22),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () {},
            )
          ],
        ),

        // body part
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),

                    TextFormField(
                      decoration: InputDecoration(labelText: "Class Name", border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? 'Enter a class name' : null,
                      onChanged: (val) {
                        setState(() {
                          className = val;
                        });
                      },
                    ),

                    SizedBox(height: 20.0),

                    ElevatedButton(
                      child: Text("Join",
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Roboto",
                              fontSize: 22)
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate())  {
                          await ClassesDB(user: user).updateStudentClasses(className);

                          for(int i=0; i<announcementList.length; i++) {
                            if(announcementList[i].classroom.className == className && announcementList[i].type == "Assignment") {
                              await SubmissionDB().addSubmissions(user!.uid, className, announcementList[i].title);
                            }
                          }

                          await updateAllData();

                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        minimumSize: Size(150, 50),
                      ),
                    )
                  ],
                ))],
        ));
  }
}