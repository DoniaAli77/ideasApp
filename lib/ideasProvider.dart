import './idea.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class IdeasProvider with ChangeNotifier {
  List<Idea> _ideas = [];

  Future<void> fetchIdeasFromServer(String token) async {
    var ideasURL = Uri.parse(
        'https://lab-6-6bb29-default-rtdb.firebaseio.com/IdeasDB.json?auth=$token');

    try {
      var response = await http.get(ideasURL);

      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      _ideas.clear();
      fetchedData.forEach((key, value) {
        _ideas.add(Idea(
            id: key,
            ideaTitle: value['ideaTitle'],
            ideaBody: value['ideaBody'],
            userId: value['userId']));
      });
      notifyListeners();
    } catch (err) {}
  }

  Future<void> addIdea(String t, String b, String id, String token) {
    var ideasURL = Uri.parse(
        'https://lab-6-6bb29-default-rtdb.firebaseio.com/IdeasDB.json?auth=$token');
    return http
        .post(ideasURL,
            body: json.encode({'ideaTitle': t, 'ideaBody': b, 'userId': id}))
        .then((response) {
      print("response after adding" + json.decode(response.body).toString());
      _ideas.add(Idea(
          id: json.decode(response.body)['name'],
          ideaTitle: t,
          ideaBody: b,
          userId: id));
      notifyListeners();
    }).catchError((err) {
      print("provider:" + err.toString());
      throw err;
    });
  }

  List<Idea> get getAllIdeas {
    return _ideas;
  }

  void deleteIdea(String id_to_delete, String token) async {
    var ideaToDeleteURL = Uri.parse(
        'https://lab-6-6bb29-default-rtdb.firebaseio.com/IdeasDB/$id_to_delete.json?auth=$token');
    try {
      await http
          .delete(ideaToDeleteURL); // wait for the delete request to be done

      _ideas.removeWhere((element) {
        // when done, remove it locally.
        return element.id == id_to_delete;
      });
      notifyListeners(); // to update our list without the need to refresh
    } catch (err) {}
  }

  Future<void> fetchMyIdeasFromServer(String token, String userId) async {
    var ideasURL = Uri.parse(
        'https://lab-6-6bb29-default-rtdb.firebaseio.com/IdeasDB.json?auth=$token&orderBy="userId"&equalTo="$userId"');
    try {
      var response = await http.get(ideasURL);

      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      _ideas.clear();
      fetchedData.forEach((key, value) {
        print("user: " + value['userId']);
        _ideas.add(Idea(
            id: key,
            ideaTitle: value['ideaTitle'],
            ideaBody: value['ideaBody'],
            userId: value['userId']));
      });
      notifyListeners();
    } catch (err) {

    }
  }
}
