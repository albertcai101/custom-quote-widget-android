import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homescreen_widgets/quote_data.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String androidWidgetName = 'QuoteWidget';

class QuoteCustomizer extends StatefulWidget {
  const QuoteCustomizer({Key? key}) : super(key: key);

  @override
  _QuoteCustomizerState createState() => _QuoteCustomizerState();
}

// New: add this function
void updateQuote(Quote newQuote) {
  // Save the headline data to the widget
  HomeWidget.saveWidgetData<String>('appwidget_text', newQuote.content);
  HomeWidget.updateWidget(
    androidName: androidWidgetName,
  );
}

class _QuoteCustomizerState extends State<QuoteCustomizer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedQuote();
    _controller.text = "Be a one trick unicorn."; // Initial quote text
  }

  void _loadSavedQuote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedQuote = prefs.getString('savedQuote') ?? "Be a one trick unicorn.";
    setState(() {
      _controller.text = savedQuote;
    });
  }

  void _saveQuote(String quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedQuote', quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Unfocus all focus nodes
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your quote here',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  cursorColor: Colors.black,
                  textAlign: TextAlign.center,
                  maxLength: 100,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  buildCounter: (
                    BuildContext context, {
                      required int currentLength,
                      required bool isFocused,
                      required int? maxLength,
                    }) {
                    return null;
                  },
                ),
                SizedBox(height: 30), // Spacing between text field and button
                ElevatedButton(
                  onPressed: () {
                    updateQuote(new Quote(content: _controller.text));
                    _saveQuote(_controller.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Updating widget: ${_controller.text}'),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: Text(
                    'Update Widget',
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ), // Apply Inter font
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor: Colors.blue[400], // Text color
                    shadowColor: Colors.transparent, // No shadow
                    elevation: 0, // No elevation
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}