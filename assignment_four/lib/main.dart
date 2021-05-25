import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ClassView.dart';

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
                create: (context) => null,
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

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));//https://api.flutter.dev/flutter/material/ElevatedButton-class.html

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
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  scrollDirection: Axis.vertical,
                    itemBuilder: (_, index) {
                      var unit = "test";
                      return ListTile(
                        title:Text("Unit name here"),

                        subtitle: Text("Number of weeks: N"),
                        trailing: ElevatedButton(
                          style: style,
                          onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) { return ClassView(); }));
                          }, // ADD MOVEMENT Navigator.push(context, MaterialPageRoute(builder: (context) { return MovieDetails(id:index); }));
                          child: const Text('Enter Unit'),
                        ),

                      );
                    },
                    itemCount:1
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
