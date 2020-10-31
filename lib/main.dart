import 'package:flutter/material.dart';

import 'app/edit_panel.dart';
import 'core/formater.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Translation Auto Format'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String src = '';
  String dst = '';

  TextEditingController _srcController;
  TextEditingController _dstController;

  @override
  void initState() {
    _srcController = TextEditingController();
    _dstController = TextEditingController();


    super.initState();
  }


  final TextParser parser = TextParser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: EditPanel(
                controller: _srcController,
                maxLines: 1000,
                minLines: 1000,
              ),
            ),
            VerticalDivider(),
            Expanded(
              child: SingleChildScrollView(
                child: EditPanel(
                  controller: _dstController,
                  color: Colors.green,
                  maxLines: 1000,
                  minLines: 1000,
                  enable: false,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print(_srcController.text);
          final str = _srcController.text;
          for (int i = 0; i < str.length; i++) {
            parser.addFirst(str[i]);
          }
          parser.parser();
          _dstController.text = parser.toString();
        },
        tooltip: 'Increment',
        child: Icon(Icons.transfer_within_a_station),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
