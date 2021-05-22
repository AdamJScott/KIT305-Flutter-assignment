import 'package:assignment_four/StudentDetailView.dart';
import 'package:assignment_four/WeekReportView.dart';
import 'package:flutter/material.dart';

class ClassView extends StatefulWidget {
  //const ClassView({Key key}) : super(key: key);

  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  late TextEditingController searchFieldController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //Variables
  String dropDownValue = "UG";



  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    //Style definitions
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));//https://api.flutter.dev/flutter/material/ElevatedButton-class.html

//TODO https://rsainik80.medium.com/dropdown-button-inside-listview-builder-in-flutter-e2eb74fb45b4
    //TODO READ THIS
    //! DO IT


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),

        ),
        title: Text("TODO UNITCODE"),//TODO UNIT CODE
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
                    Expanded(
                      child: Container(
                        height: 350,
                        child: ListView.builder(
                            padding: EdgeInsets.all(8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (_, index) {
                              return ListTile(
                                title:Text("Student Name TODO"),
                                subtitle: Text("Student ID TODO"),
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
                            itemCount:3
                        ),
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
}

