import 'package:flutter/material.dart';

import './IdeasScreen.dart';
import './AddIdeaScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          title: 'Ideas App',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => IdeasScreenHook(),
            '/AddIdeaRoute': (ctx) => AddIdeaScreen(),
          });
    
  }
}
