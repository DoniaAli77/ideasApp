import 'ideasProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IdeasScreen extends StatefulWidget {
  @override
  _IdeasScreenState createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  void initState() {
    var myProvider =
        Provider.of<IdeasProvider>(context, listen: false); // should be
//false to be called from initstate
    myProvider.fetchIdeasFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // accessing the provider to grab data
    final ideasProvider = Provider.of<IdeasProvider>(context,
        listen: true); // listening is true by
//default
    // the provider contains the data + additional methods. if we need only the
//data, we must call the getter
    final ideas = ideasProvider.getAllIdeas; // calling the getter
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
          onRefresh: ideasProvider.fetchIdeasFromServer,
          child: ListView.builder(
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
              }),
        ));
  }
}
