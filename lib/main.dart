import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          //this colorScheme is used throughout the page
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void  getNext(){
    current =WordPair.random();
    notifyListeners();
  }
//empty list to store favorite names
  var favourites =<WordPair>[];

//condition on favorite icon 
  void toggleFavourite(){
    if(favourites.contains(current)){
      favourites.remove(current);
    }
    else{
      favourites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex =0;
  @override
  Widget build(BuildContext context) {
    Widget page; //contitions for selection of page
    switch(selectedIndex){
      case 0:
      page=GeneratorPage();
      break;
      case 1:
      page=FavouritesPage();
      break;
      default:
      throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder( //layoutbuilder will make the page responsive
      builder: (context,constraints) {
        return Scaffold(
          body: Row(children: [
            //NavigationRail will create a sidebar jusr like a drawer section
               SafeArea(child: NavigationRail(
                extended: constraints.maxWidth >= 600, //this will show the labels only when homepge has a width of 600 pixels  
                destinations: [
                  NavigationRailDestination(
                    icon:
                     Icon(Icons.home),
                     label: Text('Home'),
                     ),
                     NavigationRailDestination(icon: Icon(Icons.favorite),
                      label: Text('Favorites'),),
                ],
                //selects index of page
                selectedIndex: selectedIndex, 
                onDestinationSelected: (value){
                  setState(() {
                    selectedIndex=value;
                  });
                },
              ),
                   
              ),
            //it displays the rest of pages based on the selected index 
             Expanded(child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,     //it displays the rest of pages based on the selected index 
            ),)
          ],
          ),
        );
      }
    );
  }
  }

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair=appState.current;

    IconData icon;
    if(appState.favourites.contains(pair)){
      icon=Icons.favorite;
    }
    else{
      icon=Icons.favorite_border;
    }


    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            BigCard(pair: pair),
            SizedBox(height: 20,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: (){
                  appState.toggleFavourite();
                }, 
                icon: Icon(icon),
                label: Text('Like'),
                ),
                SizedBox(width: 10,),
                 ElevatedButton(
                  onPressed: (){
                  appState.getNext();
                }, 
                child: Text('Next'),
                ),
              ],
            )
          ],
        ),
      );
    
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    final style =theme.textTheme.displayMedium! .copyWith(
      color: theme.colorScheme.onPrimary,);
    return Card(
      color:theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase,style: style,semanticsLabel: "${pair.first} ${pair.second}",),
      ),
    );
  }
}

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
     var appState = context.watch<MyAppState>();
     var fav=appState.favourites;

     if(fav.isEmpty){
      return Center(
        child: Text('No favorites yet.'),
      );
     }
     
    return ListView(
      children: [
        Padding(padding: EdgeInsets.all(20),
        child: Text('You have ${fav.length} favorites:'),),
        
        for(var fv in fav)
        ListTile(
          leading: Icon(Icons.favorite),
          title:Text(fv.asLowerCase),
        )
        
      ],

    );
      
  }
}