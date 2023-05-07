

import 'package:flutter/material.dart';
import 'package:pelicules_app/search/search_delegate.dart';
import 'package:pelicules_app/widgets/saved_movies_listview.dart';

class WatchListScreen extends StatelessWidget {
   
  const WatchListScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pel·lícules guardades"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            padding: const EdgeInsets.only(right: 5),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
          )
        ],
      ),
      body: const SavedMoviesListView(),
    );
  }
}


/*
class WatchListScreen extends StatefulWidget {
  const WatchListScreen({Key? key}) : super(key: key);

  @override
  _WatchListScreenState createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  final SavedMovies list = SavedMovies();
  final LocalStorage storage = LocalStorage('todo_app.json');
  bool initialized = false; 
  TextEditingController controller = TextEditingController();

  _addItem(String title) {
    setState(() {
      final item = TodoItem(title: title, done: false);
      list.movies.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('todos', list.toJSONEncodable());
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.movies = storage.getItem('todos') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      constraints: const BoxConstraints.expand(),
      child: FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!initialized) {
            var items = storage.getItem('todos');

            if (items != null) {
              list.items = List<TodoItem>.from(
                (items as List).map(
                  (item) => TodoItem(
                    title: item['title'],
                    done: item['done'],
                  ),
                ),
              );
            }

            initialized = true;
          }

          List<Widget> widgets = list.items.map((item) {
            return CheckboxListTile(
              value: item.done,
              title: Text(item.title),
              selected: item.done,
              onChanged: (_) {
                _toggleItem(item);
              },
            );
          }).toList();

          return Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListView(
                  itemExtent: 50.0,
                  children: widgets,
                ),
              ),
              ListTile(
                title: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'What to do?',
                  ),
                  onEditingComplete: _save,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _save,
                      tooltip: 'Save',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: _clearStorage,
                      tooltip: 'Clear storage',
                    )
                  ],
                ),
              ),
            ],
          );
        },
      )
    );
  }

  void _save() {
    _addItem(controller.value.text);
    controller.clear();
  }
}
*/