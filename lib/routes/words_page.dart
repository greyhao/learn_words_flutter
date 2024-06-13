import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learn_words_flutter/database/db.dart';
import 'package:learn_words_flutter/enum/word_page_mode.dart';
import 'package:learn_words_flutter/models/index.dart';
import 'package:learn_words_flutter/widgets/appbar.dart';
import 'package:learn_words_flutter/widgets/word_info_page.dart';

class WordsRoute extends StatefulWidget {
  const WordsRoute({super.key});
  @override
  State<StatefulWidget> createState() => _WordsRouteState();
}

class _WordsRouteState extends State<WordsRoute> {
  // 词本信息
  late DictionaryInfo dictionaryInfo;
  static const loadingTag = "##loading##";
  // 单词列表
  var wordList = <String>[loadingTag];
  // 是否已经加载数据，配合 loadingTag 一起获取数据
  var haveLoad = false;
  // 页面模式，默认为列表模式
  var pageMode = PageMode.List;

  void loadWords() async {
    var tempWordList =
        await MySqflite().findWordByBookHash(dictionaryInfo.hash);
    setState(() {
      wordList.insertAll(wordList.length - 1, tempWordList);
      haveLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments!;
    // 解析传入的对象
    Map<String, dynamic> map = json.decode(json.encode(args));
    var infoStr = map["info"];
    Map<String, dynamic> info = json.decode(json.encode(infoStr));

    setState(() {
      dictionaryInfo = DictionaryInfo.fromJson(info);
    });

    return Scaffold(
      appBar: appBarWithBackground(
        context,
        dictionaryInfo.name,
        action: IconButton(
          onPressed: () {
            changePageMode();
          },
          icon: isListMode()
              ? const Icon(
                  Icons.fullscreen_rounded,
                  size: 32,
                )
              : const Icon(
                  Icons.fullscreen_exit_rounded,
                  size: 32,
                ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          changePageMode();
        },
        label: Text(
          isListMode() ? "背诵模式" : "浏览模式",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 页面模式是否为列表模式
  bool isListMode() => pageMode == PageMode.List;

  void changePageMode() {
    if (wordList.length > 1) {
      setState(() {
        pageMode = isListMode() ? PageMode.Page : PageMode.List;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("提示"),
            content: const Text("单词列表为空"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("我知道了")),
            ],
          );
        },
      );
    }
  }

  Widget _buildBody() {
    switch (pageMode) {
      case PageMode.List:
        return _buildListModeView();
      case PageMode.Page:
        return _buildPageModeView();
    }
  }

  Widget _buildListModeView() {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (wordList[index] == loadingTag) {
          if (haveLoad) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: const Text("已显示全部"),
            );
          } else {
            loadWords();
            return Container(
              alignment: Alignment.center,
              child: const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
        return ListTile(
          title: Text(
            wordList[index],
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 0.1,
      ),
      itemCount: wordList.length,
    );
  }

  Widget _buildPageModeView() {
    return PageView.builder(
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        if (wordList[index] == loadingTag) {
          // 最后一页，显示完成
          return Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "🎉 ✅ \n 开始下一本",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return WordInfoPage(
            hash: dictionaryInfo.hash, wordStr: wordList[index]);
      },
    );
  }
}
