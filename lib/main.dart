import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(TextEditorApp());
}

class TextEditorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.amber,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(backgroundColor: Colors.amber),
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              labelStyle: TextStyle(color: Colors.black)),
          sliderTheme: SliderThemeData(
              activeTrackColor: Colors.amberAccent,
              thumbColor: Colors.amberAccent)),
      debugShowCheckedModeBanner: false,
      home: TextEditorScreen(),
    );
  }
}

class TextEditorScreen extends StatefulWidget {
  @override
  _TextEditorScreenState createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  Offset textPosition = Offset(100, 100);
  String displayText = "Hello! User";
  double fontSize = 20;
  FontWeight fontWeight = FontWeight.normal;
  String selectedFont = "Roboto";

  final List<Map<String, dynamic>> undoStack = [];
  final List<Map<String, dynamic>> redoStack = [];

  void saveState() {
    undoStack.add({
      'textPosition': textPosition,
      'displayText': displayText,
      'fontSize': fontSize,
      'fontWeight': fontWeight,
      'selectedFont': selectedFont,
    });
    redoStack.clear();
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      redoStack.add({
        'textPosition': textPosition,
        'displayText': displayText,
        'fontSize': fontSize,
        'fontWeight': fontWeight,
        'selectedFont': selectedFont,
      });
      final lastState = undoStack.removeLast();
      setState(() {
        textPosition = lastState['textPosition'];
        displayText = lastState['displayText'];
        fontSize = lastState['fontSize'];
        fontWeight = lastState['fontWeight'];
        selectedFont = lastState['selectedFont'];
      });
    }
  }

  void redo() {
    if (redoStack.isNotEmpty) {
      undoStack.add({
        'textPosition': textPosition,
        'displayText': displayText,
        'fontSize': fontSize,
        'fontWeight': fontWeight,
        'selectedFont': selectedFont,
      });
      final lastState = redoStack.removeLast();
      setState(() {
        textPosition = lastState['textPosition'];
        displayText = lastState['displayText'];
        fontSize = lastState['fontSize'];
        fontWeight = lastState['fontWeight'];
        selectedFont = lastState['selectedFont'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Editor"),
        actions: [
          Text('undo'),
          IconButton(
            icon: Icon(Icons.undo,),
            onPressed: undo,
            tooltip: "Undo",
          ),
          Text('redo'),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: redo,
            tooltip: "Redo",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                saveState();
                setState(() {
                  textPosition += details.delta;
                });
              },
              child: Stack(
                children: [
                  Positioned(
                    left: textPosition.dx,
                    top: textPosition.dy,
                    child: Text(
                      displayText,
                      style: GoogleFonts.getFont(
                        selectedFont,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 10, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    saveState();
                    setState(() {
                      displayText = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Add Text",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                Row(
                  children: [
                    Text("Font-Size:"),
                    Expanded(
                      child: Slider(
                        value: fontSize,
                        min: 10,
                        max: 50,
                        onChanged: (value) {
                          saveState();
                          setState(() {
                            fontSize = value;
                          });
                        },
                      ),
                    ),
                    Text(fontSize.toInt().toString()),
                  ],
                ),
                Row(
                  children: [
                    Text("Font-Weight: "),
                    DropdownButton<FontWeight>(
                      value: fontWeight,
                      items: [
                        DropdownMenuItem(
                          value: FontWeight.normal,
                          child: Text("Normal"),
                        ),
                        DropdownMenuItem(
                          value: FontWeight.bold,
                          child: Text("Bold"),
                        ),
                        DropdownMenuItem(value:FontWeight.w100, child:Text('Light'))
                      ],
                      onChanged: (value) {
                        saveState();
                        setState(() {
                          fontWeight = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Font-Style: "),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedFont,
                        items: [
                          "Roboto",
                          "Lato",
                          "Montserrat",
                          "Oswald",
                          "Open Sans",
                        ].map((font) {
                          return DropdownMenuItem(
                            value: font,
                            child: Text(font),
                          );
                        }).toList(),
                        onChanged: (value) {
                          saveState();
                          setState(() {
                            selectedFont = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
