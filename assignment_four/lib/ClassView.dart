import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:assignment_four/StudentDetailView.dart';
import 'package:assignment_four/WeekReportView.dart';
import 'package:assignment_four/student.dart';
//TODO https://rsainik80.medium.com/dropdown-button-inside-listview-builder-in-flutter-e2eb74fb45b4

class ClassView extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final String unitname;
  final String unitID;

  ClassView({Key? key, required this.unitname, required this.unitID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
        builder: (context, snapshot){
          // Check for errors
          if (snapshot.hasError) {
            //return FullScreenText(text:"Something went wrong");
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
              create: (context) => StudentModel(1, unitID),
              child: ClassViewSt(unitname: unitname, unitID: unitID),
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


class ClassViewSt extends StatefulWidget {
  ClassViewSt({Key? key, required this.unitname, required this.unitID}) : super(key: key);

  final String unitname;
  final String unitID;

  @override
  _ClassViewSt createState() => _ClassViewSt(unitID: unitID);
}

class _ClassViewSt extends State<ClassViewSt> {
  late TextEditingController searchFieldController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String unitID;
  late final students = new StudentModel(1, widget.unitID);

  //Variables
  String dropDownValue = "UG";
  _ClassViewSt({required this.unitID});


  @override
  void initState() {
    // TODO: implement initState
    searchFieldController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(
      builder: buildScaffold
    );
  }

  Scaffold buildScaffold(BuildContext context, StudentModel students, _) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));//https://api.flutter.dev/flutter/material/ElevatedButton-class.html

    return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),

      ),
      title: Text(widget.unitname),//TODO UNIT CODE IS DONE
      centerTitle: true,
    ),

    key: scaffoldKey,
    body: SafeArea(
      child: Align(
        alignment: Alignment(0, 0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment(0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: style,
                      onPressed: () {
                        print("last week pressed");
                      },
                      child: const Text("Last"),
                    ),
                    Align(
                      child: Text(
                        'Week N', //TODO CHANGE TO VARIABLE
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: style,
                      onPressed: () {},
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Marking Scheme: HD', //TODO change to variable
                    ),
                ],
              ), // row for marking scheme label
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [], //TODO IMPLEMENT BUTTON BAR THING
              ), //ROW for sort bar
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment(0, 0),
                      child: TextFormField(
                        controller: searchFieldController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: 'Search for a student via name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),//Row for search bar
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (students.loading) CircularProgressIndicator() else
                    Expanded(
                    child: Container(
                      height: 350,
                      child: buildListView(students),
                    ),
                  )
                ],
              ),//TODO Row for table
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('AddStudent pressed ...'); //TODO
                    },
                    child: const Text("Add a student"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),//ADD STUDENT
                  ElevatedButton(
                    onPressed: () {
                      print('Email Report pressed ...'); //TODO
                    },
                    child: const Text("Email Report"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),//Email Report
                ],
              ),//ROW FOR ADD STUDENT AND EMAIL REPORT
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('RemoveStudent pressed ...'); //TODO
                    },
                    child: const Text("Remove a student"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),//REMOVE STUDENT
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) { return WeekReportView(); }));//print('View Report pressed ...'); //TODO
                    },
                    child: const Text("View Report"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),//VIEW REPORT
                ],
              ),//ROW FOR REMOVE A STUDENT AND VIEW REPORT
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(

                    onPressed: () {
                      print('Change mark scheme pressed ...'); //TODO
                    },
                    child: const Text("Change marking scheme"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(250),
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),//Change Marking scheme
                ],
              )//ROW FOR CHANGE MARKING SCHEME
            ],
          ),
        ),
      ),
    ),
  );
  }

  ListView buildListView(StudentModel students) {

    print("called buildListView");
    print("student length: ${students.listOfStudents.length}");
    return ListView.builder(
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var student = students.listOfStudents[index];
          return ListTile(
            title: Text(student.studentName),
            onLongPress: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) {
                  return StudentDetailView(studentName: student.studentName, studentID: student.studentID);
                }));
            },
            subtitle: Text(student.studentID),
            trailing:  new DropdownButton<String>(
              value: dropDownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropDownValue = newValue!;
                  print("Value changed to $dropDownValue");
                });
              }, //Gets the changed value

              items: <String>['A', 'B', 'C', 'D', 'F', 'UG'].map((String value) {
                return new DropdownMenuItem<String>(
                  child: new Text(value),
                  value: value,
                );
              }).toList(), //Creates the text for each element in list

              ),

            );
        },
        itemCount: students.listOfStudents.length
    );
}
}

