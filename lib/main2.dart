import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_universal/webview_universal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WebViewController webViewController = WebViewController();
  final TextEditingController _urlController = TextEditingController();

  String title = '';
  String corsHeader = '';

  loadWebsiteContent() {
    if(webViewController.is_init) {
      webViewController.goSync(uri: Uri.parse(_urlController.text));
    } else {
      webViewController.init(
        context: context,
        setState: setState,
        uri: Uri.parse(_urlController.text),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: WebView(
              controller: webViewController,
            ),
          )
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
                          loadWebsiteContent();
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