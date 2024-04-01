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
              return ListTile(
                title: Text(ideas[index].ideaTitle),
                subtitle: Text(ideas[index].ideaBody),
                trailing: IconButton(
                  onPressed: () {
                    ideasProvider.deleteIdea(ideas[index].id);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              );
            }));
  }
}
