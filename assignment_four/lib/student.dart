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
          print("List of students after adding one: ${listOfStudents.length}");
          //print("Found student ${student.studentName}");
        });


        loading = false;
        notifyListeners();
      }
    });
  }


  void update(String unitID, int weeknumber, Student updateGrade) async{
    loading = true;
    var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: weeknumber).get();
    querySnap.docs.forEach((doc) async {
      unitCollection.doc(unitID).collection("weeks").doc(doc.id).collection("students").doc(updateGrade.doc_id).set(updateGrade.toJson());

      //Update
      fetchWeek(weeknumber, unitID);
    });
  }

  void addStudent(String unitID, int weeknumber, int maxWeeks, Student newStudent) async{

    loading = true;
    for (int i = weeknumber; i <= maxWeeks; i++){
      var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: i).get();
      querySnap.docs.forEach((doc) async {
        var studentCollection = unitCollection.doc(unitID).collection("weeks").doc(doc.id).collection("students");
        await studentCollection.add(newStudent.toJson());
      });

      if (i == weeknumber){
        fetchWeek(weeknumber, unitID);
      }
    }
  }

  void deleteStudent(String unitID, int weekNumber, int maxWeeks, Student deletedStudent) async{

    loading = true;

    for (int i = weekNumber; i <= maxWeeks; i++){
      //Get the week document
      var querySnap = await unitCollection.doc(unitID).collection("weeks").where("weekNumber", isEqualTo: i).get();
      querySnap.docs.forEach((weekDoc) async {
          //Get each week's student information
        var studentSnap = await unitCollection.doc(unitID).collection("weeks").doc(weekDoc.id).collection("students").where("studentID", isEqualTo: deletedStudent.studentID).get();
        studentSnap.docs.forEach((studentToDelete) async{
          await unitCollection.doc(unitID).collection("weeks").doc(weekDoc.id).collection("students").doc(studentToDelete.id).delete();
        });
      });

      if (i == weekNumber){
        fetchWeek(weekNumber, unitID);
      }
    }
  }


}

class SingleStudent extends ChangeNotifier{


  CollectionReference unitCollection = FirebaseFirestore.instance.collection("units");



}

