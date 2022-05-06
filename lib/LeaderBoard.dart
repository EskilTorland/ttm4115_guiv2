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
  final String url = "https://ttm4115-backend.herokuapp.com";

  Future<List<dynamic>> getTeams() async {
    final response = await http.get(Uri.parse(url + "/getTeams"));
    var responseData = json.decode(response.body);
    return responseData;
  }

  @override
  void initState() {
    getTeams().then((value) {
      futureTeams = value;
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
              child: const Center(
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
                    trailing: Text(
                        "Score: " + snapshot.data[index]['score'].toString()),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                      color: Colors.black,
                    ),
                itemCount: snapshot.data.length);
          }
        },
      ),
    );
  }
}
