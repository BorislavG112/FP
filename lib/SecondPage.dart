import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:parallax_rain/parallax_rain.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPage createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> {
  SMIInput<bool>? _playButtonInput;
  Artboard? _playButtonArtboard;
  SMIInput<bool>? _playButtonInput1;
  Artboard? _playButtonArtboard1;
  bool isSelected = true;

  void _playHamburg() {
    if (_playButtonInput?.value == false &&
        _playButtonInput?.controller.isActive == false) {
      _playButtonInput?.value = true;
      _playButtonInput1?.value = true;
      setState(() {
        _playButtonInput?.value = true;
      });
    } else if (_playButtonInput?.value == true &&
        _playButtonInput?.controller.isActive == false) {
      _playButtonInput?.value = false;
      _playButtonInput1?.value = false;
      setState(() {
        _playButtonInput?.value = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rootBundle.load('animations/hamburg2(12).riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller != null) {
        artboard.addController(controller);
        _playButtonInput = controller.findInput('Boolean1');
      }
      setState(
        () => _playButtonArtboard = artboard,
      );
    });
    super.initState();
    rootBundle.load('lib/animations/youbethere(3).riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller1 =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller1 != null) {
        artboard.addController(controller1);
        _playButtonInput1 = controller1.findInput('Boolean 1');
      }
      setState(
        () => _playButtonArtboard1 = artboard,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Key parallaxOne = GlobalKey();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 8, 2, 14),
        body: Stack(children: [
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
                'Slide left to make a photo and\n       right to write the story!',
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
          _playButtonArtboard == null // && _playButtonArtboard1 == null
              ? const SizedBox()
              : SingleChildScrollView(
                  child: SizedBox(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(children: [
                      Positioned(
                        left: -90,
                        right: 0,
                        child: SizedBox(
                          width: MediaQuery.of(context)
                              .size
                              .width, //double.maxFinite,
                          height: MediaQuery.of(context)
                              .size
                              .height, //double.maxFinite,
                          child: Rive(
                            artboard: _playButtonArtboard1!,
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width / 1.3, //320,
                        right: 0,
                        top: 7,
                        child: GestureDetector(
                          onTapDown: (_) => _playHamburg(),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height / 13,
                              //width: MediaQuery.of(context).size.width / 10, //48,
                              child: Rive(
                                artboard: _playButtonArtboard!,
                                fit: BoxFit.fitHeight,
                              )),
                        ),
                      ),
                      // ignore: unrelated_type_equality_checks
                      if (_playButtonInput?.value == true) ...[
                        //height: 10,
                        //width: 10,
                        Positioned(
                          left: 10,
                          top: 15,
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: DefaultTextStyle(
                              style: const TextStyle(
                                color: Colors.black26,
                                fontSize: 25.0,
                                fontFamily: 'Agne',
                              ),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    '',
                                    textStyle: const TextStyle(
                                        color: Colors.transparent),
                                  ),
                                  TypewriterAnimatedText(
                                    'Can be the begging of something great',
                                    textStyle: const TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      //color: Colors.white
                                    ),
                                    speed: const Duration(milliseconds: 20),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                pause: const Duration(milliseconds: 300),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                              )),
                        ),
                      ],
                    ]),
                  ),
                ),
        ]));
  }
}
