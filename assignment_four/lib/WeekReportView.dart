
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';


class WeekReportView extends StatefulWidget {

  final int weekNumber;
  final String unit;

  final double attendance;
  final String gradeAverage;
  final List<String> studentReport;

  WeekReportView({Key? key, required this.unit, required this.weekNumber, required this.studentReport, required this.attendance, required this.gradeAverage }) : super(key: key);

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
        title: Text("Week report for ${widget.unit}"),//TODO UNIT CODE
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
                      Text("Report for Week ${widget.weekNumber}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSizeVar * 1.5,
                          ),
                      ),
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

                      Text("${widget.gradeAverage}",//TODO TO VARIABLE
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

                      Text("${widget.attendance.toStringAsFixed(2)}%",//TODO TO VARIABLE
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

                              itemBuilder: (context, index) {
                                var student = widget.studentReport[index];
                                return Container(
                                  child: ListTile(
                                    title:Text(student,
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
                              itemCount: widget.studentReport.length
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
                      onPressed: () async {
                        launchMailto() async {
                          final mailtoLink = Mailto(
                            to: ["enterEmailHere@email.com"],
                            cc: [""],
                            subject: "Week report for week ${widget
                                .weekNumber}",
                            body: widget.studentReport.join(""),
                          );

                          await launch('${mailtoLink}');
                        }

                        launchMailto();
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
