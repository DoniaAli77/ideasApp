import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ideasProvider.dart';

class AddIdeaScreen extends StatefulWidget {
  @override
  _AddIdeaScreenState createState() => _AddIdeaScreenState();
}

class _AddIdeaScreenState extends State<AddIdeaScreen> {
  final titleValue = TextEditingController();
  final ideaValue = TextEditingController();
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    // accessing the provider to grab data
    final ideasProvider = Provider.of<IdeasProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new idea"),
          backgroundColor: Colors.deepOrange,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  ideasProvider
                      .addIdea(
                    titleValue.text,
                    ideaValue.text,
                  )
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
                      decoration: InputDecoration(labelText: 'Idea title'),
                      controller: titleValue,
                    ),
                    TextField(
                        decoration: InputDecoration(labelText: 'Idea'),
                        controller: ideaValue),
                  ],
                ),
              ));
  }
}
