import 'package:flutter/material.dart';
import 'package:learn_words_flutter/common/api.dart';
import 'package:learn_words_flutter/common/player.dart';
import 'package:learn_words_flutter/enum/accent_mode.dart';
import 'package:learn_words_flutter/models/index.dart';

class WordInfoPage extends StatefulWidget {
  const WordInfoPage({super.key, required this.hash, required this.wordStr});

  final String hash;
  final String wordStr;

  @override
  State<StatefulWidget> createState() => _WordInfoPageState();
}

class _WordInfoPageState extends State<WordInfoPage> {
  WordInfo? wordInfo;
  bool isBlur = true;

  @override
  void initState() {
    _loadInfo();
    super.initState();
  }

  void _loadInfo() async {
    try {
      var info = await Api().loadWordInfo(widget.hash, widget.wordStr);
      setState(() {
        wordInfo = info;
      });
    } catch (e) {
      print("_loadInfo e ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    const playIcon = Icon(
      Icons.volume_up,
      size: 14,
    );
    return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: wordInfo != null
            ? Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.wordStr,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 24),
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text.rich(
                            TextSpan(children: [
                              const TextSpan(
                                text: "考试出现次数：",
                              ),
                              TextSpan(
                                text: "${wordInfo!.frequence}",
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500),
                              ),
                            ]),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 8,
                              ),
                            ),
                            onPressed: () {
                              play(wordInfo!.word, AccentMode.AM);
                            },
                            icon: playIcon,
                            label: Text(
                              "美 /${wordInfo!.americanPhonetic ?? ""}/",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 8,
                              ),
                            ),
                            onPressed: () {
                              play(wordInfo!.word, AccentMode.EN);
                            },
                            icon: playIcon,
                            label: Text(
                              "英 /${wordInfo!.britishPhonetic ?? ""}/",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Text(
                      formate(wordInfo!.translation?[0] ?? ""),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    sampleSentences(wordInfo?.sampleSentences),
                  ],
                ),
              )
            : const Text("加载中"));
  }

  play(String word, AccentMode accentMode) async {
    var accentStr = "";
    switch (accentMode) {
      case AccentMode.AM:
        accentStr = "2";
        break;
      case AccentMode.EN:
        accentStr = "1";
        break;
    }

    var url = "https://dict.youdao.com/dictvoice?audio=$word&type=$accentStr";

    debugPrint("url = $url");

    Player().playStream(url);
  }

  // 格式处理：删除空格、换行、[ 前加换行
  String formate(String source) {
    return source
        .replaceAll(" ", "")
        .replaceAll("\n", " ")
        .replaceAll("[", "\n[");
  }

  Widget sampleSentences(List<SampleSentences>? list) {
    list ?? [];
    var children = list!
        .asMap()
        .entries
        .map((e) => sentencesItem(e.key + 1, e.value))
        .toList();
    if (children.isNotEmpty) {
      children.insert(
          0,
          const Text(
            "例句",
            style: TextStyle(color: Colors.grey),
          ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget sentencesItem(int index, SampleSentences sentences) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$index. ${sentences.en}"),
          sentences.cn != null ? Text(sentences.cn!) : const SizedBox(),
        ],
      ),
    );
  }
}
