import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:the_baetles_chord_play/model/api/request/request.dart';

import '../../../../domain/model/chord.dart';
import '../../../schema/sheet/chord_schema.dart';

part 'patch_sheet_data_request.g.dart';

@JsonSerializable()
class PatchSheetDataRequest extends Request {
  @JsonKey(name: 'position')
  int position;

  @JsonKey(name: 'chord')
  ChordSchema chord;

  PatchSheetDataRequest({required this.position, required this.chord});
  factory PatchSheetDataRequest.fromJson(Map<String, dynamic> json) => _$PatchSheetDataRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PatchSheetDataRequestToJson(this);
}