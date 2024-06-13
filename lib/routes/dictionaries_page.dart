import 'package:flutter/material.dart';
import 'package:learn_words_flutter/database/db.dart';
import 'package:learn_words_flutter/models/index.dart';
import 'package:learn_words_flutter/routes/const.dart';
import 'package:learn_words_flutter/widgets/alert_exit_app.dart';
import 'package:learn_words_flutter/widgets/appbar.dart';

class DictionariesRoute extends StatefulWidget {
  const DictionariesRoute({super.key});
  @override
  State<DictionariesRoute> createState() => _DictionariesRouteState();
}

class _DictionariesRouteState extends State<DictionariesRoute> {
  // 所有分组列表
  List<CategoryInfo> list = [];
  // 单词书包含的单词列表
  List<WordInfo> wordList = [];

  // 已展开的分组 index
  List<int> expandCategoryIndex = [];

  @override
  void initState() {
    // 设置列表
    loadList();
    super.initState();
  }

  void loadList() async {
    // 从数据库中拿数据
    var tempList = await MySqflite().findAllDictionary();
    setState(() {
      list = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertExitApp(
      child: Scaffold(
        appBar: appBarWithBackground(
          context,
          "每日背单词",
          action: IconButton(
              iconSize: 28,
              onPressed: () {
                // 添加单词
                Navigator.pushNamed(context, ROUTE_ADD_WORD);
              },
              icon: const Icon(Icons.library_add)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: categoryList(),
        ),
      ),
    );
  }

  // 分组列表
  Widget categoryList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  list[index].name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      if (expandCategoryIndex.contains(index)) {
                        expandCategoryIndex.remove(index);
                      } else {
                        expandCategoryIndex.add(index);
                      }
                    });
                  },
                  icon: expandCategoryIndex.contains(index)
                      ? const Icon(
                          Icons.expand_less,
                          size: 40,
                        )
                      : const Icon(
                          Icons.expand_more,
                          size: 40,
                        ),
                ),
              ),
              expandCategoryIndex.contains(index)
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.count(
                        shrinkWrap: true, // 解决嵌套无限高的问题
                        physics:
                            const NeverScrollableScrollPhysics(), // 修改局部滑动问题
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 6,
                        children: gridItem(list[index].books),
                      ))
                  : const SizedBox(),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 0.2,
        );
      },
      itemCount: list.length,
    );
  }

  List<Widget> gridItem(List<DictionaryInfo> bookList) {
    return bookList
        .map(
          (e) => GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ROUTE_WORDS,
                arguments: {"info": e.toJson()}, // 传入当前点击的对象
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.all(6),
              alignment: Alignment.center,
              child: FittedBox(
                child: Text(
                  e.name,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
