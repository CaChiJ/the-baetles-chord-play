// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chord_info_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChordInfoSchema _$ChordInfoSchemaFromJson(Map<String, dynamic> json) =>
    ChordInfoSchema(
      chord: json['chord'] as String,
      start: json['start'] as int,
      end: json['end'] as int,
      position: json['position'] as int,
    );

Map<String, dynamic> _$ChordInfoSchemaToJson(ChordInfoSchema instance) =>
    <String, dynamic>{
      'chord': instance.chord,
      'start': instance.start,
      'end': instance.end,
      'position': instance.position,
    };
