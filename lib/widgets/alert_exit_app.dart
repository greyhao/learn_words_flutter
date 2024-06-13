import 'dart:io';

import 'package:flutter/material.dart';
import 'package:learn_words_flutter/common/player.dart';

/// 双击返回键显示 App 退出提醒
class AlertExitApp extends StatefulWidget {
  const AlertExitApp({super.key, required this.child});
  final Widget child;

  @override
  State<StatefulWidget> createState() => _AlertExitAppState();
}

class _AlertExitAppState extends State<AlertExitApp> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          if (null == _lastPressedAt ||
              DateTime.now().difference(_lastPressedAt!) >
                  const Duration(seconds: 1)) {
            _lastPressedAt = DateTime.now();
            return;
          }
          _showExitDialog();
        },
        child: widget.child);
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("确定要退出吗？"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("暂时不"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                // 退出 App 需要释放的资源
                Player().dispose();

                // 全局退出
                exit(0);
              },
              child: const Text("立即退出"),
            ),
          ],
        );
      },
    );
  }
}
