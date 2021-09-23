import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizley/views/home.dart';
import 'package:quizley/views/quiz_list.dart';
import '../services/database.dart';
import 'widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;

  AddQuestion({this.quizId});

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();
  String question, option1, option2, option3, option4, questionId;
  bool _isLoading = false;

  uploadQuestionData() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      questionId = randomAlphaNumeric(16);
      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
        "questionId": questionId
      };

      await databaseService
          .addQuestionData(
            questionMap,
            widget.quizId,
            questionId,
          )
          .then((value) => {
                setState(() {
                  _isLoading = false;
                })
              });
    }
  }

  final _auth = FirebaseAuth.instance;
  String userEmail;
  dynamic user;
  void getCurrentUserEmail() async {
    user = await _auth.currentUser;
    userEmail = user.email;
    if (userEmail == 'admin@gmail.com') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => QuizList()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(children: [
                  Flexible(
                    child: TextFormField(
                      validator: (val) => val.isEmpty ? "Enter Question" : null,
                      decoration: InputDecoration(
                        hintText: "Question",
                      ),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    validator: (val) => val.isEmpty ? "Enter option1" : null,
                    decoration: InputDecoration(
                      hintText: "Option1(correct answer)",
                    ),
                    onChanged: (val) {
                      option1 = val;
                    },
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    validator: (val) => val.isEmpty ? "Enter option2" : null,
                    decoration: InputDecoration(
                      hintText: "Option2",
                    ),
                    onChanged: (val) {
                      option2 = val;
                    },
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    validator: (val) => val.isEmpty ? "Enter option3" : null,
                    decoration: InputDecoration(
                      hintText: "Option3",
                    ),
                    onChanged: (val) {
                      option3 = val;
                    },
                  ),
                  SizedBox(height: 6),
                  TextFormField(
                    validator: (val) => val.isEmpty ? "Enter option4" : null,
                    decoration: InputDecoration(
                      hintText: "Option4",
                    ),
                    onChanged: (val) {
                      option4 = val;
                    },
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      uploadQuestionData();
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
                        "Add question",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  GestureDetector(
                    onTap: () {
                      getCurrentUserEmail();
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
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                ]),
              ),
            ),
    );
  }
}
