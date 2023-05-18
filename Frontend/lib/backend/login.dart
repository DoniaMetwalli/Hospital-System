import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

String apiLink = "https://305.nucoders.dev:8090/";

String hashSha256(String input) {
  var firstChunk = utf8.encode(input);
  return sha256.convert(firstChunk).toString();
}

Future<List> login() async {
  Dio dio = Dio();
  try {
    final result = await dio.post('${apiLink}login');
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [504];
  }
}

Future<List> postRequest(link,da) async {
  Dio dio = Dio();
  try {
    final result = await dio.post(link);
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [504];
  }
}

void main(List<String> args) async {
  print(await postRequest('${apiLink}login',));
}
