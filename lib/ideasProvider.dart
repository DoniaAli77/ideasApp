import './idea.dart';
import 'package:flutter/material.dart';

class IdeasProvider with ChangeNotifier {
  List<Idea> _ideas = [];
  void addIdea(String i, String t, String b) {
    _ideas.add(Idea(id: i, ideaTitle: t, ideaBody: b));
// something has changed in our list to we must notify the listeners.
    notifyListeners();
  }

  List<Idea> get getAllIdeas {
    return _ideas;
  }

  void deleteIdea(String id_to_delete) {
    _ideas.removeWhere((element) {
      return element.id == id_to_delete;
    });
    notifyListeners();
  }
}
