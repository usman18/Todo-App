import 'package:flutter/material.dart';
import 'package:todo_app/util/DatabaseHelper.dart';

import '../model/TodoItem.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var dbHelper = DatabaseHelper();
  List<TodoItem> _itemsList = List<TodoItem>();

  @override
  void initState() {
    super.initState();
    _readTodoItemsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (_, int position) {
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: _itemsList[position],
                    onLongPress: () => debugPrint,
                    trailing: Listener(
                      key: Key(_itemsList[position].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onPointerDown: (pointerEvent) => {},
                    ),
                  ),
                );
              },
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemsList.length,
            ),
          )
        ],
      ),
      backgroundColor: Colors.black87,
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
        tooltip: 'Tap to add item',
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'Item',
                hintText: 'Add this item',
                icon: Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handleSubmit(_textEditingController.text);
              Navigator.pop(context);
            },
            child: Text('Add')),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _handleSubmit(String text) async {
    _textEditingController.clear();
    var item = TodoItem(text, DateTime.now().toIso8601String());
    int savedItemId = await dbHelper.saveItem(item);
    var addedItem = await dbHelper.getItem(savedItemId);
    setState(() {
      _itemsList.insert(0, addedItem);
    });
  }

  _readTodoItemsList() async {
    var items = await dbHelper.getAllItems();
    print('List $_itemsList');
    items.forEach((item) {
      setState(() {
        var todoItem = TodoItem.fromMap(item);
        _itemsList.add(todoItem);
      });
    });
  }
}
