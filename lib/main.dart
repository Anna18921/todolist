import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = List<Item>();
  // construtor para inicializar a lista
  HomePage() {
    items = [];
  }
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newtaskController = new TextEditingController();
  bool visible = false;
  void toastTaskFailed() {
    Fluttertoast.showToast(
      msg: "Campo Vazio.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  void toastTaskAdd() {
    Fluttertoast.showToast(
      msg: "Tarefa Adicionada com Sucesso.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  void toastTaskRemove() {
    Fluttertoast.showToast(
      msg: "Tarefa Removida com Sucesso.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  void add() {
    if (!newtaskController.text.isEmpty) {
      setState(() {
        widget.items.add(
          Item(title: newtaskController.text, done: false),
        );
        save();
        toastTaskAdd();
      });
      newtaskController.clear();
    } else {
      toastTaskFailed();
    }
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
    toastTaskRemove();
  }

  Future load() async {
    var preference = await SharedPreferences.getInstance();
    var data = preference.getString('data');

    if (data.isEmpty) {
      return;
    }

    Iterable decode = jsonDecode(data);
    List<Item> result = decode.map((x) => Item.fromJson(x)).toList();

    setState(() {
      widget.items = result;
    });
  }

  save() async {
    var preference = await SharedPreferences.getInstance();
    await preference.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newtaskController,
          decoration: InputDecoration(
              labelText: 'Nova Tarefa: ',
              labelStyle: TextStyle(color: Colors.white, fontSize: 15)),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        // o builder vai renderizar em tempo de execução ou seja sobre demanda;
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          //construtor do listView
          final item = widget.items[index];
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            key: Key(item.title),
            onDismissed: (direction) {
              remove(index);
            },
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red.withOpacity(0.5),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.delete_sweep,
                        color: Colors.white,
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: add,
      ),
    );
  }
}
