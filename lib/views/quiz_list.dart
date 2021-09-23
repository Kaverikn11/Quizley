import 'package:flutter/material.dart';
import 'package:quizley/helper/functions.dart';
import 'package:quizley/services/database.dart';
import 'package:quizley/views/edit_quiz.dart';
import 'package:quizley/views//widgets/widgets.dart';
import 'package:quizley/services/auth.dart';
import 'package:quizley/views/signin.dart';

import 'create_quiz.dart';

class QuizList extends StatefulWidget {
  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  Stream quizStream;

  DatabaseService _databaseService = new DatabaseService();
  AuthService _authService = new AuthService();
  bool _isLoading = true;
  _signOut() async {
    await _authService.signOut().then((value) {
      HelperFunctions.saveUserTypeDetails(userType: "");
      HelperFunctions().saveUserLoggedInDetails(isLoggedin: false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    });
  }

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(
                      child: Text(
                    "click '+' to add quiz",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )),
                )
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return QuizEditTile(
                        imageUrl:
                            snapshot.data.docs[index].data()["quizImgUrl"],
                        title: snapshot.data.docs[index].data()["quizTitle"],
                        description:
                            snapshot.data.docs[index].data()["quizDescription"],
                        quizId: snapshot.data.docs[index].data()["quizId"]);
                  });
        },
      ),
    );
  }

  @override
  void initState() {
    _databaseService.getQuizData().then((value) {
      setState(() {
        quizStream = value;
        _isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        actions: [
          IconButton(
              onPressed: () {
                _signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black87,
              ))
        ],
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }
}

class QuizEditTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizEditTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.description,
      @required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => EditQuiz(quizId)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: MediaQuery.of(context).size.width - 48,
                  fit: BoxFit.cover,
                )),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black26),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(description,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
