import './idea.dart';
import 'ideasProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddIdeaScreen extends StatelessWidget {
  final titleValue = TextEditingController();
  final ideaValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ideasProvider = Provider.of<IdeasProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new idea"),
          backgroundColor: Colors.deepOrange,
          actions: [
            IconButton(
                onPressed: () {
                  ideasProvider.addIdea(
                    DateTime.now().toString(), // dummy ID
                    titleValue.text,
                    ideaValue.text,
                  );
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.check)),
          ],
        ),
        body: Container(
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
