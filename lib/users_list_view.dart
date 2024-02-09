import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsersListView extends StatelessWidget {

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
    return FutureBuilder(
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

            return ListView.builder(
              itemCount: usersList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = usersList[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: ListTile(
                    title: Text(
                      user['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user['email']),
                    leading: ClipOval(
                      child: Image.network(user['photo']),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
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
                      );
                    },
                  ),
                );
              },
            );
          }
        }
    );
  }
}