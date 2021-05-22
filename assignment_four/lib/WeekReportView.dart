import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekReportView extends StatefulWidget {
  //const WeekReportView({Key key}) : super(key: key);

  @override
  _WeekReportViewState createState() => _WeekReportViewState();
}

class _WeekReportViewState extends State<WeekReportView> {

  double fontSizeVar = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("TODO WEEK NUMBER"),//TODO UNIT CODE
        centerTitle: true,
      ),

      body: SafeArea(
        child: Align(
          alignment: Alignment(0,0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Report for Week N",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSizeVar * 1.5,
                          ),
                      ),//TODO CHANGE TO VARIABLE
                    ],
                  ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Grade Average:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSizeVar,
                        ),
                      ),

                      Text("XXXXX TODO",//TODO TO VARIABLE
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSizeVar,
                        ),
                      ),
                    ],
                  ),
                ),//GRADE AVERAGE
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Attendance %:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSizeVar,
                        ),
                      ),

                      Text("XXXXX TODO",//TODO TO VARIABLE
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSizeVar,
                        ),
                      ),
                    ],
                  ),
                ),//ATTENDANCE
                Container(
                  padding: EdgeInsets.all(16),
                  height: 425,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: new BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 1.0, color: Colors.black),
                              left: BorderSide(width: 1.0, color: Colors.black),
                              right: BorderSide(width: 1.0, color: Colors.black),
                              bottom: BorderSide(width: 1.0, color: Colors.black),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                              padding: EdgeInsets.all(8),
                              scrollDirection: Axis.vertical,

                              itemBuilder: (_, index) {
                                return Container(
                                  child: ListTile(
                                    title:Text("STUDENT, STUDENT ID, GRADE",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: new BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1.0, color: Colors.black),
                                      )
                                  ),
                                );
                              },
                              itemCount:15

                          ),
                        ),

                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: fontSizeVar,
                          ),
                      ),
                      onPressed: () {
                        print('Email Report pressed ...'); //TODO
                      }, // ADD MOVEMENT Navigator.push(context, MaterialPageRoute(builder: (context) { return MovieDetails(id:index); }));
                      child: const Text('Email report'),
                    ),
                  ],
                )
              ],
            )
          )
        ),
      )
    );
  }
}
