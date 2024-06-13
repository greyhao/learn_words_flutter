import 'package:flutter/material.dart';
import 'package:learn_words_flutter/routes/add_word_page.dart';
import 'package:learn_words_flutter/routes/const.dart';
import 'package:learn_words_flutter/routes/dictionaries_page.dart';
import 'package:learn_words_flutter/routes/words_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '每日背单词',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DictionariesRoute(),
      routes: <String, WidgetBuilder>{
        ROUTE_HOME: (context) => const DictionariesRoute(),
        ROUTE_WORDS: (context) => const WordsRoute(),
        ROUTE_ADD_WORD: (context) => const AddWordsRoute(),
      },
    );
  }
}
