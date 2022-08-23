import 'dart:async';

import 'package:the_baetles_chord_play/model/api/response/sheet/get_condition_sheet_response.dart';
import 'package:the_baetles_chord_play/model/api/response/sheet/get_sheet_data_response.dart';
import 'package:the_baetles_chord_play/model/api/response/sheet/post_sheet_data_response.dart';
import 'package:the_baetles_chord_play/model/schema/sheet/sheet_data_schema.dart';
import 'package:the_baetles_chord_play/router/client.dart';
import 'package:the_baetles_chord_play/router/rest_client_factory.dart';

import '../../domain/model/sheet_data.dart';
import '../../domain/model/sheet_info.dart';
import '../../model/api/request/sheet/post_sheet_request.dart' as post_sheet;
import '../../model/api/request/sheet/post_sheet_request.dart';
import '../../model/api/request/sheet/post_sheet_data_request.dart' as post_sheet_data;
import '../../model/api/request/sheet/post_sheet_data_request.dart';
import '../../model/api/response/sheet/post_sheet_response.dart';
import '../../router/sheet/sheet_client.dart';
import '../../router/sheet/sheet_client.dart';

class SheetRepository {
  static final SheetRepository _instance = SheetRepository._internal();

  factory SheetRepository() {
    return _instance;
  }

  SheetRepository._internal();

  Future<Map<String, List<SheetInfo>>> fetchSheetsByVideoId(String videoId) async {
    SheetClient client = RestClientFactory().getClient(RestClientType.sheet) as SheetClient;
    GetConditionSheetResponse response = await client.getSheetsByVideoId(videoId);
    Map<String, List<SheetInfo>> sheets = response.data!.toMap();

    return sheets;
  }

  Future<SheetData?> fetchSheetDataBySheetId(String sheetId) async {
    SheetClient client = RestClientFactory().getClient(RestClientType.sheet) as SheetClient;
    GetSheetDataResponse response = await client.getSheetData(sheetId);
    SheetData? sheetData;

    if (response.code == "200") {
      sheetData = response.toSheetData();
    }

    return sheetData;
  }

  Future<String?> createSheet(String videoId, String title, SheetData sheetData) async {
    SheetInfo? sheetInfo = await createSheetInfo(videoId, title);

    if (sheetInfo == null) {
      return null;
    }

    String? sheetId = await createSheetData(videoId, title, sheetData);

    return sheetId; // return null when fail creation
  }

  Future<SheetInfo?> createSheetInfo(String videoId, String title) async {
    SheetClient client = RestClientFactory().getClient(RestClientType.sheet) as SheetClient;

    PostSheetResponse response = await client.postSheet(
      post_sheet.PostSheetRequest(
        requestSheetInfo: post_sheet.RequestSheetInfo(
            videoId: videoId, title: title),
      ),
    );

    return response.data?.toSheetInfo();
  }

  Future<String?> createSheetData(String videoId, String title, SheetData sheetData) async {
    SheetClient client = RestClientFactory().getClient(RestClientType.sheet) as SheetClient;

    PostSheetDataResponse response = await client.postSheetData(
      post_sheet_data.PostSheetDataRequest(
        sheetData: SheetDataSchema.fromSheetData(sheetData),
        sheet: post_sheet_data.RequestSheetInfo(
          videoId: videoId,
          title: title,
        ),
      ),
    );

    String? sheetId = response.data;
    return sheetId;
  }
}
