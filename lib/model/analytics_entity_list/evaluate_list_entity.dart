import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/evaluate_list_entity.g.dart';

export 'package:flutter_report_project/generated/json/evaluate_list_entity.g.dart';

@JsonSerializable()
class EvaluateListEntity {
  EvaluateListPage? page;
  List<EvaluateListList>? list;

  EvaluateListEntity();

  factory EvaluateListEntity.fromJson(Map<String, dynamic> json) => $EvaluateListEntityFromJson(json);

  Map<String, dynamic> toJson() => $EvaluateListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class EvaluateListPage {
  int total = 0;
  int pageNo = 0;
  int pageSize = 0;
  int pageCount = 0;

  EvaluateListPage();

  factory EvaluateListPage.fromJson(Map<String, dynamic> json) => $EvaluateListPageFromJson(json);

  Map<String, dynamic> toJson() => $EvaluateListPageToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class EvaluateListList {
  String? guestName;
  String? commentTime;
  int score = 0;
  String? shopName;
  String? content;
  List<String>? reply;
  List<String>? pictures;
  String? avatarPicture;

  EvaluateListList();

  factory EvaluateListList.fromJson(Map<String, dynamic> json) => $EvaluateListListFromJson(json);

  Map<String, dynamic> toJson() => $EvaluateListListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
