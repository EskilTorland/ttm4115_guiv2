import 'package:flutter/material.dart';

class AnswerBox extends StatelessWidget {
  final String answerText;
  final VoidCallback onTap;

  AnswerBox({required this.answerText,required this.onTap});

  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      child: 
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(answerText,
                style: const TextStyle(
                  fontSize: 16,
                )),
          ),
        ),
      
    );
  }
}
