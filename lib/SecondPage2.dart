import 'package:flutter/material.dart';
import 'package:parallax_rain/parallax_rain.dart';

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parallax Rain',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 8, 2, 14),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Key parallaxOne = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ParallaxRain(
            key: parallaxOne,
            dropColors: const [
              Color.fromARGB(255, 128, 255, 255),
              Color.fromARGB(255, 128, 191, 255),
              Color.fromARGB(255, 128, 128, 255),
              Color.fromARGB(255, 191, 128, 255),
              Color.fromARGB(255, 255, 128, 255),
              Color.fromARGB(255, 77, 0, 230),
              Color.fromARGB(255, 25, 102, 255),
              Color.fromARGB(255, 38, 0, 230),
              Color.fromARGB(255, 217, 25, 255),
              Color.fromARGB(255, 153, 0, 230),
            ],
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: Text(
                'Slide left to make a photo\n\nSlide right to add more to the story!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: Text(
                'PhotoMap',
                style: TextStyle(fontSize: 42, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
