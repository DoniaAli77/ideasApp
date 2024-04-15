import 'dart:convert';
import 'package:http/http.dart' as http;

import 'idea.dart';
import 'package:flutter/material.dart';

class IdeasScreen extends StatefulWidget {
  @override
  _IdeasScreenState createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  List<Idea> _ideas = [];
  final ideasURL = Uri.parse(
      'https://lab5-ce32f-default-rtdb.firebaseio.com/IdeasFirebase.json'); // will be different in your case!!

  // --------------------------------------------
  Future<void> fetchIdeasFromServer() async {
    try {
      var response = await http.get(ideasURL);
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        _ideas.clear();
        fetchedData.forEach((key, value) {
          _ideas.add(Idea(
              id: key,
              ideaTitle: value['ideaTitle'],
              ideaBody: value['ideaBody']));
        });
      });
    } catch (err) {
      print(err);
    }
  }

  void deleteIdea(String id_to_delete) async {
    var ideaToDeleteURL = Uri.parse(
        'https://lab5-ce32f-default-rtdb.firebaseio.com/IdeasFirebase/$id_to_delete.json');
    try {
      await http
          .delete(ideaToDeleteURL); // wait for the delete request to be done
          setState(() {
             _ideas.removeWhere((element) {
        // when done, remove it locally.
        return element.id == id_to_delete;
      });
          });
     
    } catch (err) {
      print(err);
    }
  }

  // ------------------------------------------
  void initState() {
    fetchIdeasFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // fetchIdeasFromServer();
    return Scaffold(
        appBar: AppBar(
          title: Text('Ideas'),
          backgroundColor: Colors.deepOrange,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/AddIdeaRoute');
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => fetchIdeasFromServer(),
          child: ListView.builder(
              itemCount: _ideas.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: ValueKey(_ideas[index].id),
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
                  onDismissed: (dir) {
                    deleteIdea(_ideas[index].id);
                  },
                  child: ListTile(
                    title: Text(_ideas[index].ideaTitle),
                    subtitle: Text(_ideas[index].ideaBody),
                  ),
                );
              }),
        ));
  }
}
