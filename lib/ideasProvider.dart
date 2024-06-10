import './idea.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IdeasProvider with ChangeNotifier {
  List<Idea> _ideas = [];
  final ideasURL = Uri.parse(
      'https://lab5-ce32f-default-rtdb.firebaseio.com/IdeasFirebase.json'); // will be different in your case!!
  Future<void> fetchIdeasFromServer() async {
    try {
      var response = await http.get(ideasURL);
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      _ideas.clear();
      fetchedData.forEach((key, value) {
        _ideas.add(Idea(
            id: key,
            ideaTitle: value['ideaTitle'],
            ideaBody: value['ideaBody']));
      });
      notifyListeners();
    } catch (err) {}
  }

  Future<void> addIdea(String t, String b) {
    return http
        .post(ideasURL, body: json.encode({'ideaTitle': t, 'ideaBody': b}))
        .then((response) {
      _ideas.add(Idea(
          id: json.decode(response.body)['name'], ideaTitle: t, ideaBody: b));
      notifyListeners();
    }).catchError((err) {
      print("provider:" + err.toString());
      throw err;
    });
  }

  List<Idea> get getAllIdeas {
    return _ideas;
  }

  Future<void> deleteIdea(String id_to_delete) async {
    var ideaToDeleteURL = Uri.parse(
        'https://lab5-ce32f-default-rtdb.firebaseio.com/IdeasFirebase/$id_to_delete.json');
    try {
      await http
          .delete(ideaToDeleteURL); // wait for the delete request to be done
      _ideas.removeWhere((element) {
        // when done, remove it locally.
        return element.id == id_to_delete;
      });// we can use removeAt(index) function
      notifyListeners(); // to update our list without the need to refresh
    } catch (err) {}
  }
}
