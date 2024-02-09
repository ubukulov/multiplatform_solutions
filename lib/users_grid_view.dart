import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popover/popover.dart';

class UsersGridView extends StatelessWidget {

  Future<List<Map<String, dynamic>>> loadBandData() async {
    try {
      String jsonData = await rootBundle.loadString('assets/users.json');
      List<dynamic> jsonDataList = json.decode(jsonData);
      List<Map<String, dynamic>> usersList = List<Map<String, dynamic>>.from(jsonDataList);
      return usersList;
    } catch (error) {
      throw ('Failed to load band data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadBandData(),
          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || !(snapshot.data is List)) {
              return Center(
                child: Text('Invalid data format'),
              );
            } else {
              List<Map<String, dynamic>> usersList = snapshot.data!;

              return GridView.count(
                crossAxisCount: 3,
                children: List.generate(usersList.length, (index) {
                  Map<String, dynamic> user = usersList[index];
                  return GestureDetector(
                    onTap: () {
                      showPopover(
                        context: context,
                        bodyBuilder: (context) {
                          return Container(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black,
                                              width: 1.0
                                          )
                                      )
                                  ),
                                  child: const ListTile(
                                    title: Text('Посмотреть профиль'),
                                    leading: Icon(Icons.account_circle_rounded),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black,
                                              width: 1.0
                                          )
                                      )
                                  ),
                                  child: const ListTile(
                                    title: Text('Посмотреть друзей'),
                                    leading: Icon(Icons.supervised_user_circle_sharp),
                                  ),
                                ),
                                const ListTile(
                                  title: Text('Сделать репорт данного человека'),
                                  leading: Icon(Icons.add_chart),
                                ),
                              ],
                            ),
                          );
                        },
                        onPop: () => print('Popover was popped!'),
                        direction: PopoverDirection.bottom,
                        width: 200,
                        height: 200,
                      );
                    },
                    child: Container(
                      height: 150,
                      color: Colors.cyan,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              user['photo'],
                              width: 100,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              user['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(user['email']),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              );
            }
          }
      ),
    );
  }
}
