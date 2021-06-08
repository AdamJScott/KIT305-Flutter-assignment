import 'dart:typed_data';

import 'package:assignment_four/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailto/mailto.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';





void updateName(String unitID, String studentID, String studentName, int numberOfWeeks) async {
  CollectionReference unitCollection = FirebaseFirestore.instance.collection("units");

  FirebaseFirestore.instance.collection("timelog").add({"Action":"Updated Student with name of: ${studentName}", "TimeDate": DateTime.now() });


  for (int i = 1; i <= numberOfWeeks; i++){
    var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: i).get();
    querySnap.docs.forEach((weekDoc) async{
      var studentToUpdate = await unitCollection.doc(unitID).collection("weeks").doc(weekDoc.id).collection("students").where("studentID", isEqualTo: studentID).get();
      studentToUpdate.docs.forEach((student) {
        unitCollection.doc(unitID).collection("weeks").doc(weekDoc.id).collection("students").doc(student.id).update({"studentName": studentName});
      });
    });

  }
}

class StudentDetailView extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseStorage storage = FirebaseStorage.instance;


  final String unitname;//unitReference
  final String unitID;
  final String grade;

  String studentName;//filePath
  final String studentID;//studentReference
  final int numberOfWeeks;
  

  StudentDetailView({Key? key, required this.studentName, required this.studentID, required this.unitname, required this.unitID, required this.grade, required this.numberOfWeeks}) : super (key:key);



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
              create: (context) => SingleStudent(studentID: studentID, unitID: unitID),
              child: StudentDetailViewSt(studentName: studentName, studentID: studentID, unitName: unitname, unitID: unitID, grade: grade, numberOfWeeks: numberOfWeeks),
            );
          }

        return MaterialApp(
            home:  Scaffold(
                body: SafeArea(
                    child: Align(
                        alignment: Alignment(0.5, 0.5),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator()
                              )
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
  StudentDetailViewSt({Key? key, required this.studentName, required this.studentID, required this.unitName, required this.unitID, required this.grade, required this.numberOfWeeks}) : super(key: key);

  String studentName;
  final String studentID;
  final String unitName;
  final String unitID;
  final String grade;
  final int numberOfWeeks;



  @override
  _StudentDetailViewState createState() => _StudentDetailViewState(studentName: studentName, studentID: studentID, unitID: unitID);
}





class _StudentDetailViewState extends State<StudentDetailViewSt>{
  late TextEditingController studentFieldController;
  late Future<List<String>> filesFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  double fontSizeVar = 25;

  String studentName;
  final String studentID;
  final String unitID;
  late Reference image;
  late Image imagePhoto;

  late String lastGrade;

  late final student = new SingleStudent(studentID: studentID, unitID: unitID);


  // Image image = Image.network("https://i.pinimg.com/474x/61/c7/80/61c780b045f999daacfd85e6f5ee96c8.jpg", height: 150, width: 150);

  _StudentDetailViewState({Key? key, required this.studentName, required this.studentID, required this.unitID});



  @override
  initState(){
    super.initState();

    lastGrade = widget.grade;
    student.setGradeAverageAndAttend();

    image = FirebaseStorage.instance.ref(widget.studentName);

    studentFieldController = TextEditingController();
    studentFieldController.text = studentName;
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
        title: Text(studentName),
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
                    FutureBuilder(
                      future: image.getDownloadURL(),
                      builder: (context, snapshot) {
                          if (snapshot.hasData == true){
                            imagePhoto = Image.network(snapshot.data.toString(), width: 150, height: 150);

                            return imagePhoto;
                          }
                          else if (snapshot.hasError){
                            return Icon(Icons.add_a_photo, size: 150);
                          }
                          else{
                            return Center(child: CircularProgressIndicator());
                          }
                      },
                    ),

                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {

                            final cameras = await availableCameras();
                            final firstCam = cameras.first;

                            try {
                              var picture = await Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TakePictureScreen(
                                              camera: firstCam, studentName: studentName
                                          )
                                  )
                              );

                              setState(() {
                                reassemble();
                              });

                            } catch (e){
                              print(e);
                            }
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
                            File _image;

                            final picker = ImagePicker();
                            bool _uploading = false;

                            void setImage(File file) async{


                              FirebaseFirestore.instance.collection("timelog").add({"Action":"Updated Student Photo with name of: ${studentName}", "TimeDate": DateTime.now() });

                              await FirebaseStorage.instance.ref(widget.studentName).putFile(file).whenComplete((){
                                print("File should be uploaded");
                                setState(() {
                                  imagePhoto = Image.file(file);
                                });
                              });
                            }

                            Future getImage() async{
                              final pickedFile = await picker.getImage(source: ImageSource.gallery);
                              setState((){
                                if (pickedFile != null){
                                  setImage(File(pickedFile.path));
                                }
                                else{
                                  print("Nothing selected");
                                }
                              });
                            }

                            setState(() {
                              getImage();
                            });


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
                            FirebaseFirestore.instance.collection("timelog").add({"Action":"Deleted student photo with name of: ${widget.studentName}", "TimeDate": DateTime.now() });
                            void deleteImage() async{
                              await FirebaseStorage.instance.ref(widget.studentName).delete().whenComplete((){
                                setState(() {
                                  reassemble();
                                });
                              });
                            }

                            deleteImage();

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
                          if (value.isNotEmpty){
                            updateName(widget.unitID, studentID, value, widget.numberOfWeeks);
                          }
                        },
                        controller: studentFieldController,
                        obscureText: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSizeVar,
                        ),
                        decoration: const InputDecoration(

                          border: OutlineInputBorder(),
                          labelText: 'Change student name',
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
                    ),),
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
                  Text("${student.gradeAverage} / 100",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),
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
                  Text(student.attendancePercent,
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),
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
                  Text(lastGrade,
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),
                  ),
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

                      if (student.loading == false){
                        launchMailto() async {
                          final mailtoLink = Mailto(
                            to: ["enterEmailHere@email.com"],
                            cc: [""],
                            subject: "Report generated for $studentName",
                            body: student.emailSummary.join("\n"),
                          );

                          await launch('${mailtoLink}');
                        }

                        launchMailto();
                      }
                      else{
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: false,
                            content: Padding(
                              padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                  [
                                    Text("Please wait for the generation of values to be completed"),
                                  ],
                              ),
                            ),
                          );
                        },
                        );
                      }




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
              Row(mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        student.gradeAverage = student.information[0];
                        student.attendancePercent = student.information[1];
                      });
                    },
                    child: const Text("Update Fields"),
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

              )


            ],
          )
        ),
      ),
    );
  }
}



class TakePictureScreen extends StatefulWidget{
  final CameraDescription camera;
  final String studentName;

  const TakePictureScreen({Key? key, required this.camera, required this.studentName}) : super (key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late bool _uploading;


  void initState(){
    super.initState();

    _uploading = false;

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );


    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build (BuildContext context){
    return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return CameraPreview(
              _controller,
              child: Stack(
                  children: [

                    Positioned(
                        left: 40,
                        bottom: 40,
                        child: FloatingActionButton(
                          child: Icon(Icons.arrow_back),
                          onPressed: () { Navigator.pop(context, false);},
                        )
                    ),

                    Positioned(
                      right: 40,
                      bottom: 40,
                      child: FloatingActionButton(
                        child: _uploading ? CircularProgressIndicator() : Icon(Icons.add),
                        onPressed: () async{
                          try {
                            await _initializeControllerFuture;

                            final image = await _controller.takePicture();
                            final picture = File(image.path);

                            setState(() {
                              _uploading = true; //visual feedback of upload
                            });

                            //TODO UHH ADD REFERENCE / UPDATE REFERENCE IN FIREBASE
                            await FirebaseStorage.instance.ref(widget.studentName).putFile(picture);
                            FirebaseFirestore.instance.collection("timelog").add({"Action":"Took new Student Photo with name of: ${widget.studentName}", "TimeDate": DateTime.now() });

                            setState(() {
                              _uploading = false; //visual feedback of upload
                            });

                            Navigator.pop(context, picture);
                          }
                          catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ]
              ),
            );
          }
          else{
            return Center (child: CircularProgressIndicator());
          }
        }
    );
  }
}