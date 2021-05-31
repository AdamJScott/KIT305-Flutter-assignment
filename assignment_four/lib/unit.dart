import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Unit {
  String id;
  int numberOfWeeks;
  String unitname;


  Unit({required this.id, required this.numberOfWeeks, required this.unitname});


  //Able to convert from firestore to unit object
  Unit.fromJson(QueryDocumentSnapshot<Object?> json)
  :
        id = json['id'],
        numberOfWeeks = json['numberOfWeeks'],
        unitname = json['unitname'];

  //Able to convert from unit object to firestore
  Map<String, dynamic> toJson() =>{
    'id': id, 'numberOfWeeks': numberOfWeeks, 'unitname': unitname
  };


}

class UnitModel extends ChangeNotifier {
  final List<Unit> units = [];

  CollectionReference unitCollection = FirebaseFirestore.instance.collection("units");

  bool loading = false;

  UnitModel(){
    //TODO call database here
    fetchUnits();
  }


  void fetchUnits() async{
    loading = true;
    notifyListeners();
    units.clear();

    var querySnap = await unitCollection.orderBy("unitname").get();

    querySnap.docs.forEach((doc){
      //doc.data wouldn't work
      //var unit = Unit.fromJson(doc.data());
      var unit = new Unit(id: doc.id, numberOfWeeks: doc.get("numberOfWeeks"), unitname: doc.get("unitname"));

      //var unit = Unit(unitname: doc.get("title"), id: doc.get("id"), numberOfWeeks: doc.get("numberOfWeeks"));
      units.add(unit);
      print(unit);
    });

    loading = false;
    notifyListeners();
  }
}



