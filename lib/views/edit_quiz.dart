import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizley/models/question_model.dart';
import 'package:quizley/services/database.dart';
import 'package:quizley/views/addquestion.dart';
import 'package:quizley/views/edit_question.dart';
import 'package:quizley/views/quiz_list.dart';
import 'package:quizley/views/widgets/widgets.dart';

class EditQuiz extends StatefulWidget {
  final String quizId;
  EditQuiz(this.quizId);

  @override
  _EditQuizState createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  String quizId;
  DatabaseService _databaseService = new DatabaseService();
  QuerySnapshot querySnapshot;

  bool _isLoading = true;

  QuestionModel getQuestionModelFromSnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.questionId = questionSnapshot.get(FieldPath(['questionId']));
    questionModel.question = questionSnapshot.get(FieldPath(['question']));

    List<String> options = [
      questionSnapshot.get(FieldPath(['option1'])),
      questionSnapshot.get(FieldPath(['option2'])),
      questionSnapshot.get(FieldPath(['option3'])),
      questionSnapshot.get(FieldPath(['option4'])),
    ];

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];

    questionModel.correctOption = questionSnapshot.get(FieldPath(['option1']));
    // questionModel.correctAnswer = questionSnapshot.get[FieldPath[]]
    questionModel.answered = false;

    return questionModel;
  }

  _deleteQuizSet() {
    _databaseService.deleteQuizData(widget.quizId).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => QuizList()));
      setState(() {});
    });
  }

  @override
  void initState() {
    _databaseService.getQuestionData(widget.quizId).then((value) {
      querySnapshot = value;
      _isLoading = false;
      setState(() {});
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizList()),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black54),
        brightness: Brightness.light,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _deleteQuizSet();
                },
                child: Icon(Icons.delete),
              )),
        ],
      ),
      body: _isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    querySnapshot.docs.length == 0
                        ? Container(
                            child: Center(
                                child: Text(
                              "No Question Available",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            )),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (context, index) {
                              return QuizEditTile(
                                  questionModel: getQuestionModelFromSnapshot(
                                      querySnapshot.docs[index]),
                                  index: index,
                                  quizId: widget.quizId);
                            }),
                  ],
                ),
              ),
            ),
    );
  }
}

class QuizEditTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  final String quizId;
  QuizEditTile({this.questionModel, this.index, this.quizId});

  @override
  _QuizEditTileState createState() => _QuizEditTileState();
}

class _QuizEditTileState extends State<QuizEditTile> {
  DatabaseService databaseService = new DatabaseService();

  deleteQuestionData(String questionId) {
    databaseService.deleteQuestionData(widget.quizId, questionId).then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => EditQuiz(widget.quizId)));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Q${widget.index + 1} ${widget.questionModel.question}",
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      deleteQuestionData(widget.questionModel.questionId);
                    },
                    icon: Icon(
                      Icons.delete_forever_sharp,
                      color: Colors.black87,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditQuestion(
                                  widget.quizId,
                                  widget.questionModel.questionId,
                                  widget.questionModel.question,
                                  widget.questionModel.option1,
                                  widget.questionModel.option2,
                                  widget.questionModel.option3,
                                  widget.questionModel.option4,
                                  widget.questionModel.correctOption)));
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.green,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
