import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './IdeasScreen.dart';
import './AddIdeaScreen.dart';
import './ideasProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => IdeasProvider(),
      child: MaterialApp(
          title: 'Ideas App',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => IdeasScreen(),
            '/AddIdeaRoute': (ctx) => AddIdeaScreen(),
          }),
    );
  }
}
