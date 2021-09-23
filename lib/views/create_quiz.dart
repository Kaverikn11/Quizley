import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizley/services/database.dart';
import 'addquestion.dart';
import 'widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImgUrl, quizTitle, quizDescription, quizId;
  DatabaseService databaseService = new DatabaseService();

  bool _isLoading = false;

  createQuizOnline() async {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgUrl": quizImgUrl,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription,
      };

      await databaseService.addQuizData(quizMap, quizId).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuestion(quizId: quizId),
              ));
        });
      });
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
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(children: [
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Enter Image Url" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Image Url",
                      ),
                      onChanged: (val) {
                        quizImgUrl = val;
                      },
                    ),
                    SizedBox(height: 6),
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Enter Quiz Title" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Title",
                      ),
                      onChanged: (val) {
                        quizTitle = val;
                      },
                    ),
                    SizedBox(height: 6),
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Enter Quiz Description" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Description",
                      ),
                      onChanged: (val) {
                        quizDescription = val;
                      },
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        createQuizOnline();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 48,
                        height: 50,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Create Quiz",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                  ]))),
    );
  }
}
