import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> list = List.generate(20, (index) => "This is number $index");
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(list[index]),
              direction: DismissDirection.endToStart,
              child: ListTile(title: Text('${list[index]}')),
              background: Container(
                color: Colors.redAccent,
              ),
              onDismissed: (direction) {
                setState(() {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("${list[index]}")));
                  list.removeAt(index);
                });
              },
            );
          }),
    );
  }
}