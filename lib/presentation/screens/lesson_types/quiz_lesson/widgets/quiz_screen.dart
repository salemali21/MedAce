import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medace_app/data/models/quiz/quiz_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QuizScreenArgs {
  QuizScreenArgs(this.quizResponse, this.lessonId, this.courseId);

  final QuizResponse quizResponse;
  final int lessonId;
  final int courseId;
}

class QuizScreen extends StatelessWidget {
  const QuizScreen() : super();

  static const String routeName = '/quizScreen';

  @override
  Widget build(BuildContext context) {
    QuizScreenArgs args = ModalRoute.of(context)?.settings.arguments as QuizScreenArgs;
    return QuizScreenWidget(
      args.quizResponse,
      args.lessonId,
      args.courseId,
    );
  }
}

class QuizScreenWidget extends StatefulWidget {
  QuizScreenWidget(this.quizResponse, this.lessonId, this.courseId) : super();

  final QuizResponse quizResponse;
  final int lessonId;
  final int courseId;

  @override
  State<StatefulWidget> createState() => QuizScreenWidgetState();
}

class QuizScreenWidgetState extends State<QuizScreenWidget> {
  WebViewController webViewController = WebViewController();

  @override
  void initState() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.quizResponse.viewLink),
      )
      ..addJavaScriptChannel(
        'lmsEvent',
        onMessageReceived: (JavaScriptMessage result) {
          if (jsonDecode(result.message)['event_type'] == 'close_quiz') {
            Navigator.pop(context);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) async {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) async {},
        ),
      );
    super.initState();
  }

  bool isCoursePassed(QuizResponse response) {
    bool passed = false;
    if (response.quizData!.isNotEmpty) {
      widget.quizResponse.quizData?.forEach((value) {
        if (value?.status == 'passed') passed = true;
      });
    }
    return passed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF273044),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.quizResponse.section?.number ?? '',
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
                Text(
                  widget.quizResponse.title,
                  textScaleFactor: 1.0,
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
