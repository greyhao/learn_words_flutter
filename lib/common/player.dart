import 'package:flutter/foundation.dart';
import 'package:learn_words_flutter/common/api.dart';
import 'package:just_audio/just_audio.dart';

class Player {
  static AudioPlayer audioPlayer = AudioPlayer();

  /// 播放流音频
  void playStream(String url) async {
    debugPrint("playStream url = $url");
    var bytes = await Api().loadBytesByUrl(url);
    await audioPlayer.setAudioSource(_CustomStreamSource(bytes));
  }

  /// 播放网络 .mp3 文件
  void playUrl(String url) async {
    await audioPlayer.setUrl(url);
    await audioPlayer.play();
  }

  /// 释放资源
  void dispose() {
    audioPlayer.dispose();
  }
}

class _CustomStreamSource extends StreamAudioSource {
  final List<int> bytes;
  _CustomStreamSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
        sourceLength: bytes.length,
        contentLength: end - start,
        offset: start,
        stream: Stream.value(bytes.sublist(start, end)),
        contentType: 'audio/mpeg');
  }
}
