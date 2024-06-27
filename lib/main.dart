import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './appointmentsScreen.dart';
import './addAppointmentScreen.dart';
import './apointmentProvider.dart';
import 'loginSignUpScreen.dart';
import 'authProvider.dart';

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
        ChangeNotifierProvider(create: (ctx) => AppointmentsProvider()),
      ],
      child: MaterialApp(
          title: 'Appointments App',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => LoginScreen(),
            '/AppointmentsRoute': (ctx) => AppointmentsScreen(),
            '/AddAppointmentRoute': (ctx) => AddAppointmentScreen(),
          }),
    );
  }
}
