import 'package:flutter/material.dart';

/// 自定义标题栏：背景色为主题颜色，图标文本颜色根据背景色的亮度变化
AppBar appBarWithBackground(BuildContext context, String title,
    {Widget? action}) {
  var bgColor = Theme.of(context).primaryColor;
  var fgColor = bgColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
  return AppBar(
    title: Text(
      title,
    ),
    actions: [
      action ??= const SizedBox(
        height: 0,
      ),
    ],
    backgroundColor: bgColor, // 标题栏背景色
    foregroundColor: fgColor, // 图标颜色、标题颜色
  );
}
