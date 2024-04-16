import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
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

//-------------------Hooks version------------------------------
class IdeasScreenHook extends HookWidget {
  final ideasURL = Uri.parse(
      'https://lab5-ce32f-default-rtdb.firebaseio.com/IdeasFirebase.json'); // Update with your URL

  Future<void> fetchIdeasFromServer( _ideas) async {
    try {
      var response = await http.get(ideasURL);
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;

      _ideas.value.clear();
      fetchedData.forEach((key, value) {
        _ideas.value.add(Idea(
          id: key,
          ideaTitle: value['ideaTitle'],
          ideaBody: value['ideaBody'],
        ));
print(_ideas.value);
      });

    } catch (err) {
      print(err);
    }
  }

  Future<void> deleteIdea(String id_to_delete, List<Idea> _ideas) async {
    var ideaToDeleteURL = Uri.parse(
        'https://lab5-ce32f-default-rtdb.firebaseio.com/IdeasFirebase/$id_to_delete.json');
    try {
      await http.delete(ideaToDeleteURL); // Wait for the delete request to complete
      _ideas.removeWhere((element) => element.id == id_to_delete);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use hooks to manage state
    final _ideas = useState<List<Idea>>([]);
    // Fetch ideas from server on initial load
    useEffect(() {
        // Log when the effect runs
        print("useEffect is running");

        // Call fetchIdeasFromServer and check for errors
        fetchIdeasFromServer(_ideas).then((_) {
            print("Ideas fetched successfully:   ");
            print(_ideas.value);

        }).catchError((err) {
            print("Error fetching ideas: $err");
        });

        // No cleanup function needed, return null
        return null;
    }, []); // Empty dependencies array means it only runs once

    return Scaffold(
      appBar: AppBar(
        title: Text('Ideas'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/AddIdeaRoute');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchIdeasFromServer(_ideas.value),
        child: ListView.builder(
          itemCount: _ideas.value.length,
          itemBuilder: (ctx, index) {
            return Dismissible(
              key: ValueKey(_ideas.value[index].id),
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
              onDismissed: (dir) => deleteIdea(_ideas.value[index].id, _ideas.value),
              child: ListTile(
                title: Text(_ideas.value[index].ideaTitle),
                subtitle: Text(_ideas.value[index].ideaBody),
              ),
            );
          },
        ),
      ),
    );
  }
}
