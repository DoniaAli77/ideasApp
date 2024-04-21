import 'package:flutter/material.dart';
import 'package:ideas_app/authProvider.dart';
import 'package:ideas_app/ideasProvider.dart';
import 'package:provider/provider.dart';

import './IdeasScreen.dart';
import './AddIdeaScreen.dart';
import 'loginSignUpScreen.dart';
void main() { 
  runApp(MyApp()); 
} 
 
class MyApp extends StatelessWidget { 
  // This widget is the root of your application. 
  @override 
  Widget build(BuildContext context) { 
    return MultiProvider( 
      providers: [ 
        ChangeNotifierProvider(create: (ctx) => AuthProvider()), 
        
        ChangeNotifierProvider(create: (ctx) => IdeasProvider()), 
      ], 
      child: MaterialApp( 
          title: 'Flutter Demo', 
          theme: ThemeData( 
            primarySwatch: Colors.deepOrange, 
          ), 
          initialRoute: '/', 
          routes: { 
            '/': (ctx) => LoginScreen(), 
            '/IdeasRoute': (ctx) => IdeasScreen(), 
            '/AddIdeaRoute': (ctx) => AddIdeaScreen(), 
          }), 
    ); 
  } 
} 
 