import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'authProvider.dart';
import 'ideasProvider.dart'; 
 
class IdeasScreen extends StatefulWidget { 
  @override 
  _IdeasScreenState createState() => _IdeasScreenState(); 
} 
 
class _IdeasScreenState extends State<IdeasScreen> { 
 
void initState(){ 
 var myProvider= Provider.of<IdeasProvider>(context,listen: false);  
 var authProvider= Provider.of<AuthProvider>(context,listen: false); 
 myProvider.fetchIdeasFromServer(authProvider.token); 
 //myProvider.fetchMyIdeasFromServer(authProvider.token, authProvider.userId); 
  super.initState(); 
} 
 
  @override 
  Widget build(BuildContext context) { 
    // accessing the provider to grab data 
    final ideasProvider = 
        Provider.of<IdeasProvider>(context, listen: true); // listening is true by default 
var authProvider= Provider.of<AuthProvider>(context,listen: true); 
     
    final ideas = ideasProvider.getAllIdeas; // calling the getter
     return Scaffold( 
        appBar: AppBar(
          backgroundColor: Colors.deepPurple, 
          title: Text('Ideas',style: TextStyle(color: Colors.white),), 
          actions: [ 
            IconButton( 
              color: Colors.white,
                onPressed: () { 
                  Navigator.of(context).pushNamed('/AddIdeaRoute'); 
                }, 
                icon: Icon(Icons.add)), 
                IconButton(
                   color: Colors.white,
                  onPressed: () 
                {authProvider.logout(); 
                 
                Navigator.of(context).pushReplacementNamed('/'); },  
                icon: Icon(Icons.logout_rounded)) 
          ], 
        ), 
        body: RefreshIndicator( 
          //onRefresh: () => ideasProvider.fetchMyIdeasFromServer(authProvider.token, authProvider.userId), 
          onRefresh: () => ideasProvider.fetchIdeasFromServer(authProvider.token), 
 
          //onRefresh:; 
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
                    ideasProvider.deleteIdea(ideas[index].id, authProvider.token); 
                  }, 
                  child: ListTile( 
                     
                    title: Text(ideas[index].ideaTitle +" By "+ 
ideas[index].userId), 
                    subtitle: Text(ideas[index].ideaBody),  ), 
                ); 
              }), 
        )); 
  } 
} 

