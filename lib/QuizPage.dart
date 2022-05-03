import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'AnswerBox.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

class QuizEntry {
  final String question;
  final List<Answers> answers;

  QuizEntry({required this.question, required this.answers});
}

class Answers {
  final String answerText;
  final bool answerCorrect;

  Answers({required this.answerText, required this.answerCorrect});
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _questionIndex = 0;
  int _totalScore = 0;
  bool gameEnded = true;
  List<QuizEntry> futureQuiz = [];

  escOnPress() {
    updateTeam("myteam", 7);
    Navigator.pop(context);
  }

  void initState() {
    getQuiz().then((value) {
      futureQuiz = value;
    });
  }

  Future<void> updateTeam(String name, int score) {
    return http.put(Uri.parse("http://localhost:5000/updateTeam"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({'name': name, 'score': score}));
  }

  Future<List<QuizEntry>> getQuiz() async {
    var unescape = HtmlUnescape();
    final response = await http
        .get(Uri.parse("https://ttm4115-backend.herokuapp.com/getQuiz"));
    var responseData = json.decode(response.body);
    print(responseData);
    List<QuizEntry> quiz = [];
    for (var singleEntry in responseData) {
      List<dynamic> dynamicEntry = singleEntry["quiz"]["answers"];
      List<Answers> answerList = [];
      for (int i = 0; i < dynamicEntry.length; i++) {
        answerList.add(Answers(
            answerText: unescape
                .convert(singleEntry["quiz"]["answers"][i]["answerText"]),
            answerCorrect: singleEntry["quiz"]["answers"][i]["answerCorrect"]));
      }
      QuizEntry quizEntry = QuizEntry(
          question: unescape.convert(singleEntry["quiz"]["question"]),
          answers: answerList..shuffle());

      quiz.add(quizEntry);
    }
    return quiz;
  }

  void questionAnswered(bool answerCorrect) {
    setState(() {
      if (_questionIndex == _questions.length - 1) {
        if (answerCorrect) {
          _totalScore++;
        }
        gameEnded = false;
        return;
      }
      if (answerCorrect) {
        _totalScore++;
      }
      _questionIndex++;
    });
  }

  Color setColor(int index) {
    if (!gameEnded) {
      return Color.fromARGB(255, 10, 65, 110);
    }

    if (index == _questionIndex) {
      return Colors.lightBlue;
    }
    if (index < _questionIndex) {
      return Color.fromARGB(255, 10, 65, 110);
    }
    return Colors.white;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: Text("Quiz"),
      ),
      body: Center(
          child: Column(
        children: [
          FutureBuilder<List<QuizEntry>>(
              future: getQuiz(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<QuizEntry>> snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 130,
                    margin: EdgeInsets.only(
                        bottom: 10, left: 30, right: 30, top: 30),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      gameEnded
                          ? futureQuiz[_questionIndex].question
                          : "Thank you for playing",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  );
                }
              }),
          Visibility(
            visible: !gameEnded,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              //height: 60,
              child: ElevatedButton(
                onPressed: escOnPress,
                child: Text(
                  "Exit",
                  style: TextStyle(
                    fontSize: 96,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: gameEnded,
            child: Column(
              children: [
                FutureBuilder<List<QuizEntry>>(
                    future: getQuiz(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<QuizEntry>> snapshot,
                    ) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            AnswerBox(
                                answerText: futureQuiz[_questionIndex]
                                    .answers[0]
                                    .answerText,
                                onTap: () {
                                  questionAnswered(futureQuiz[_questionIndex]
                                      .answers[0]
                                      .answerCorrect);
                                }),
                            AnswerBox(
                                answerText: futureQuiz[_questionIndex]
                                    .answers[1]
                                    .answerText,
                                onTap: () {
                                  questionAnswered(futureQuiz[_questionIndex]
                                      .answers[1]
                                      .answerCorrect);
                                }),
                            AnswerBox(
                                answerText: futureQuiz[_questionIndex]
                                    .answers[2]
                                    .answerText,
                                onTap: () {
                                  questionAnswered(futureQuiz[_questionIndex]
                                      .answers[2]
                                      .answerCorrect);
                                }),
                            AnswerBox(
                                answerText: futureQuiz[_questionIndex]
                                    .answers[3]
                                    .answerText,
                                onTap: () {
                                  questionAnswered(futureQuiz[_questionIndex]
                                      .answers[3]
                                      .answerCorrect);
                                }),
                          ],
                        );
                      }
                    }),

                // AnswerBox(
                //     answerText:
                //         futureQuiz[_questionIndex].answers[0].answerText,
                //     onTap: () {
                //       questionAnswered(
                //           futureQuiz[_questionIndex].answers[0].answerCorrect);
                //     })

                // [_questionIndex]['answers']
                //         as List<Map<String, dynamic>>)
                //     .map((answer) => AnswerBox(
                //           answerText: answer.answerText,
                //           onTap: () {
                //             questionAnswered(answer.answerCorrect);
                //           },
                //         )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(10)),
            child: Text(
              "Your Score\n${_totalScore.toString()}/${_questions.length}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: setColor(index),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent)),
                );
              },
            ),
          ),
        ],
      )),
    );
  }

  final List<Map<String, dynamic>> _questions = const [
    {
      'question':
          "What is the name of your team in Star Wars: Republic Commando?",
      "answers": [
        {"answertext": "The Commandos", "answerCorrect": false},
        {"answertext": "Bravo Six", "answerCorrect": false},
        {"answertext": "Delta Squad", "answerCorrect": true},
        {"answertext": "Vaders fist", "answerCorrect": false},
      ],
    },
    {
      "question": "How many studio albums have the duo Daft Punk released?",
      "answers": [
        {"answertext": "4", "answerCorrect": true},
        {"answertext": "2", "answerCorrect": false},
        {"answertext": "5", "answerCorrect": false},
        {"answertext": "1", "answerCorrect": false},
      ],
    },
    {
      "question":
          "What is the code name for the mobile operating system Android 7.0?",
      "answers": [
        {"answertext": "Ice Cream Sandwich", "answerCorrect": false},
        {"answertext": "Jelly Bean", "answerCorrect": false},
        {"answertext": "Marshmallow", "answerCorrect": false},
        {"answertext": "Nougat", "answerCorrect": true},
      ],
    },
    {
      "question": "What is the smallest country in the world?",
      "answers": [
        {"answertext": "Maldives", "answerCorrect": false},
        {"answertext": "Vatican City", "answerCorrect": true},
        {"answertext": "Monaco", "answerCorrect": false},
        {"answertext": "Malta", "answerCorrect": false},
      ],
    },
    {
      "question":
          "What was the name of the first front-wheel-drive car produced by Datsun (now Nissan)?",
      "answers": [
        {"answertext": "Sunny", "answerCorrect": false},
        {"answertext": "Cherry", "answerCorrect": true},
        {"answertext": "Skyline", "answerCorrect": false},
        {"answertext": "Bluebird", "answerCorrect": false},
      ],
    },
    {
      "question":
          "What was the name of the first front-wheel-drive car produced by Datsun (now Nissan)?",
      "answers": [
        {"answertext": "Sunny", "answerCorrect": false},
        {"answertext": "Cherry", "answerCorrect": true},
        {"answertext": "Skyline", "answerCorrect": false},
        {"answertext": "Bluebird", "answerCorrect": false},
      ],
    },
    {
      "question":
          "What was the name of the first front-wheel-drive car produced by Datsun (now Nissan)?",
      "answers": [
        {"answertext": "Sunny", "answerCorrect": false},
        {"answertext": "Cherry", "answerCorrect": true},
        {"answertext": "Skyline", "answerCorrect": false},
        {"answertext": "Bluebird", "answerCorrect": false},
      ],
    },
    {
      "question":
          "What was the name of the first front-wheel-drive car produced by Datsun (now Nissan)?",
      "answers": [
        {"answertext": "Sunny", "answerCorrect": false},
        {"answertext": "Cherry", "answerCorrect": true},
        {"answertext": "Skyline", "answerCorrect": false},
        {"answertext": "Bluebird", "answerCorrect": false},
      ],
    },
    {
      "question":
          "What was the name of the first front-wheel-drive car produced by Datsun (now Nissan)?",
      "answers": [
        {"answertext": "Sunny", "answerCorrect": false},
        {"answertext": "Cherry", "answerCorrect": true},
        {"answertext": "Skyline", "answerCorrect": false},
        {"answertext": "Bluebird", "answerCorrect": false},
      ],
    },
    {
      "question":
          "What was the name of the first front-wheel-drive car produced by Datsun (now Nissan)?",
      "answers": [
        {"answertext": "Sunny", "answerCorrect": false},
        {"answertext": "Cherry", "answerCorrect": true},
        {"answertext": "Skyline", "answerCorrect": false},
        {"answertext": "Bluebird", "answerCorrect": false},
      ],
    },
  ];
}
