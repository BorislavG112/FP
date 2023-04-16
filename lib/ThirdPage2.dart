import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[300],
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // get user input
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),

            // buttons -> save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // save button
                MyButton(text: "Save", onPressed: onSave),

                const SizedBox(width: 8),

                // cancel button
                MyButton(text: "Cancel", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  ToDoTile(
      {super.key,
      required this.taskName,
      required this.taskCompleted,
      required this.onChanged,
      required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xffef21e7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // checkbox
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Colors.white,
              ),

              // task name
              Text(
                taskName,
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  decoration: taskCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      child: Text(text),
    );
  }
}

class _MyAppState extends State<MyApp> {
  int selectedButton = 0;
  final _controller = TextEditingController();
  List toDoList = [
    ["Make Tutorial", false],
    ["Do Exercise", false]
  ];
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  void saveNewTask() {
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void createNewtask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 2, 14),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.24,
              padding:
                  const EdgeInsets.only(top: 28.0, left: 24.0, right: 24.0),
              alignment: Alignment.topLeft,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'My\nNotes',
                  style: GoogleFonts.lato(
                      fontSize: 64.0, color: const Color(0xffef21e7)),
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            SizedBox(
              height: 45,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButton = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedButton == 0
                              ? Colors.white
                              : const Color(0xff606060),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: 82,
                      margin: const EdgeInsets.only(left: 10),
                      child: Center(
                        child: Text(
                          'all',
                          style: GoogleFonts.lato(
                              fontSize: 18.0,
                              color: selectedButton == 0
                                  ? Colors.white
                                  : const Color(0xff606060)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButton = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedButton == 1
                              ? Colors.white
                              : const Color(0xff606060),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Text(
                          'hearts',
                          style: GoogleFonts.lato(
                              fontSize: 18.0,
                              color: selectedButton == 1
                                  ? Colors.white
                                  : const Color(0xff606060)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Center(
            //     child: Text(
            //       selectedButton == 0 ? 'All Notes' : 'Hearted Notes',
            //       style: GoogleFonts.lato(
            //         fontSize: 24.0,
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 350,
              child: ListView.builder(
                itemCount: toDoList.length,
                itemBuilder: (context, index) {
                  return ToDoTile(
                    taskName: toDoList[index][0],
                    taskCompleted: toDoList[index][1],
                    onChanged: (value) => checkBoxChanged(value, index),
                    deleteFunction: (context) => deleteTask(index),
                  );
                },
              ),
            ),
            Container(
              height: 85,
              width: 85,
              margin: const EdgeInsets.only(bottom: 7),
              child: Container(
                //margin: const EdgeInsets.only(bottom: 10),
                child: FloatingActionButton(
                  elevation: 0.0,
                  splashColor: const Color.fromARGB(255, 8, 251, 255),
                  onPressed: () {
                    _showNewNotePage();
                  },
                  backgroundColor: const Color(0xffef21e7),
                  child: SizedBox(
                    width: 90.0,
                    height: 90.0,
                    child: CustomPaint(
                      painter: _PlusSignPainter(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewNotePage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        String title = '';
        String content = '';
        String currentDate = DateFormat('MMM. dd, yyyy').format(DateTime.now());
        final _scrollController = ScrollController();

        return GestureDetector(
          // Wrap the Scaffold's body with a GestureDetector
          onTap: () {
            // Unfocus the TextField when the user taps outside of it
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 8, 2, 14),
            appBar: null,
            resizeToAvoidBottomInset: true,
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20,
                                MediaQuery.of(context).size.height / 5, 20, 20),
                            child: TextField(
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 40),
                              decoration: const InputDecoration(
                                hintText: 'Title...',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 173, 171, 175)),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) => title = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              currentDate,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 173, 171, 175),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'You can type something...',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 173, 171, 175),
                                    fontSize: 25),
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              onChanged: (value) => content = value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
                // Edit the note
              },
              child: const Icon(
                Icons.edit,
              ),
            ),
          ),
        );
      },
    )).then((value) {
      if (value != null) {
        // Add the new note to the list of notes and save to database or file
      }
    });
  }
}

class _PlusSignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 8, 2, 14)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.5),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.5, size.height * 0.90),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
