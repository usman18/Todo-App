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

  @override
  void initState() {
    super.initState();
    _readTodoItemsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[TodoItem('Item1', 'Date')],
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
            },
            child: Text('Add')),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel'
          ),
        )
      ],
    );
    showDialog(context: context, builder: (_) {
      return alert;
    });
  }

  _handleSubmit(String text) async{
    _textEditingController.clear();
    var item = TodoItem(text, DateTime.now().toIso8601String());
      int res = await dbHelper.saveItem(item);
      print('Result $res');
  }

  _readTodoItemsList() async{
     var items = await dbHelper.getAllItems();
     print('List $items');
     items.forEach((item) {
        var todoItem = TodoItem.fromMap(item);
        print('Item name ${todoItem.itemName}');
     });
  }



}
