import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'apointmentProvider.dart';
import 'authProvider.dart';

class AddAppointmentScreen extends StatefulWidget {
  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final appointmentName = TextEditingController();
  final appointmentDate = TextEditingController();
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    // accessing the provider to grab data
    final appointmentProvider =
        Provider.of<AppointmentsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    print(authProvider.userId);
    print(authProvider.token);
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new Appointment"),
          backgroundColor: Colors.deepOrange,
          leading: IconButton(
              onPressed: () {
                print(appointmentName.text);
                if (appointmentName.text != "" && appointmentDate.text != "") {
                  showDialog<Null>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('data not saved'),
                      content:
                          Text("do you want to save or proceed without saving"),
                      actions: [
                        TextButton(
                          child: Text('save'),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            print(authProvider.userId);
                            print(authProvider.token);
                            appointmentProvider
                                .addAppointment(
                                    appointmentName.text,
                                    appointmentDate.text,
                                    authProvider.userId,
                                    authProvider.token)
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
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(ctx);
                              Navigator.pop(context);
                            });
                            // even if our future<void> returns void, the anonymous function
                            //still requires this as a format so we put an underscore as convention
                          },
                        ),
                        TextButton(
                          child: Text('proceed without saving'),
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(Icons.arrow_back)),
          actions: [
            // IconButton(
            //     onPressed: () {
            //      Same as above Icon button code
            //     },
            //     icon: Icon(Icons.arrow_back)),
            IconButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  appointmentProvider
                      .addAppointment(
                          appointmentName.text,
                          appointmentDate.text,
                          authProvider.userId,
                          authProvider.token)
                      .catchError((err) {
                    print(appointmentName.text);
                    print(appointmentDate.text);
                    print(authProvider.userId);
                    print(authProvider.token);

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
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  });
                  // even if our future<void> returns void, the anonymous function
                  //still requires this as a format so we put an underscore as convention
                },
                icon: Icon(Icons.check)),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Appointment name'),
                      controller: appointmentName,
                    ),
                    TextField(
                        decoration: InputDecoration(
                            labelText: 'Appointment Date yyyy-m-dd'),
                        controller: appointmentDate),
                  ],
                ),
              ));
  }
}
