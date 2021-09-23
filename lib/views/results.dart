import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  final int total, correct, incorrect, notattempted;

  Results(
      {@required this.incorrect,
      @required this.total,
      @required this.correct,
      @required this.notattempted});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ((widget.correct / widget.total) * 100) >= 90
                  ? Text(
                      "EXCELLENT..! ",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    )
                  : ((widget.correct / widget.total) * 100) >= 70 &&
                          ((widget.correct / widget.total) * 100) < 90
                      ? Text(
                          "VERY GOOD..!",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        )
                      : ((widget.correct / widget.total) * 100) >= 50 &&
                              ((widget.correct / widget.total) * 100) < 70
                          ? Text(
                              "GOOD..! ",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "BETTER LUCK NEXT TIME! ",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
              SizedBox(
                height: 8,
              ),
              Text(
                "${widget.correct}/ ${widget.total}",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Correct answers = ${widget.correct} \n ",
                        style: TextStyle(fontSize: 17, color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        " Incorrect answers = ${widget.incorrect} \n ",
                        style: TextStyle(fontSize: 17, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        " Not attempted = ${widget.notattempted} \n",
                        style: TextStyle(fontSize: 17, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Go to home",
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
