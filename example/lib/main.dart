import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(
        url: "https://flutter.io/",
        toolbarColor: Colors.deepPurple,
        iosControlColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new RaisedButton(
            onPressed: () => openBrowserTab(),
            child: new Text('Open Flutter website'),
          ),
        ),
      ),
    );
  }
}
