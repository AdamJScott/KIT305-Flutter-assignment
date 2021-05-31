import 'dart:developer';

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

  StudentModel(int weekNumber, String unitID){
    fetchWeek(weekNumber, unitID);
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

        var studentSnap = await unitCollection.doc(unitID).collection("weeks").doc(doc.id).collection("students").orderBy("studentName").get();
        studentSnap.docs.forEach((stuFound) {
          var student = new Student(studentName: stuFound.get("studentName"), studentID: stuFound.get("studentID"), grade: stuFound.get("grade"));
          student.doc_id = stuFound.id;
          listOfStudents.add(student);
          print("List of students after adding one: ${listOfStudents.length}");
          //print("Found student ${student.studentName}");
        });


        loading = false;
        notifyListeners();
      }
    });


  }

}