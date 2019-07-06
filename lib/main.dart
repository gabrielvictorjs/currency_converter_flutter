import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // disable debug banner
      debugShowCheckedModeBanner: false,
      // Theming app
      theme: ThemeData(
        primaryColor: Colors.white,
        hintColor: Colors.amber
      ),
      // define home screen
      home: HomeScreen(),
    );
  }
}
