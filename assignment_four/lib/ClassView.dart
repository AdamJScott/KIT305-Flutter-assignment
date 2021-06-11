
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:provider/provider.dart';

import 'package:assignment_four/StudentDetailView.dart';
import 'package:assignment_four/WeekReportView.dart';
import 'package:assignment_four/student.dart';
import 'package:url_launcher/url_launcher.dart';

//Helper functions
//Taken from https://coflutter.com/dart-flutter-how-to-check-if-a-string-is-a-number/ uploaded by Phuc Tran on the 6th of November 2020.
// ignore: non_constant_identifier_names
bool isNumericUsing_tryParse(String string) {
  // Null or empty string is not a number
  if (string == null || string.isEmpty) {
    return false;
  }

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
  bool searchedAlready = false;






  _ClassViewSt({required this.unitID});


  @override
  void initState() {
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
      title: Text(widget.unitname),
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 16.0, 16.0, 16.0),
          child: GestureDetector(
            onTap: () {
              students.generateUnitReport(unitID, widget.numberOfWeeks, context);
              },
            child:
              Row(
                children: [
                  Text("Unit Report "),
                  Icon(
                    Icons.email
                  ),
                ],
              ),

          )
        )
      ],
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
                        weekNoText,
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
                    'Marking Scheme: ${students.markingScheme}',
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
                          students.sortByAscending();
                        },
                      ),
                      TextButton(
                        child: Text("Name desc."),
                        onPressed: () {
                          students.sortByDescending();
                        },
                      ),
                      TextButton(
                        child: Text("ID"),
                        onPressed: () {
                          students.sortByID();

                        },
                      ),
                      TextButton(
                        child: Text("Grade"),
                        onPressed: () {
                          students.sortByGraded();
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
                        onTap: (){
                          searchFieldController.text = "";

                          if (searchedAlready){
                            students.fetchWeek(weekNumber, unitID);
                            searchedAlready = false;
                          }
                        },
                        onFieldSubmitted: (value){
                          students.filterByName(value);
                          searchedAlready = true;
                        },
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
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                          bottom: BorderSide(color: Colors.black),
                        ),
                      ),
                      child: buildListView(students, students.markingScheme),
                    ),
                  )
                ],
              ),//TODO Row for table
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 150,
                      height: 40,
                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                      child: BuildAddButton(context, students, students.markingScheme)),//ADD STUDENT
                  Container(
                    width: 150,
                    height: 40,
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    child: ElevatedButton(
                      onPressed: () async {

                        List<String> studentReport = [];

                        for (Student student in students.listOfStudents){
                          //Report generation
                          studentReport.add("${student.studentName}, ${student.studentID}, ${student.grade}\n");
                        }

                        launchMailto() async {
                            final mailtoLink = Mailto(
                              to: ["enterEmailHere@email.com"],
                              cc: [""],
                              subject: "Week report for week ${weekNumber}",
                              body: studentReport.join(""),
                            );

                            await launch('${mailtoLink}');
                          }

                          launchMailto();
                        },
                      child: const Text("Email Report"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),//Email Report
                ],
              ),//ROW FOR ADD STUDENT AND EMAIL REPORT
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 150,
                      height: 40,
                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                      child: DeleteStudentButton(context, students)),//REMOVE STUDENT
                  Container(
                    width: 150,
                    height: 40,
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    child: ElevatedButton(
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

                        Navigator.push(context, MaterialPageRoute(builder: (context) { return WeekReportView(unit: widget.unitname, weekNumber: weekNumber, studentReport: studentReport, attendance: attendancePercentage, gradeAverage: gradeAverage); }));
                      },
                      child: const Text("View Report"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),//VIEW REPORT
                ],
              ),//ROW FOR REMOVE A STUDENT AND VIEW REPORT
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 200,
                      height: 40,
                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                      child: changeMarkScheme(students, weekNumber)
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

  ElevatedButton changeMarkScheme(StudentModel students, int weeknumber) {
    return ElevatedButton(

                  onPressed: () {

                    /*
                      Make alert dialog full of buttons for each thing, another alert for checkpoints?
                      Get selection
                      Change all grades to UG, and update firebase
                      Set the week gradescheme on firebase to the new marking scheme
                     */
                    TextEditingController IDController = TextEditingController();
                    String chkText = "Enter in the number of checkpoints you wish for the week to have:";

                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context)
                      {
                        return AlertDialog(
                          scrollable: false,
                          content: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Select a new scheme for this week\nNote that selecting any scheme will reset the grades.\n", textAlign: TextAlign.center),
                                    Container(
                                      width: 200,
                                      height: 40,
                                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                                      child: ElevatedButton(onPressed: () {
                                        for (Student stu in students.listOfStudents){
                                          stu.grade = "UG";
                                          students.update(unitID, weeknumber, stu, false);
                                        }
                                        students.updateWeekGradeScheme(unitID, weeknumber, "hd");
                                        reassemble();
                                        Navigator.pop(context);

                                      }, child: Text("HD DN CR PP NN UG", textAlign: TextAlign.justify)),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 40,
                                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                                      child: ElevatedButton(onPressed: () {
                                        for (Student stu in students.listOfStudents){
                                          stu.grade = "UG";
                                          students.update(unitID, weeknumber, stu, false);
                                        }
                                        students.updateWeekGradeScheme(unitID, weeknumber, "a");
                                        reassemble();
                                        Navigator.pop(context);

                                      }, child: Text("A B C D F UG", textAlign: TextAlign.justify)),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 40,
                                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                                      child: ElevatedButton(onPressed: () {
                                        for (Student stu in students.listOfStudents){
                                          stu.grade = "Absent";
                                          students.update(unitID, weeknumber, stu, false);
                                        }
                                        students.updateWeekGradeScheme(unitID, weeknumber, "att");
                                        reassemble();
                                        Navigator.pop(context);

                                      }, child: Text("Present / Absent", textAlign: TextAlign.justify)),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 40,
                                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                                      child: ElevatedButton(onPressed: () {
                                        for (Student stu in students.listOfStudents){
                                          stu.grade = "0";
                                          students.update(unitID, weeknumber, stu, false);
                                        }
                                        students.updateWeekGradeScheme(unitID, weeknumber, "num");
                                        reassemble();
                                        Navigator.pop(context);

                                      }, child: Text("Numeric 0 to 100", textAlign: TextAlign.justify)),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 40,
                                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                                      child: ElevatedButton(onPressed: () {
                                        //Go to new alert with form
                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context)
                                          {
                                            return AlertDialog(
                                              scrollable: false,
                                              content: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Form(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(chkText),
                                                      Container(
                                                        width: 150,
                                                        height: 50,
                                                        child: TextField(
                                                          controller: IDController,
                                                          textAlign: TextAlign.center,
                                                          keyboardType: TextInputType.number,
                                                          onSubmitted: (value) {
                                                            int numberOfCheckpoints = int.parse(value);
                                                            if(int.tryParse(value) != null && numberOfCheckpoints < 20 && numberOfCheckpoints > 0){
                                                              String gradeScheme = "chk$numberOfCheckpoints";
                                                              for (Student stu in students.listOfStudents){
                                                                stu.grade = "Check 0";
                                                                students.update(unitID, weeknumber, stu, false);
                                                              }
                                                              students.updateWeekGradeScheme(unitID, weeknumber, gradeScheme);
                                                              reassemble();
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                            }
                                                            else{
                                                              showDialog(context: context, builder: (BuildContext context){
                                                                return AlertDialog(
                                                                  scrollable: false,
                                                                  content: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text("Please enter in a real number that more than 0, and is less than 20\nPositive numbers only with no symbols"),
                                                                        ElevatedButton(onPressed: () { Navigator.pop(context); }, child: Text("Okay", textAlign: TextAlign.justify,)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                            }
                                                          },
                                                        )
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text("Cancel"))
                                                      ,
                                                    ],
                                                  )
                                                ),
                                              ),
                                            );
                                          }
                                        );
                                      }, child: Text("Checkpoints", textAlign: TextAlign.justify)),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.grey,
                                          onPrimary: Colors.white,
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                      )
                                    )
                                  ],
                                )
                            ),
                          ),
                        );
                      }
                    );
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
                );
  }

  ElevatedButton NextElevatedButton(ButtonStyle style, StudentModel students) {
    return ElevatedButton(
      style: style,
      onPressed: () {
        if (students.loading == false) {
          weekNumber = incrementWeek(weekNumber, widget.numberOfWeeks);
          setState(() {
            weekNoText = "Week ${weekNumber}";
            students.fetchWeek(weekNumber, unitID);
          });
        }
      },

      child: const Text("Next"),
    );
  }

  ElevatedButton LastElevatedButton(ButtonStyle style, StudentModel students) {

    return ElevatedButton(
      style: style,

      onPressed: () {
        if (students.loading == false) {
          weekNumber = decrementWeek(weekNumber, widget.numberOfWeeks);
          setState(() {
            weekNoText = "Week ${weekNumber}";
            students.fetchWeek(weekNumber, unitID);
          });
        }
      },
      child: const Text("Last"),
    );

  }

  ElevatedButton DeleteStudentButton(BuildContext context, StudentModel students) {
    return ElevatedButton(
                  onPressed: () {
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

  ElevatedButton BuildAddButton(BuildContext context, StudentModel students, String gradeScheme) {
    return ElevatedButton(
                  onPressed: () {

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
                                                          "Please enter in a valid name or ID, as the ID may already be taken or the ID is not a number"),
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

    List<String> grades = <String>[];
    grades.clear();
    int numberOfChkns = 0;
    String newScheme = gradeScheme;

    if (newScheme.length > 3){
      //then it's chkn
      numberOfChkns = int.parse(gradeScheme.substring(3).toString());
      newScheme = "${gradeScheme[0]}${gradeScheme[1]}${gradeScheme[2]}";
    }

    switch (newScheme){
      case "hd":
        grades = <String>['HD', 'DN', 'CR', 'PP', 'NN', 'UG'];
        break;
      case "a":
        grades = <String>['A', 'B', 'C', 'D', 'F', 'UG'];
        break;
      case "att":
        grades = <String>['Present', 'Absent'];
        break;
      case "num":
        grades = <String>['100', '90', '80', '70', '60', '50', '0'];
        break;
      case "chk":
        grades = <String>[];
        for (int i = 0; i < numberOfChkns + 1; i++){
          grades.add("Check $i");
        }
        break;
      default:
        grades = <String>['something broke'];
        break;
    }


    return ListView.builder(
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.vertical,

        shrinkWrap: true,

        itemBuilder: (context, index) {
          var student = students.listOfStudents[index];

          //Set UG's to valid grades in scheme
          if (student.grade.contains("UG") && gradeScheme == "att"){
            student.grade = grades.last;
          }
          else if (student.grade.contains("UG") && gradeScheme == "num"){
            student.grade = "0";
          }
          else if (student.grade.contains("UG") && gradeScheme == "chk"){
            student.grade = "Check 0";
          }

          if (gradeScheme != "num") {
            return Container(
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                    )
                ),
                child: ListTile(

                title: Text(student.studentName),
                onLongPress: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) {
                      return StudentDetailView(studentName: student.studentName, studentID: student.studentID, unitname: widget.unitname, unitID: widget.unitID, grade: student.grade, numberOfWeeks: widget.numberOfWeeks);
                    })).then((value) {
                    students.fetchWeek(weekNumber, unitID);
                  });
                },
                subtitle: Text(student.studentID),
                trailing:
                  new DropdownButton<String>(
                    value: student.grade,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                        student.grade = dropDownValue;
                        students.update(unitID, weekNumber, student, false);
                      });
                    }, //Gets the changed value
                    items: grades.map((String value) {
                      return new DropdownMenuItem<String>(
                        child: new Text(value),
                        value: value,
                      );
                    }).toList(), //Creates the text for each element in list

                  ),
                ),
            );
          }
          else{
            TextEditingController controlBoi = TextEditingController();
            controlBoi.text = student.grade;

            return Container(
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                  )
              ),
              child: ListTile(
                title: Text(student.studentName),
                onLongPress: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) {
                    return StudentDetailView(studentName: student.studentName, studentID: student.studentID, unitname: widget.unitname, unitID: widget.unitID, grade: student.grade, numberOfWeeks: widget.numberOfWeeks);
                  })).then((value) {
                    students.fetchWeek(weekNumber, unitID);
                  });
                },
                subtitle: Text(student.studentID),
                trailing: Container(
                  width: 75,
                  height: 40,
                  child: TextField(
                    controller: controlBoi,
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      int gradeToSubmit;


                      if (isNumericUsing_tryParse(value)){
                        if (int.parse(value) > 100){
                          gradeToSubmit = 100;
                        }
                        else{
                          gradeToSubmit = int.parse(value);
                        }

                        student.grade = gradeToSubmit.toString();
                        students.update(unitID, weekNumber, student, false);
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
                                              "Please enter a number between 0 and 100."),
                                        ],
                                      )
                                  )
                              );
                            });

                        controlBoi.text = student.grade.toString();
                      }
                    },
                    onTap: () {
                      controlBoi.text = "";
                    },

                  ),
                ),
              ),
            );
          }
        },
        itemCount: students.listOfStudents.length
    );
}
}

