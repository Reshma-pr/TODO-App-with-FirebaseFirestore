import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style:
                GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ));
  }
}
