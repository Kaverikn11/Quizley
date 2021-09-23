import 'package:flutter/material.dart';
import 'package:quizley/services/database.dart';
import 'package:quizley/views/edit_quiz.dart';
import 'package:quizley/views/widgets/widgets.dart';

class EditQuestion extends StatefulWidget {
  final String quizId,
      questionId,
      question,
      option1,
      option2,
      option3,
      option4,
      correctOption;
  EditQuestion(this.quizId, this.questionId, this.question, this.option1,
      this.option2, this.option3, this.option4, this.correctOption);

  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  final _formKey = GlobalKey<FormState>();
  String question, option1, option2, option3, option4, questionId;

  bool _isLoading = false;

  DatabaseService _databaseService = new DatabaseService();

  _updateQuestionData() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionData = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
        "questionId": widget.questionId
      };

      await _databaseService
          .updateQuestionData(questionData, widget.quizId, widget.questionId)
          .then((value) => {
                setState(() {
                  _isLoading = false;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditQuiz(widget.quizId)));
                })
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appBar(context),
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      decoration:
                          InputDecoration(hintText: "${widget.question}"),
                      onChanged: (val) {
                        question = val;
                      },
                      validator: (val) {
                        return val.isEmpty ? "Enter question" : null;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "${widget.option1}(correct answer)"),
                      onChanged: (val) {
                        option1 = val;
                      },
                      validator: (val) {
                        return val.isEmpty ? "Enter option one" : null;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(hintText: "${widget.option2}"),
                      onChanged: (val) {
                        option2 = val;
                      },
                      validator: (val) {
                        return val.isEmpty ? "Enter option two" : null;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(hintText: "${widget.option3}"),
                      onChanged: (val) {
                        option3 = val;
                      },
                      validator: (val) {
                        return val.isEmpty ? "Enter option three" : null;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(hintText: "${widget.option4}"),
                      onChanged: (val) {
                        option4 = val;
                      },
                      validator: (val) {
                        return val.isEmpty ? "Enter option four" : null;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 25,
                        height: 50,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        _updateQuestionData();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 25,
                        height: 50,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "update question",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60)
                  ],
                ),
              ),
            ),
    );
  }
}
