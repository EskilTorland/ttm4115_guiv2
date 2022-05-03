import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'dart:convert';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  List<dynamic> futureTeams = [];

  Future<List<dynamic>> getTeams() async {
    var unescape = HtmlUnescape();
    final response =
        await http.get(Uri.parse("http://localhost:5000/getTeams"));
    var responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  }

  void initState() {
    getTeams().then((value) {
      futureTeams = value;
      print(futureTeams);
    });
  }

  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 600,
      child: FutureBuilder(
        future: getTeams(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data[index]['name']),
                    leading: Text("${index + 1}"),
                    trailing: Text("Score: " + snapshot.data[index]['score'].toString()),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                itemCount: snapshot.data.length);
          }
        },
      ),
    );
  }
}
