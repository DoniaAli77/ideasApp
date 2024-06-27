import './appointment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentsProvider with ChangeNotifier {
  List<Appointment> _Appointments = [];
  Future<void> fetchAppointmentsFromServer(String token) async {
    try {
      final AppointmentsURL = Uri.parse(
          'https://lab-6-6bb29-default-rtdb.firebaseio.com/AppointmentsFirebase.json?auth=$token');
      var response = await http.get(AppointmentsURL);
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      _Appointments.clear();
      fetchedData.forEach((key, value) {
        _Appointments.add(Appointment(
            id: key,
            appointmentName: value['appointmentName'],
            appointmentDate: DateTime.parse(
              value['appointmentDate'],
            ),
            userId: value['userId']));
      });

      print(response);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addAppointment(String t, String b, String id, String token) {
    final AppointmentsURL = Uri.parse(
        'https://lab-6-6bb29-default-rtdb.firebaseio.com/AppointmentsFirebase.json?auth=$token');
    return http
        .post(AppointmentsURL,
            body: json.encode({
              'appointmentName': t,
              'appointmentDate': b.toString(),
              'userId': id
            }))
        .then((response) {
      _Appointments.add(Appointment(
          id: json.decode(response.body)['name'],
          appointmentName: t,
          appointmentDate: DateTime.parse(b),
          userId: id));
      notifyListeners();
    }).catchError((err) {
      print("provider:" + err.toString());
      throw err;
    });
  }

  List<Appointment> get getAllAppointments {
    return _Appointments;
  }

  Future<void> deleteAppointment(String id_to_delete, String token) async {
    var AppointmentToDeleteURL = Uri.parse(
        'https://lab-6-6bb29-default-rtdb.firebaseio.com/AppointmentsFirebase/$id_to_delete.json?auth=$token');
    try {
      await http.delete(AppointmentToDeleteURL);
      _Appointments.removeWhere((element) {
        return element.id == id_to_delete;
      });
      notifyListeners(); // to update our list without the need to refresh
    } catch (err) {
      throw err;
    }
  }
}
