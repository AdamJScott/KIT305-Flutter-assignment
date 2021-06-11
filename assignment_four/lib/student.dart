
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';



class Student {
  String studentName;
  String studentID;
  String doc_id = "";
  String grade;
  bool attended = false;//Not used anymore

  Student({required this.studentName, required this.studentID, required this.grade});


  Map<String, dynamic> toJson() =>
      {
        'attended': attended,
        'grade': grade,
        'studentID' : studentID,
        'studentName': studentName,
        'doc_id': doc_id
      };
}


class StudentModel extends ChangeNotifier{
  List<Student> listOfStudents = [];
  int numberOfStudents = 0;

  CollectionReference unitCollection = FirebaseFirestore.instance.collection("units");


  bool loading = false;
  String markingScheme = "";



  StudentModel(int weekNumber, String unitID){
    fetchWeek(weekNumber, unitID);
  }



  void sortByAscending(){
    listOfStudents.sort((a,b) => a.studentName.compareTo(b.studentName));
    notifyListeners();
  }

  void sortByDescending(){

    listOfStudents.sort((b,a) => a.studentName.compareTo(b.studentName));
    notifyListeners();
  }

  void sortByGraded(){
    listOfStudents.sort((a,b) => a.grade.compareTo(b.grade));
    notifyListeners();
  }

  void sortByUnGraded(){
    listOfStudents.sort((b,a) => a.grade.compareTo(b.grade));
    notifyListeners();
  }

  void sortByID(){
    listOfStudents.sort((a,b) => int.parse(a.studentID).compareTo(int.parse(b.studentID)));
    notifyListeners();
  }

  void fetchWeek(int weekNumber, String unitID) async{
    loading = true;
    notifyListeners();
    listOfStudents.clear();

    var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: weekNumber).get();
    querySnap.docs.forEach((doc) async {
      if (doc.get("weekNumber") == weekNumber){
        //print("Document found $doc with ID of ${doc.id} with week number of ${doc.get("weekNumber")}");
        //fetchStudentList(doc.id);
        markingScheme = doc.get("gradeScheme");

        var studentSnap = await unitCollection.doc(unitID).collection("weeks").doc(doc.id).collection("students").orderBy("studentName").get();
        studentSnap.docs.forEach((stuFound) {
          var student = new Student(studentName: stuFound.get("studentName"), studentID: stuFound.get("studentID"), grade: stuFound.get("grade"));
          student.doc_id = stuFound.id;
          listOfStudents.add(student);
          numberOfStudents += 1;
          //print("Found student ${student.studentName}");
        });

        loading = false;
        notifyListeners();
      }
    });
  }

  void filterByName(String name){

    List<Student> studentList = listOfStudents.where((element) => element.studentName.toLowerCase().contains(name.toLowerCase())).toList();
    print(studentList);
    listOfStudents = studentList;
    notifyListeners();
  }

  void update(String unitID, int weeknumber, Student updateGrade, bool update) async{
    var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: weeknumber).get();
    querySnap.docs.forEach((doc) async {
      unitCollection.doc(unitID).collection("weeks").doc(doc.id).collection("students").doc(updateGrade.doc_id).set(updateGrade.toJson());
      //Update
      if (update){
        loading = true;
        fetchWeek(weeknumber, unitID);
      }
    });
  }

  void addStudent(String unitID, int weeknumber, int maxWeeks, Student newStudent) async{

    FirebaseFirestore.instance.collection("timelog").add({"Action":"Added Student with name of: ${newStudent.studentName}", "TimeDate": DateTime.now() });



    loading = true;
    for (int i = weeknumber; i <= maxWeeks; i++){



      var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: i).get();
      querySnap.docs.forEach((doc) async {

        String gradeScheme = doc.get("gradeScheme").toString();

        String grade = "UG";

        switch(gradeScheme){
          case "hd":
            break;
          case "a":
            break;
          case "num":
            grade = "0";
            break;
          case "att":
            grade = "Absent";
            break;
          default:
            grade = "Check 0";
            break;
        }

        newStudent.grade = grade;

        var studentCollection = unitCollection.doc(unitID).collection("weeks").doc(doc.id).collection("students");
        await studentCollection.add(newStudent.toJson());
      });

      if (i == weeknumber){
        fetchWeek(weeknumber, unitID);
      }
    }
  }

  void deleteStudent(String unitID, int weekNumber, int maxWeeks, Student deletedStudent) async{

    FirebaseFirestore.instance.collection("timelog").add({"Action":"DeletedStudent with name of: ${deletedStudent.studentName}", "TimeDate": DateTime.now() });

    loading = true;

    for (int i = weekNumber; i <= maxWeeks; i++){
      //Get the week document
      var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: i).get();
      querySnap.docs.forEach((weekDoc) async {
          //Get each week's student information
        var studentSnap = await unitCollection.doc(unitID).collection("weeks").doc(weekDoc.id).collection("students").where("studentID", isEqualTo: deletedStudent.studentID).get();
        studentSnap.docs.forEach((studentToDelete) async{
          unitCollection.doc(unitID).collection("weeks").doc(weekDoc.id).collection("students").doc(studentToDelete.id).delete();
        });
      });

      if (i == weekNumber){
        listOfStudents.clear();
        loading = true;
        notifyListeners();

        fetchWeek(weekNumber, unitID);
      }
    }
  }
  
  void updateWeekGradeScheme(String unitID, int weekNumber, String newScheme) async{
    loading = true;
    notifyListeners();

    FirebaseFirestore.instance.collection("timelog").add({"Action":"Updating week no $weekNumber in unit $unitID with: $newScheme", "TimeDate": DateTime.now() });

    var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: weekNumber).get();
    querySnap.docs.forEach((weekToUpdate) async{ 
      await unitCollection.doc(unitID).collection("weeks").doc(weekToUpdate.id).update({"gradeScheme": newScheme});
      fetchWeek(weekNumber, unitID);
    });

    //loading = false;
    notifyListeners();
  }

  double gradeConverter(String gradeScheme, Student student){

      /*
          100 - 80 - 60 - 50 - 20 - 0
          HD  - DN - CR - PP - NN - UG
          A   - B  - C  - D  - F  - UG
          Present                 - Absent
          ChkN                    - Chk0
          where n is the max



     */

    List<String> grades = [];
    grades.clear();
    int numberOfChkns = 0;
    double gradeValue = 0;
    String newScheme = gradeScheme;


    if (gradeScheme.startsWith("chk")){
      //then it's chkn
      numberOfChkns = int.parse(gradeScheme.substring(3).toString());
      newScheme = "${gradeScheme[0]}${gradeScheme[1]}${gradeScheme[2]}";
    }

      switch (newScheme){
      case "hd":
        grades = <String>['UG', 'NN', 'PP', 'CR', 'DN', 'HD'];
        break;
      case "a":
        grades = <String>['UG', 'F', 'D', 'C', 'B', 'A'];
        break;
      case "att":
        grades = <String>['Absent', 'Present'];
        break;
      case "num":
        //No need to do anything as it's already numeric
        break;
      case "chk":
        grades = <String>[];
        for (int i = 0; i < numberOfChkns + 1; i++){
          grades.add("Check $i");
        }
        break;
      default:
        print("Something went wrong");
        break;
    }

    if (gradeScheme != "num"){
        int indexOfGrade = grades.indexOf(student.grade);
        gradeValue = indexOfGrade * (100 / (grades.length -1 ));
    }
    else{
      gradeValue = double.parse(student.grade);
    }

    return gradeValue;
  }

 void generateUnitReport(String unitID, int numberOfWeeks, BuildContext context) async{

    List<double> gradesAccrued = new List.filled(numberOfWeeks, 0.0, growable: false);
    List<int> numberOfStudentsPerWeek = new List.filled(numberOfWeeks, 0, growable: false);



    showDialog(context: context,
          barrierDismissible: true,
          builder: (BuildContext context)
          {
            return AlertDialog(
                content: Padding(
                    padding: const EdgeInsets.all(
                        16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )
                )

            );
          });


    for (int i = 1; i <= numberOfWeeks; i++){

      String unitName = "";

      var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: i).get();
      querySnap.docs.forEach((week) async {

        String gradeScheme = week.get("gradeScheme");
        unitName = week.get("unitCode");

        var studentSnap = await unitCollection.doc(unitID).collection("weeks").doc(week.id).collection("students").get();
        studentSnap.docs.forEach((stuFound) {

          var student = new Student(studentName: stuFound.get("studentName"), studentID: stuFound.get("studentID"), grade: stuFound.get("grade"));

          gradesAccrued[i - 1] += gradeConverter(gradeScheme, student);
          numberOfStudentsPerWeek[i -1] += 1;

        });

        List<String> weekReport = [];

        weekReport.add("Unit Report for unit: ${unitName}");
        weekReport.add("Week Number, Grade Average (numeric), Number of Students");

        if (i == numberOfWeeks){
          for (int i = 0; i < numberOfWeeks; i++){
            gradesAccrued[i] = gradesAccrued[i] / numberOfStudentsPerWeek[i];

            weekReport.add("Week ${i}, ${gradesAccrued[i].toStringAsFixed(2)}, ${numberOfStudentsPerWeek[i]}");

          }

          Navigator.pop(context);

          showDialog(context: context,
              barrierDismissible: true,
              builder: (BuildContext context)
              {
                return AlertDialog(
                    content: Padding(
                        padding: const EdgeInsets.all(
                            16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                weekReport.join("\n"), textAlign: TextAlign.center,),
                            ElevatedButton(onPressed: () {

                              launchMailto() async {
                                final mailtoLink = Mailto(
                                  to: ["enterEmailHere@email.com"],
                                  cc: [""],
                                  subject: "${unitName} Report",
                                  body: weekReport.join("\n"),
                                );

                                await launch('${mailtoLink}');
                              }

                              launchMailto();

                            }, child: Text("Email Report")),
                          ],
                        )
                    )

                );
              }
          );
        }
      });
    }
  }
}

class SingleStudent extends ChangeNotifier{


  CollectionReference unitCollection = FirebaseFirestore.instance.collection("units");
  String gradeAverage = "";
  String attendancePercent = "";
  bool loading = false;

  List<String> information = ["Please wait", "For the calculations"];
  List<String> emailSummary = [];




  bool getLoading(){
    return loading;
  }


  String studentID;
  String unitID;


  SingleStudent({required this.studentID, required this.unitID});



  void setGradeAverageAndAttend() async{
    notifyListeners();
    loading = true;

    double nowsii = 0.0;//numberOfWeeksStudentIsIn
    double gradeTotal = 0.0;
    int missedWeeks = 0;

    var unitInfo = await FirebaseFirestore.instance.collection("units").doc(unitID).get();
    int numberOfWeeks = int.parse(unitInfo.get("numberOfWeeks").toString());

    for (int i = 1; i <= numberOfWeeks; i++){
      var querySnap = await FirebaseFirestore.instance.collection("units").doc(unitID).collection("weeks").where("weekNumber", isEqualTo: i).get();
      querySnap.docs.forEach((week) async {
        var studentSnap = await FirebaseFirestore.instance.collection("units").doc(unitID).collection("weeks").doc(week.id).collection("students").get();
        studentSnap.docs.forEach((studentFound) {
          var student = new Student(studentName: studentFound.get("studentName"), studentID: studentFound.get("studentID"), grade: studentFound.get("grade"));
          student.doc_id = studentFound.id;

          if (student.studentID == studentID){
            gradeTotal += gradeConverter(week.get("gradeScheme"), student);
            nowsii += 1.0;

            if (emailSummary.isEmpty){
              emailSummary.add("Summary report for ${student.studentName}\nWeek number, Grade Received, Grade Numeric Value");
            }


            emailSummary.add("Week $i, ${student.grade}, ${gradeConverter(week.get("gradeScheme"), student)}");

            if (gradeConverter(week.get("gradeScheme"), student) == 0.0){
              missedWeeks += 1;
            }
          }
        });

        if (i == numberOfWeeks){
          gradeAverage = (gradeTotal / nowsii).toStringAsFixed(2);
          information[0] = gradeAverage;

          attendancePercent = (((nowsii - missedWeeks) / nowsii) * 100).toStringAsFixed(0);
          information[1] = attendancePercent;

          print("Information Completed");
          loading = false;
          print(loading);
          notifyListeners();
        }
      });
    }
  }

  double gradeConverter(String gradeScheme, Student student){

    List<String> grades = [];
    grades.clear();
    int numberOfChkns = 0;
    double gradeValue = 0;
    String newScheme = gradeScheme;


    if (gradeScheme.startsWith("chk")){
      //then it's chkn
      numberOfChkns = int.parse(gradeScheme.substring(3).toString());
      newScheme = "${gradeScheme[0]}${gradeScheme[1]}${gradeScheme[2]}";
    }

    switch (newScheme){
      case "hd":
        grades = <String>['UG', 'NN', 'PP', 'CR', 'DN', 'HD'];
        break;
      case "a":
        grades = <String>['UG', 'F', 'D', 'C', 'B', 'A'];
        break;
      case "att":
        grades = <String>['Absent', 'Present'];
        break;
      case "num":
      //No need to do anything as it's already numeric
        break;
      case "chk":
        grades = <String>[];
        for (int i = 0; i < numberOfChkns + 1; i++){
          grades.add("Check $i");
        }
        break;
      default:
        print("Something went wrong");
        break;
    }

    if (gradeScheme != "num"){
      int indexOfGrade = grades.indexOf(student.grade);
      gradeValue = indexOfGrade * (100 / (grades.length -1 ));
    }
    else{
      gradeValue = double.parse(student.grade);
    }

    return gradeValue;
  }


}

