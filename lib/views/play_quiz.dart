import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizley/models/question_model.dart';
import 'package:quizley/services/database.dart';
import 'package:quizley/views/results.dart';
import 'package:quizley/views/widgets/widgets.dart';
import 'package:quizley/views/widgets/quiz_play_widget.dart';

class QuizPlay extends StatefulWidget {
  final String quizId;

  QuizPlay(this.quizId);

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;

// Stream
Stream infoStream;

class _QuizPlayState extends State<QuizPlay> {
  QuerySnapshot questionSnapshot;
  DatabaseService databaseService = new DatabaseService();

  bool isLoading = true;
  @override
  void initState() {
    print("${widget.quizId}");
    databaseService.getQuestionData(widget.quizId).then((value) {
      questionSnapshot = value;
      _notAttempted = questionSnapshot.docs.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnapshot.docs.length;
      print("init don $total");
      setState(() {});
    });

    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        return [_correct, _incorrect];
      });
    }
    setState(() {});

    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();
    questionModel.question = questionSnapshot.get(FieldPath(['question']));

    //shuffling the options

    List<String> options = [
      questionSnapshot.get(FieldPath(['option1'])),
      questionSnapshot.get(FieldPath(['option2'])),
      questionSnapshot.get(FieldPath(['option3'])),
      questionSnapshot.get(FieldPath(['option4'])),
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.get(FieldPath(['option1']));
    questionModel.answered = false;

    print(questionModel.correctOption.toLowerCase());

    return questionModel;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: appBar(context),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black54),
          brightness: Brightness.light),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    InfoHeader(
                      length: questionSnapshot.docs.length,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    questionSnapshot == null
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                              //child: Text("No Data"),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            itemCount: questionSnapshot.docs.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return QuizPlayTile(
                                questionModel: getQuestionModelFromDatasnapshot(
                                    questionSnapshot.docs[index]),
                                index: index,
                              );
                            })
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                        correct: _correct,
                        incorrect: _incorrect,
                        total: total,
                        notattempted: _notAttempted,
                      )));
        },
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({@required this.length});

  @override
  _InfoHeaderState createState() => new _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? SizedBox(
                  height: 50,
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(left: 14),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: <Widget>[
                        NoOfQuestionTile(
                          text: "Total",
                          number: widget.length,
                        ),
                        NoOfQuestionTile(
                          text: "Correct",
                          number: _correct,
                        ),
                        NoOfQuestionTile(
                          text: "Incorrect",
                          number: _incorrect,
                        ),
                        NoOfQuestionTile(
                          text: "NotAttempted",
                          number: _notAttempted,
                        ),
                      ],
                    ),
                  ))
              : Container();
        });
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({@required this.questionModel, @required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q${widget.index + 1} ${widget.questionModel.question}",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option1,
              option: "A",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: "B",
              description: widget.questionModel.option2,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: "C",
              description: widget.questionModel.option3,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                }
              }
            },
            child: OptionTile(
              option: "D",
              description: widget.questionModel.option4,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
