import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 600,
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Test"),
              leading: Text("${index + 1}"),
              trailing: Text("Score"),
            );
          },
          separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
          itemCount: 20),
    );
  }
}
