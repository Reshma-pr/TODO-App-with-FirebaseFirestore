import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntryField extends StatelessWidget {
  EntryField(
      {required this.label,
      required this.hide,
      required this.textEditingController});
  final String label;
  final bool hide;
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hide,
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return "This Field Cannot be empty";
          }
        }
      },
      controller: textEditingController,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(60)),
          filled: true,
          labelText: label,
          labelStyle: GoogleFonts.oswald(fontSize: 20, color: Colors.black38),
          fillColor: Colors.grey[200]),
    );
  }
}
