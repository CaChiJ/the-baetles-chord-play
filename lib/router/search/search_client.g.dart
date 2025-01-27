// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _SearchClient implements SearchClient {
  _SearchClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<GetSearchResponse> getSearchList(searchTitle) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'searchTitle': searchTitle};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GetSearchResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/videos/search/',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetSearchResponse.fromJson(_result.data!);
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
