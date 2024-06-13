import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/categoryInfo.dart';
import '../models/wordInfo.dart';

const BASE_URL = "https://static2.youzack.com/";

class Api {
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
    ),
  );

  /// 默认数据：分类及对应词书
  Future<List<CategoryInfo>> loadDictionaries() {
    // 返回固定数据，后续可更好为接口请求
    return Future.delayed(const Duration(seconds: 1)).then((value) {
      List<dynamic> result = json.decode(categoryDataStr);
      return result.map((e) => CategoryInfo.fromJson(e)).toList();
    });
  }

  /// 获取具体单词数据
  Future<WordInfo> loadWordInfo(String hash, String wordStr) async {
    var response = await dio.get<Map<String, dynamic>>(
        "youzack/bdc2/word_detail/$hash/$wordStr.json");
    var info = WordInfo.fromJson(response.data!);
    return info;
  }

  /// 返回字节列表
  Future<List<int>> loadBytesByUrl(String url) async {
    var temp = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return temp.data!;
  }
}

var categoryDataStr =
    '[{"id":1,"name":"大学","books":[{"hash":"bca3582c-989e-4c0e-9a9f-9918dd60e12c","name":"大学英语四级近六年真题","progress":0},{"hash":"7e8b17f5-cd17-41ac-9c16-911898bb6df7","name":"大学英语六级近十年真题","progress":0},{"hash":"f-2e8c199-b712-4333-9f0f-733d319924e9","name":"考研阅读近十五年真题","progress":0},{"hash":"aea-8fed0-47d7-4dd9-a152-15e66a3ffe03","name":"北京成人本科学位英语","progress":0}]},{"id":2,"name":"出国","books":[{"hash":"49fc4efd-b2dc-4446-89fb-c91df92671b4","name":"剑桥雅思阅读真题4-15","progress":0},{"hash":"f-3bf9e84-2faf-40cd-bde1-3fc0dc331780","name":"托福TPO阅读真题","progress":0}]},{"id":3,"name":"程序员","books":[{"hash":"126b6a0d-1d29-4d68-bfe0-174e60a74748","name":"TypeScript 基础","progress":0},{"hash":"e7818744-34fd-4ab6-8c4c-10489eefd313","name":"Java","progress":0}]}]';
