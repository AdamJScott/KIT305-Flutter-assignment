import 'package:flutter/material.dart';

class StudentDetailView extends StatefulWidget {
  //const StudentDetailView({Key key}) : super(key: key);

  @override
  _StudentDetailViewState createState() => _StudentDetailViewState();
}

class _StudentDetailViewState extends State<StudentDetailView> {
  late TextEditingController studentFieldController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double fontSizeVar = 25;

  @override
  void initState() {
    super.initState();
    studentFieldController = TextEditingController();

    studentFieldController.text = "STUDENT NAME HERE TODO";//TODO
  }

  @override
  void dispose() {
    studentFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Student Name TODO"),//TODO change to variable
        centerTitle: true,
      ),
      key: scaffoldKey,
      body: SafeArea(
        child: Align(
          alignment: Alignment(0,0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:10),
                ],
              ),//SPACER
              Align(
                alignment: Alignment(0,0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Image(
                      image: NetworkImage(
                        'https://media.tenor.com/images/f51e8568774ddd46d40c3686069e12b3/tenor.gif',
                      ),//TODO CHANGE TO DATABASE
                      width: 150,
                      height: 150,
                    ),

                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print('Take photo pressed ...'); //TODO
                          },
                          child: const Text("Take photo"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeVar,
                            ),
                          ),
                        ),//TAKE PHOTO
                        ElevatedButton(
                          onPressed: () {
                            print('Choose photo pressed ...'); //TODO
                          },
                          child: const Text("Choose photo"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeVar,
                            ),
                          ),
                        ),//CHOOSE PHOTO
                        ElevatedButton(
                          onPressed: () {
                            print('Remove Photo pressed ...'); //TODO
                          },
                          child: const Text("Remove photo"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeVar,
                            ),
                          ),
                        ),//REMOVE PHOTO
                      ],
                    ),
                  ],
                )
              ),//IMAGE AND BUTTONS
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      width: 250,
                      padding: EdgeInsets.fromLTRB(32,16,32,16),
                      child: TextField(
                        onSubmitted: (value) {
                          print("Submitted with $value");
                        },
                        controller: studentFieldController,
                        obscureText: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSizeVar,
                        ),
                        decoration: const InputDecoration(

                          border: OutlineInputBorder(),
                          labelText: 'Change student name',//TODO maybe set this to current name?
                          hintText: "Enter in student's new name",
                          ),
                       ),
                    ),
                  )
                ],
              ),//STUDENT NAME ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:8),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "Student ID: ",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),
                  ),
                  Text("XXXXXX TODO",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),//TODO Change to variable
                ],
              ),//STUDENT ID ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Grade average: ",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),
                  Text("XXXXXX TODO",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),//TODO Change to variable
                ],
              ),//GRADE AVERAGE ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Attendance %: ",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),
                  Text("XXXXXX TODO",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),//TODO Change to variable
                ],
              ),//ATTENDANCE ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Last grade: ",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),
                  Text("XXXXXX TODO",
                    style: TextStyle(
                      fontSize: fontSizeVar,
                    ),),//TODO Change to variable
                ],
              ),//LAST GRADE ROW
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height:16),
                ],
              ),//SPACER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print('Email summary pressed ...'); //TODO
                    },
                    child: const Text("Email summary"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeVar,
                      ),
                    ),
                  ),//EMAIL SUMMARY BUTTON
                ],
              ),//EMAIL SUMMARY


            ],
          )
        ),
      ),
    );
  }
}
