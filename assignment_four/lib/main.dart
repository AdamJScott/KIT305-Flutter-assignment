import 'package:assignment_four/unit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';


import 'ClassView.dart';


/*
TODO WITH THE PHOTOS, MAKE SURE YOU CHANGE IT TO THE FIREBASE INTERACTION RATHER THAN DIRECTLY TO THE STORAGE

  TODO
    1. Create UNIT model to generate each list item and button                  ✔️
    2. Create link from unit button to class view, passing the relevant data in ✔️
    3. Create WEEK model to generate student list items                         ✔
      3.a. then add marking single scheme (HD / A)                              ✔
      3.b. add swapping between weeks                                           ✔
      3.c. then generation of each scheme *NTH*                                 ✔
    4. Create movement from student name to student detail page
      4.a. Get name ✔, student ID ✔, then get photo ✔                          ✔
    5. Back in class view
      5.a. Add student                                                          ✔
      5.b. Delete student                                                       ✔
      5.c. Grade student                                                        ✔
      5.d. Change scheme functionality *NTH*                                    ✔
      5.e. Test that works *NTH*                                                ✔
      5.f. Generate summary for unit *NTH*                                          nth (07/06) due 08/06
      5.g. Sort list of students                                                ✔
      5.g. Search through students either by ID or Name   nth today (03/06)
      5.h. Email week report                                                    ✔
    6. Student detail view
      6.a. Take new photo                                                       ✔            CHANGE TO THE FIREBASE REFERENCE SO WHEN NAME CHANGES SAME PIC IS USED
      6.b. Remove photo                                                         ✔
      6.c. Choose photo                                                         ✔
      6.d. Change name and save                                                 ✔
      6.e. Generate student unit information summary                               nth (07/06) due 08/06
    7. Week report view
      7.a. Generate grade average                                               ✔
      7.b. Generate attendance percentage                                       ✔
      7.c. Populate the report summary view from the week it entered from       ✔
    8. Bug fixes, report                                                            due 09/06
      8.a. Spam clicking through the weeks will make the students populate double / triple / n up.

    9. Create a logger for all adding, grading, removing options so you can see what lindsay does



 */


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            //return FullScreenText(text:"Something went wrong");
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done)
          {
            return ChangeNotifierProvider(
                create: (context) => UnitModel(),
                child: MaterialApp(
                  title: 'Tutor Marks',
                  theme: ThemeData(
                  // This is the theme of the application.
                    primarySwatch: Colors.blue,
                  ),
                 home: MyHomePage(title: 'Tutor Marks'),
                )
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<MyHomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final units = new UnitModel();

  @override
  Widget build(BuildContext context) {
        return Consumer<UnitModel>(
            builder:buildScaffold
        );
  }

  Scaffold buildScaffold(BuildContext context, UnitModel unitModel, _) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(
        fontSize: 20)); //https://api.flutter.dev/flutter/material/ElevatedButton-class.html
    return Scaffold(
    appBar: AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(widget.title),
    ),
    key: scaffoldKey,
    body: SafeArea(
      child: Align(
        alignment: Alignment(0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Please select a unit to enter', style: TextStyle(fontSize: 20),
            ),
            if (units.loading) CircularProgressIndicator() else
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var unit = unitModel.units[index];
                    return ListTile(
                      title: Text(unit.unitname),
                      subtitle: Text(
                          "Number of weeks: ${unit.numberOfWeeks}"),
                      trailing: ElevatedButton(
                        style: style,
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return ClassView(unitname: unit.unitname, unitID: unit.id, numberOfWeeks: unit.numberOfWeeks);
                          }));
                        },
                        // ADD MOVEMENT Navigator.push(context, MaterialPageRoute(builder: (context) { return MovieDetails(id:index); }));
                        child: const Text('Enter Unit'),
                      ),

                    );
                  },
                  itemCount: unitModel.units.length
              ),
            )
          ],
        ),
      ),
    ),
  );
  }
}
