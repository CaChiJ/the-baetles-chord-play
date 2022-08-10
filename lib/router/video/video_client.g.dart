// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _VideoClient implements VideoClient {
  _VideoClient(this._dio, {this.baseUrl}) {
    baseUrl ??=
        'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/watch-history';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<GetVideoGradeCollectionResponse> getWatchHistory(
      performerGrade) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'performerGrade': performerGrade
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetVideoGradeCollectionResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'grade-collection',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetVideoGradeCollectionResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
