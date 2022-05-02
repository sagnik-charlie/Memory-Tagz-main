import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memory_tagz/quiz_button/controllers/question_controller.dart';

import 'components/quizbody.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          FlatButton(
              onPressed: _controller.nextQuestion,
              child: Text("Skip", style: TextStyle(color: Colors.white))),
        ],
      ),
      body: QuizBody(),
    );
  }
}
