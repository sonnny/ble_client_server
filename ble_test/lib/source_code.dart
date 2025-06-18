import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import './code.dart';
import './main.dart';

class SourceCode extends StatelessWidget{
SourceCode({super.key});

@override Widget build(BuildContext context){
  return Scaffold(appBar: AppBar(title: Text('source code')),
    body: SingleChildScrollView(
      child: Container(padding: const EdgeInsets.all(16),
        color: Colors.black,
        child: Text.rich(
          darkTheme.highlight(code),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14, height: 1.3,)))));}}


