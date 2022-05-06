import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'QuizPage.dart';

class QuizButtonContainer extends StatelessWidget {
  const QuizButtonContainer({Key? key, required this.bannerText})
      : super(key: key);

  final String bannerText;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.2;
    return InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => QuizPage()));
        },
        child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0,5))
              ],
            ),
            child: Center(
                child: Container(
                    width: size,
                    decoration:
                        BoxDecoration(color: Colors.white60, boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: const Offset(0, 10),
                      )
                    ]),
                    child: const Text(
                      "Quiz",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                      ),
                    )))));
  }
}
