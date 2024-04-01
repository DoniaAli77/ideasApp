import 'ideasProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IdeasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// accessing the provider to grab data. Listening is true by default
    final ideasProvider = Provider.of<IdeasProvider>(context);

// the provider contains the data + additional methods. if we need only the data, we
//must call the getter we created.

    final ideas = ideasProvider.getAllIdeas;

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
        body: ListView.builder(
            itemCount: ideas.length,
            itemBuilder: (ctx, index) {
              return Dismissible(
                key: ValueKey(ideas[index].id),
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
                  ideasProvider.deleteIdea(ideas[index].id);
                },
                child: ListTile(
                  title: Text(ideas[index].ideaTitle),
                  subtitle: Text(ideas[index].ideaBody),
                ),
              );
            }));
  }
}
