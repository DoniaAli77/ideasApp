import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'idea.dart';

class AddIdeaScreen extends StatefulWidget {
  @override
  _AddIdeaScreenState createState() => _AddIdeaScreenState();
}

class _AddIdeaScreenState extends State<AddIdeaScreen> {
  final titleValue = TextEditingController();
  final ideaValue = TextEditingController();
  var isLoading = false;
  List<Idea> _ideas = [];
  final ideasURL = Uri.parse(
      'https://lab5-ce32f-default-rtdb.firebaseio.com/IdeasFirebase.json'); // will be different in your case!!
//--------------------------------------------------------
  Future<void> addIdea(String t, String b) {
    return http
        .post(ideasURL, body: json.encode({'ideaTitle': t, 'ideaBody': b}))
        .then((response) {
      _ideas.add(Idea(
          id: json.decode(response.body)['name'], ideaTitle: t, ideaBody: b));
    }).catchError((err) {
      print("provider:" + err.toString());
      throw err;
    });
  }

  //---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
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
                  addIdea(
                    titleValue.text,
                    ideaValue.text,
                  ).catchError((err) {
                    return showDialog<Null>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('An error occurred!'),
                        content: Text(err.toString()),
                        actions: [
                          TextButton(
                            child: const Text('Okay'),
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
                icon: const Icon(Icons.check)),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Idea title'),
                      controller: titleValue,
                    ),
                    TextField(
                        decoration: const InputDecoration(labelText: 'Idea'),
                        controller: ideaValue),
                  ],
                ),
              ));
  }
}
