import 'package:flutter/material.dart';
import 'package:water/FirstPage.dart';
import 'package:water/ThirdPage.dart';
import 'package:water/test3.dart';
import 'SecondPage.dart';
import 'SecondPage2.dart';
import 'ThirdPage2.dart';

class ConnectionBetweenPages extends StatefulWidget {
  const ConnectionBetweenPages({Key? key}) : super(key: key);

  @override
  _ConnectionBetweenPages createState() => _ConnectionBetweenPages();
}

class _ConnectionBetweenPages extends State<ConnectionBetweenPages> {
  final PageController _controller = PageController(
    initialPage: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: const [FirstPage(), SecondPage(), MyApp()],
    );
  }
}
