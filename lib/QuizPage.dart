import 'dart:convert';
import 'dart:io';
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
  final int quizLength = 10;
  int _totalScore = 0;
  bool gameEnded = true;
  List<QuizEntry> futureQuiz = [];
  final String url = "https://ttm4115-backend.herokuapp.com";

  escOnPress() {
    Navigator.pop(context);
  }

  void initState() {
    getQuiz().then((value) {
      futureQuiz = value;
    });
  }

  Future<List<QuizEntry>> getQuiz() async {
    var unescape = HtmlUnescape();
    final response = await http.get(Uri.parse(url + "/getQuiz"));
    var responseData = json.decode(response.body);
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
      if (_questionIndex == quizLength - 1) {
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
        title: const Text("Quiz"),
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
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 130,
                    margin: const EdgeInsets.only(
                        bottom: 10, left: 30, right: 30, top: 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      gameEnded
                          ? futureQuiz[_questionIndex].question
                          : "Thank you for playing",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                child: const Text(
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
                          child: const Center(
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
              "Your Score\n${_totalScore.toString()}/${quizLength}",
              textAlign: TextAlign.center,
              style: const TextStyle(
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
}
