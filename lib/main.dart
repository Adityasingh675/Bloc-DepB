import 'dart:ui';

import 'package:bloc_departure/providers/septa_provider.dart';
import 'package:bloc_departure/screens/departures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SeptaProvider(),
      child: MaterialApp(
        title: 'Train Time-Table',
        theme: ThemeData(
          accentColor: Colors.deepOrangeAccent,
          brightness: Brightness.dark,
          textTheme: TextTheme(
            bodyText2: GoogleFonts.orbitron(
                textStyle: TextStyle(
              color: Colors.cyan,
              fontSize: 18.0,
            )),
            bodyText1: GoogleFonts.openSans(
                textStyle:
                    TextStyle(color: Colors.deepOrangeAccent, fontSize: 12.0)),
            headline6: GoogleFonts.orbitron(
                textStyle: TextStyle(color: Colors.cyan, fontSize: 25.0)),
          ),
        ),
        home: Departures(),
      ),
    );
  }
}
