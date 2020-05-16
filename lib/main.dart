import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wifi speed',
      theme:ThemeData.dark(),
//      ThemeData(
//        backgroundColor: Colors.black,
//        primarySwatch: Colors.blue,
//        visualDensity: VisualDensity.adaptivePlatformDensity,),
      home: HomePage(),
    );
  }
}
