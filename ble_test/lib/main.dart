import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import './home.dart';

late final Highlighter darkTheme;

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Highlighter.initialize(['dart','yaml']);
var dark = await HighlighterTheme.loadDarkTheme();
darkTheme = Highlighter(language: 'dart', theme: dark);
runApp(MainApp());}

class MainApp extends StatelessWidget {
MainApp({super.key});

@override Widget build(BuildContext context) {
return MaterialApp(debugShowCheckedModeBanner: false,
title: 'ble test', home: Home());}}
