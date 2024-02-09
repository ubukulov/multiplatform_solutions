import 'package:flutter/material.dart';
import 'package:multiplatform_solutions/users_grid_view.dart';
import 'package:multiplatform_solutions/users_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: UsersGridView(),
        ),
      )
    );
  }
}

