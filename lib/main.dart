import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final TextEditingController _urlController = TextEditingController();
  String title = '';
  String corsHeader = '';
  String _htmlCode = '';

  @override
  void initState() {
    super.initState();
  }


  void _getHtmlCode() async {
    try {
      http.Response response = await http.get(Uri.parse(_urlController.text));
      if (response.statusCode == 200) {
        var document = parse(response.body);
        var titleElement = document.querySelector('title')?.text.trim();
        setState(() {
          title = titleElement!;
          _htmlCode = response.body;
        });
      } else {
        print('Failed to load page: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    corsHeader,
                    style: TextStyle(
                        color: Colors.red[400]
                    ),
                  ),
                  Text(_htmlCode),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          height: 130,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 2.0
              )
            )
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                          labelText: '',
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black54
                              )
                          )
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 10.0,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        _getHtmlCode();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16.0)),
                      ),
                      child: const Text(
                        'LOAD',
                        style: TextStyle(
                            fontSize: 18.0
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    (kIsWeb) ? 'Application running on WEB'.toUpperCase() : 'Application running on ${Platform.operatingSystem}'.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}