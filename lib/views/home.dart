import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quizley/helper/functions.dart';
import 'package:quizley/views/signin.dart';
import 'package:quizley/services/auth.dart';
import 'package:quizley/services/database.dart';
import 'package:quizley/views/create_quiz.dart';
import 'package:quizley/views/play_quiz.dart';
import 'package:quizley/views/widgets/widgets.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  AuthService _authService = new AuthService();
  DatabaseService databaseService = new DatabaseService();

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
                    snapshot.data.docs
                        .map((doc) => new ListTile(
                            title: new Text(doc["quizTitle"]),
                            subtitle: new Text(doc["quizImgUrl"].toString())))
                        .toList();
                    return QuizTile(
                      imgUrl: snapshot.data.docs[index].data()["quizImgUrl"],
                      desc: snapshot.data.docs[index].data()["quizDescription"],
                      title: snapshot.data.docs[index].data()["quizTitle"],
                      quizId: snapshot.data.docs[index].data()["quizId"],
                    );
                  });
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((val) {
      setState(() {
        quizStream = val;
      });
    });
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: quizList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateQuiz()));
          },
        ));
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;

  QuizTile({
    @required this.imgUrl,
    @required this.title,
    @required this.desc,
    @required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuizPlay(quizId)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width - 48,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black26,
                ),
                alignment: Alignment.center,
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
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(desc)
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
