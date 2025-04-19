import 'package:dio/dio.dart';

/*
  This abstracts HTTP logic.
  Dynamic means its not type-restricted, so it can be <url, JSON-object>
 */

class RemoteService {
  final Dio _dio;
  RemoteService(this._dio);

  Future<Response> post(
      String path,
      Map<String, dynamic> body) =>
      _dio.post(
        path,
        data: body
      );
}