import 'package:flutter/material.dart';


class Unit {
  String id;
  int numberOfWeeks;
  String unitname;


  Unit({required this.id, required this.numberOfWeeks, required this.unitname});


  //Able to convert from firestore to unit object
  Unit.fromJson(Map<String,dynamic> json)
  :id = json['id'], numberOfWeeks = json['numberOfWeeks'], unitname = json['unitname'];

  //Able to convert from unit object to firestore
  Map<String, dynamic> toJson() =>{
    'id': id, 'numberOfWeeks': numberOfWeeks, 'unitname': unitname
  };



}

class UnitModel extends ChangeNotifier {
  final List<Unit> units = [];

  UnitModel(){
    //TODO call database here
  }





}



