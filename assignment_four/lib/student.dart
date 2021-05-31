import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Student {
  String studentName;
  String studentID;
  String doc_id = "";
  String grade;
  bool attended = false;//Not used anymore

  Student({required this.studentName, required this.studentID, required this.grade});
}


class StudentModel extends ChangeNotifier{
  final List<Student> listOfStudents = [];

  CollectionReference unitCollection = FirebaseFirestore.instance.collection("units");

  bool loading = false;
  int weekNumber = 0;
  String unitID = "";

  StudentModel(int weekNumber, String unitID){
    fetchWeek(weekNumber, unitID);

  }

  void fetchWeek(int weekNumber, String unitID) async{

    loading = true;
    notifyListeners();
    listOfStudents.clear();

    String weekDocument;
    //get the week information
    var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: weekNumber).get();
    querySnap.docs.forEach((doc){
      //I assume we have the week
      weekDocument = doc.id;
      fetchStudentList(weekDocument);
    });
  }

  void fetchStudentList(String weekDocument) async{
    var studentSnap = await unitCollection.doc(unitID).collection("weeks").doc(weekDocument).collection("students").orderBy("studentName").get();

    studentSnap.docs.forEach((stuFound) {
      var student = new Student(studentName: stuFound.get("studentName"), studentID: stuFound.get("studentID"), grade: stuFound.get("grade"));
      student.doc_id = stuFound.id;
      listOfStudents.add(student);
      print("Found student ${student}");
    });

    loading = false;
    notifyListeners();
  }
}