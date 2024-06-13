import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_words_flutter/database/db.dart';
import 'package:learn_words_flutter/models/categoryInfo.dart';
import 'package:learn_words_flutter/models/dictionaryInfo.dart';
import 'package:learn_words_flutter/widgets/appbar.dart';

class ItemInfo {
  num index;
  dynamic info;
  ItemInfo(this.index, this.info);
}

class AddWordsRoute extends StatefulWidget {
  const AddWordsRoute({super.key});

  @override
  State<StatefulWidget> createState() => _AddWordsRouteState();
}

class _AddWordsRouteState extends State<AddWordsRoute> {
  num categoryGroupId = 0;
  var categoryList = <ItemInfo>[];
  late CategoryInfo currentCategory;

  num dictionaryGroupId = 0;
  var dictionaryList = <ItemInfo>[];
  late DictionaryInfo currentDictionary;

  // 输入的内容
  // String _inputWord = "";

  // 是否正在保存，防止多次点击
  bool isSaving = false;

  // 错误提示
  String errorMsg = "";

  final TextEditingController _inputControl = TextEditingController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  // 加载词书分组、词书数据
  void initData() async {
    var cList = await MySqflite().findAllCatogrey();
    if (cList.isNotEmpty) {
      for (var i = 0; i < cList.length; i++) {
        var element = cList[i];
        var info = CategoryInfo();
        info.id = element["id"];
        info.name = element["name"];
        var item = ItemInfo(i, info);
        categoryList.add(item);
      }
      currentCategory = categoryList[0].info;
      loadDictionary();
    }
    setState(() {});
  }

  void loadDictionary() async {
    var bList = await MySqflite().findBookById(currentCategory.id);
    dictionaryList.clear();
    if (bList.isNotEmpty) {
      for (var i = 0; i < bList.length; i++) {
        var element = bList[i];
        var info = DictionaryInfo();
        info.name = element["name"];
        info.hash = element["hash"];
        var item = ItemInfo(i, info);
        dictionaryList.add(item);
      }
      currentDictionary = dictionaryList[0].info;
      dictionaryGroupId = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 20,
    );
    const divider = Divider(
      color: Colors.grey,
    );
    return Scaffold(
      appBar: appBarWithBackground(context, "添加单词"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "选择词书分组",
                style: titleStyle,
              ),
              _buildCategoryList(),
              divider,
              const Text(
                "选择词书",
                style: titleStyle,
              ),
              _buildBookList(),
              divider,
              const Text(
                "输入单词（使用 , 分割单词）",
                style: titleStyle,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 500,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: TextField(
                  showCursor: true,
                  maxLines: null, // 换行输入
                  controller: _inputControl,
                  // onChanged: (value) {
                  //   setState(() {
                  //     _inputWord = value;
                  //   });
                  // },
                  decoration: const InputDecoration(
                    hintText: '输入格式：["hello", "English"]，单词之间使用逗号间隔',
                    hintMaxLines: 5,
                    border: InputBorder.none,
                  ),
                ),
              ),
              errorMsg.isNotEmpty
                  ? Text(
                      "错误：$errorMsg",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    )
                  : const SizedBox(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 6),
                child: FilledButton(
                  onPressed: () async {
                    if (!isSaving) {
                      // 删除词书所有单词
                      // Sqfilte().dropWordsByHash(currentDictionary.hash);
                      saveWords();
                    }
                  },
                  child: Text(isSaving ? "保存中" : "保存"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  saveWords() async {
    String inputWord = _inputControl.text;
    if (inputWord.isEmpty) {
      setState(() {
        errorMsg = "未输入任何单词！！";
      });
      return;
    }
    if (!_inputControl.text.startsWith("[")) {
      inputWord = "[$inputWord";
    }
    if (!inputWord.endsWith("]")) {
      inputWord = "$inputWord]";
    }
    List<dynamic> wordList = json.decode(inputWord);
    debugPrint("input wordList =  $wordList");
    setState(() {
      isSaving = true;
    });
    await MySqflite().saveWordsByHash(currentDictionary.hash, wordList);
    setState(() {
      isSaving = false;
      _inputControl.text = "";
    });
  }

  Column _buildCategoryList() {
    return Column(
      children: categoryList.map((e) {
        return Row(
          children: [
            _checkBox(e, categoryGroupId),
            Text((e.info as CategoryInfo).name),
          ],
        );
      }).toList(),
    );
  }

  Column _buildBookList() {
    return Column(
      children: dictionaryList.map((e) {
        return Row(
          children: [
            _checkBox(e, dictionaryGroupId),
            Text((e.info as DictionaryInfo).name),
          ],
        );
      }).toList(),
    );
  }

  Radio _checkBox(ItemInfo info, num groupValue) {
    return Radio(
        activeColor: Theme.of(context).primaryColor,
        value: info.index,
        groupValue: groupValue,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onChanged: (value) {
          setState(() {
            if (info.info is CategoryInfo) {
              currentCategory = info.info;
              categoryGroupId = value;
              loadDictionary();
            } else if (info.info is DictionaryInfo) {
              currentDictionary = info.info;
              dictionaryGroupId = value;
            }
          });
        });
  }
}
