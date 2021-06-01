import 'package:assignment_four/student.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';




class StudentDetailView extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final String unitname;//unitReference

  String studentName;//filePath
  final String studentID;//studentReference

  StudentDetailView({Key? key, required this.studentName, required this.studentID, required this.unitname}) : super (key:key);

  @override
  Widget build (BuildContext context){
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        if (snapshot.hasError){
          //something wrong
        }
        if (snapshot.connectionState == ConnectionState.done){
          return ChangeNotifierProvider(
              create: (context) => singleStudent(),
              child: StudentDetailViewSt(studentName: studentName, studentID: studentID, unitName: unitname),
          );
        }
        return MaterialApp(
            home:  Scaffold(
                body: SafeArea(
                    child: Align(
                        alignment: Alignment(0.5, 0.5),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Loading Application', style: TextStyle(fontSize: 40),
                              ),
                            ]
                        )
                    )
                )
            )
        );

      }
    );
  }

}

class StudentDetailViewSt extends StatefulWidget {
  //const StudentDetailView({Key key}) : super(key: key);
  StudentDetailViewSt({Key? key, required this.studentName, required this.studentID, required this.unitName}) : super(key: key);

  String studentName;
  final String studentID;
  final String unitName;


  @override
  _StudentDetailViewState createState() => _StudentDetailViewState(studentName: studentName, studentID: studentID);
}


Future<String> returnDownloadURL(String studentName, String studentID, String unitName) async {

  var reference = FirebaseStorage.instance.ref().child(studentName);
  String downloadURL = await reference.getDownloadURL();
  downloadURL = Uri.decodeFull(downloadURL);
  downloadURL = downloadURL.split(" ").join("%20");
  print("Download URL is ${downloadURL}");
  return downloadURL;
}


void takePhoto() async {



}

class _StudentDetailViewState extends State<StudentDetailViewSt>{
  late TextEditingController studentFieldController;
  late String downloadURL;



  final scaffoldKey = GlobalKey<ScaffoldState>();
  double fontSizeVar = 25;

  String studentName;
  final String studentID;

  _StudentDetailViewState({Key? key, required this.studentName, required this.studentID});

  @override
  void initState() {
    super.initState();
    var reference = FirebaseStorage.instance.ref().child(studentName);
    downloadURL = returnDownloadURL(studentName, studentID, widget.unitName).toString();

    studentFieldController = TextEditingController();

    studentFieldController.text = studentName;//TODO
  }

  @override
  void dispose() {
    studentFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(studentName),//TODO change to variable
        centerTitle: true,
      ),
      key: scaffoldKey,
      body: SafeArea(
        child: Align(
          alignment: Alignment(0,0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:10),
                ],
              ),//SPACER
              Align(
                alignment: Alignment(0,0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: NetworkImage("https://i.pinimg.com/474x/61/c7/80/61c780b045f999daacfd85e6f5ee96c8.jpg"),
                      width: 150,
                      height: 150,
                    ),

                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            print('Take photo pressed ...'); //TODO

                          },
                          child: const Text("Take photo"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeVar,
                            ),
                          ),
                        ),//TAKE PHOTO
                        ElevatedButton(
                          onPressed: () {
                            print('Choose photo pressed ...'); //TODO
                          },
                          child: const Text("Choose photo"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeVar,
                            ),
                          ),
                        ),//CHOOSE PHOTO
                        ElevatedButton(
                          onPressed: () {
                            print('Remove Photo pressed ...'); //TODO
                          },
                          child: const Text("Remove photo"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeVar,
                            ),
                          ),
                        ),//REMOVE PHOTO
                      ],
                    ),
                  ],
                )
              ),//IMAGE AND BUTTONS
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      width: 250,
                      padding: EdgeInsets.fromLTRB(32,16,32,16),
                      child: TextField(
                        onSubmitted: (value) {
                          print("Submitted with $value");
                        },
                        controller: studentFieldController,
                        obscureText: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSizeVar,
                        ),
                        decoration: const InputDecoration(

                          border: OutlineInputBorder(),
                          labelText: 'Change student name',//TODO maybe set this to current name?
                          hintText: "Enter in student's new name",
                          ),
                       ),
                    ),
                  )
                ],
              ),//STUDENT NAME ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:8),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "Student ID: ",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),
                  ),
                  Text(studentID,
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),//TODO Change to variable
                ],
              ),//STUDENT ID ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Grade average: ",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),
                  Text("XXXXXX TODO",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),//TODO Change to variable
                ],
              ),//GRADE AVERAGE ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Attendance %: ",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),
                  Text("XXXXXX TODO",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),//TODO Change to variable
                ],
              ),//ATTENDANCE ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Last grade: ",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),
                  Text("XXXXXX TODO",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),//TODO Change to variable
                ],
              ),//LAST GRADE ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('Email summary pressed ...'); //TODO
                    },
                    child: const Text("Email summary"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeVar,
                      ),
                    ),
                  ),//EMAIL SUMMARY BUTTON
                ],
              ),//EMAIL SUMMARY


            ],
          )
        ),
      ),
    );
  }
}
