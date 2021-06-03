import 'dart:collection';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:assignment_four/StudentDetailView.dart';
import 'package:assignment_four/WeekReportView.dart';
import 'package:assignment_four/student.dart';
//TODO https://rsainik80.medium.com/dropdown-button-inside-listview-builder-in-flutter-e2eb74fb45b4

//Helper functions
bool isNumericUsing_tryParse(String string) {
  // Null or empty string is not a number
  if (string == null || string.isEmpty) {
    return false;
  }

  // Try to parse input string to number.
  // Both integer and double work.
  // Use int.tryParse if you want to check integer only.
  // Use double.tryParse if you want to check double only.
  final number = num.tryParse(string);

  if (number == null) {
    return false;
  }
  return true;
}


class ClassView extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final String unitname;
  final String unitID;
  final int numberOfWeeks;

  ClassView({Key? key, required this.unitname, required this.unitID, required this.numberOfWeeks}) : super(key: key);

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
              child: ClassViewSt(unitname: unitname, unitID: unitID, numberOfWeeks: numberOfWeeks),
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
  ClassViewSt({Key? key, required this.unitname, required this.unitID, required this.numberOfWeeks}) : super(key: key);

  final String unitname;
  final String unitID;
  final int numberOfWeeks;

  @override
  _ClassViewSt createState() => _ClassViewSt(unitID: unitID);
}


int incrementWeek(int weekNumber, int maxWeeks){
  print("Called incrememebt week in function $weekNumber");
  if (weekNumber < maxWeeks){
    weekNumber++;
  }
  else {
    //Do I do something else?
  }

  if (weekNumber == maxWeeks){
    //Dont increment
    //Set the button to go next to disable
  }

  return weekNumber;
}


int decrementWeek(int weekNumber, int maxWeeks){

  if (weekNumber >= 2){
    weekNumber--;
  }
  else {
    //Do I do something else?
  }

  if (weekNumber == 1){
    //Dont decrement
    //Set the button to go last to disable
  }

  return weekNumber;
}

class _ClassViewSt extends State<ClassViewSt> {
  int weekNumber = 1;

  late TextEditingController searchFieldController;
  late String weekNoText;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String unitID;
  late final students = new StudentModel(weekNumber, widget.unitID);

  //Variables
  String dropDownValue = "UG";//TODO







  _ClassViewSt({required this.unitID});


  @override
  void initState() {
    // TODO: implement initState
    searchFieldController = TextEditingController();
    weekNoText = "Week ${weekNumber}";


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
                    LastElevatedButton(style, students),
                    Align(
                      child: Text(
                        weekNoText, //TODO CHANGE TO VARIABLE
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    NextElevatedButton(style, students),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Marking Scheme: ${students.markingScheme}', //TODO change to variable
                    ),
                ],
              ), // row for marking scheme label
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonBar(
                    children: <Widget>[
                      TextButton(
                        child: Text("Name asc."),
                        onPressed: () {
                          print("pressed asc");
                          students.sortByAscending();
                        },
                      ),
                      TextButton(
                        child: Text("Name desc."),
                        onPressed: () {
                          print("pressed desc");
                          students.sortByDescending();
                        },
                      ),
                      TextButton(
                        child: Text("Graded"),
                        onPressed: () {
                          students.sortByGraded();

                        },
                      ),
                      TextButton(
                        child: Text("Ungraded"),
                        onPressed: () {
                          students.sortByUnGraded();
                        },
                      ),
                    ]
                  )
                ],
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
                      child: buildListView(students, students.markingScheme),
                    ),
                  )
                ],
              ),//TODO Row for table
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BuildAddButton(context, students),//ADD STUDENT
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
                  DeleteStudentButton(context, students),//REMOVE STUDENT
                  ElevatedButton(
                    onPressed: () {

                      double attendancePercentage = 0.0;
                      String gradeAverage = "";

                      List<String>studentReport = [];
                      var map = Map();
                      studentReport.add("Unit: ${widget.unitname}, Week number: ${weekNumber}\n");
                      studentReport.add("Student Name, StudentID, Grade Received\n");
                      //TODO GENERATE REPORT
                      for (Student student in students.listOfStudents){

                        if (!map.containsKey(student.grade)){
                          map[student.grade] = 1;
                        }
                        else{
                          map[student.grade] += 1;
                        }
                        //Report generation
                        studentReport.add("${student.studentName}, ${student.studentID}, ${student.grade}\n");
                      }

                      var sortedMap = map.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
                      gradeAverage = sortedMap.first.key.toString();

                      var numberOfUGs = map["UG"];

                      if (numberOfUGs == null){
                        attendancePercentage = 100;
                      }
                      else{
                        attendancePercentage = ((students.listOfStudents.length - numberOfUGs) / students.listOfStudents.length) * 100;
                      }
                      print(attendancePercentage);

                      Navigator.push(context, MaterialPageRoute(builder: (context) { return WeekReportView(unit: widget.unitname, weekNumber: weekNumber, studentReport: studentReport, attendance: attendancePercentage, gradeAverage: gradeAverage); }));//print('View Report pressed ...'); //TODO
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

  ElevatedButton NextElevatedButton(ButtonStyle style, StudentModel students) {
    return ElevatedButton(
                    style: style,
                    onPressed: () {
                      weekNumber = incrementWeek(weekNumber, widget.numberOfWeeks);

                      setState(() {
                        weekNoText = "Week ${weekNumber}";
                        students.fetchWeek(weekNumber, unitID);
                      });

                    },
                    child: const Text("Next"),
                  );
  }

  ElevatedButton LastElevatedButton(ButtonStyle style, StudentModel students) {
    return ElevatedButton(
                    style: style,
                    onPressed: () {
                      weekNumber = decrementWeek(weekNumber, widget.numberOfWeeks);
                      setState(() {
                        weekNoText = "Week ${weekNumber}";
                        students.fetchWeek(weekNumber, unitID);
                      });
                    },
                    child: const Text("Last"),
                  );
  }

  ElevatedButton DeleteStudentButton(BuildContext context, StudentModel students) {
    return ElevatedButton(
                  onPressed: () {
                    print('RemoveStudent pressed ...'); //TODO
                    final IDController = TextEditingController();

                    //build another alert
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context){
                          return AlertDialog(
                            scrollable: false,
                            content: Padding(
                              padding: const EdgeInsets.all(16.0),

                              child: Form(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: IDController,
                                        decoration: InputDecoration(
                                          labelText: 'Input Student ID to delete:',
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                child: Text("Cancel"),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    onPrimary: Colors.white,
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Text("Unenrol student"),
                                onPressed: (){
                                    //Create new dialog that gets the student ID, if not, return something else
                                  Student idExists = students.listOfStudents.firstWhere((studentIDNumber) => studentIDNumber.studentID == IDController.text, orElse: () => new Student(studentName: "", studentID: "", grade: ""));

                                  if (idExists.studentID == IDController.text){
                                    //ID exists
                                    print("student exists");
                                    showDialog(context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              content: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          "Are you sure you want to unenrol ${idExists.studentName} with the ID of: ${IDController.text} from the class?\nThis cannot be reversed."),
                                                    ],
                                                  )
                                              ),
                                            actions: [
                                              ElevatedButton(
                                                child: Text("Cancel"),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red,
                                                  onPrimary: Colors.white,
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  ),
                                                child: Text("Unenrol student"),
                                                onPressed: (){
                                                  students.deleteStudent(unitID, weekNumber, widget.numberOfWeeks, idExists);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }
                                              ),
                                            ],
                                          );
                                        });

                                  }
                                  else{
                                    print("Student does not exist within this week");
                                    //ID does not exist
                                    showDialog(context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              content: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          "Student with ID of: ${IDController.text} does not exist."),
                                                    ],
                                                  )
                                              )
                                          );
                                        });
                                  }

                                },
                              ),
                            ],
                          );

                        }
                    );

                    //students.deleteStudent(unitID, weekNumber, widget.numberOfWeeks, Student(studentName: "doesnMater", studentID: "5", grade: "UG"));

                  },
                  child: const Text("Remove a student"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
  }

  ElevatedButton BuildAddButton(BuildContext context, StudentModel students) {
    return ElevatedButton(
                  onPressed: () {
                    print('AddStudent pressed ...'); //TODO

                    final NameController = TextEditingController();
                    final IDController = TextEditingController();


                    showDialog(
                      //https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup
                      context: context,
                        barrierDismissible: true,

                        builder: (BuildContext context){
                        return AlertDialog(
                          scrollable: false,
                          content: Padding(
                            padding: const EdgeInsets.all(16.0),

                            child: Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: NameController,
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: IDController,
                                    decoration: InputDecoration(
                                      labelText: 'Student ID',
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                          actions: [


                            ElevatedButton(
                              child: Text("Cancel"),
                              onPressed: (){
                                  Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                child: Text("Create new student"),
                                onPressed: () {
                                  //https://coflutter.com/dart-flutter-how-to-check-if-a-string-is-a-number/


                                  //Check if ID number is a number
                                  bool idIsNumber = isNumericUsing_tryParse(
                                      IDController.text);

                                  //Check if the student exists, if not, make an empty one
                                  Student idExists = students.listOfStudents.firstWhere((studentIDNumber) => studentIDNumber.studentID == IDController.text, orElse: () => new Student(studentName: "", studentID: "", grade: ""));

                                  if (NameController.text.isNotEmpty &&
                                      IDController.text.isNotEmpty &&
                                      idIsNumber && !idExists.studentID.isNotEmpty) {
                                    Student newStu = new Student(
                                        studentName: NameController.text,
                                        studentID: IDController.text,
                                        grade: "UG");
                                    students.addStudent(unitID, weekNumber,
                                        widget.numberOfWeeks, newStu);
                                    Navigator.pop(context);
                                  }
                                  else {
                                    showDialog(context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              content: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          "Please enter in a valid name or ID"),
                                                    ],
                                                  )
                                              )
                                          );
                                        });
                                  }
                                }
                            ),
                          ],
                        );
                      }
                    );
                  },
                  child: const Text("Add a student"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
  }

  ListView buildListView(StudentModel students, String gradeScheme) {

    List<String> grades;

    switch (gradeScheme){
      case "hd":
        grades = <String>['HD', 'DN', 'CR', 'PP', 'NN', 'UG'];
        break;
      case "a":
        grades = <String>['A', 'B', 'C', 'D', 'F', 'UG'];
        break;
      case "att":
        grades = <String>['Attended', 'Not attended'];
        break;
      case "num":
        grades = <String>['100', '90', '80', '70', '60', '50'];
        break;
      case "chk":
        grades = <String>['a'];
        break;
      default:
        grades = <String>['something broke'];
        break;
    }


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
                  return StudentDetailView(studentName: student.studentName, studentID: student.studentID, unitname: widget.unitname);
                }));
            },
            subtitle: Text(student.studentID),
            trailing:  new DropdownButton<String>(
              value: student.grade,
              onChanged: (String? newValue) {
                setState(() {
                  dropDownValue = newValue!;
                  student.grade = dropDownValue;
                  students.update(unitID, weekNumber, student);
                });
              }, //Gets the changed value

              items: grades.map((String value) {
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

