import 'apointmentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authProvider.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  __AppointmentsScreenState createState() => __AppointmentsScreenState();
}

class __AppointmentsScreenState extends State<AppointmentsScreen> {
  void initState() {
    super.initState();
    var myProvider = Provider.of<AppointmentsProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    myProvider.fetchAppointmentsFromServer(authProvider.token);
  }

  @override
  Widget build(BuildContext context) {
    // accessing the provider to grab data
    final appointmentsProvider =
        Provider.of<AppointmentsProvider>(context, listen: true);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    final appointemnts = appointmentsProvider.getAllAppointments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Appointemnts'),
          backgroundColor: Colors.deepOrange,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/AddAppointmentRoute');
                },
                icon: Icon(Icons.add)),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/AddAppointmentRoute');
              },
              child: Text('Add Appointment'),
            ),
            IconButton(
                color: Colors.white,
                onPressed: () {
                  authProvider.logout();

                  Navigator.of(context).pushReplacementNamed('/');
                },
                icon: Icon(Icons.logout_rounded))
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed('/AddAppointmentRoute');
          },
          label: Center(
            child: Text('Add Appointment'),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => appointmentsProvider
              .fetchAppointmentsFromServer(authProvider.token),
          child: ListView.builder(
              itemCount: appointemnts.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: ValueKey(appointemnts[index].id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (dir) async {
                    await appointmentsProvider.deleteAppointment(
                        appointemnts[index].id, authProvider.token);
                  },
                  child: ListTile(
                      title: Text(appointemnts[index].appointmentName +
                          " By " +
                          appointemnts[index].userId),
                      subtitle:
                          Text(appointemnts[index].appointmentDate.toString()),
                      trailing: IconButton(
                          onPressed: () {
                            appointmentsProvider
                                .deleteAppointment(
                                    appointemnts[index].id, authProvider.token)
                                .catchError((err) {
                              return showDialog<Null>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('An error occurred!'),
                                  content: Text(err.toString()),
                                  actions: [
                                    TextButton(
                                      child: Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).then((_) {
                              return showDialog<Null>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('deleted successfully'),
                                  content: Text("done"),
                                  actions: [
                                    TextButton(
                                      child: Text('Okay'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                          icon: Icon(Icons.delete))),
                );
              }),
        ));
  }
}
