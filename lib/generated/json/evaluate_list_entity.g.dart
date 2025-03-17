import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/model/analytics_entity_list/evaluate_list_entity.dart';

EvaluateListEntity $EvaluateListEntityFromJson(Map<String, dynamic> json) {
  final EvaluateListEntity evaluateListEntity = EvaluateListEntity();
  final EvaluateListPage? page = jsonConvert.convert<EvaluateListPage>(json['page']);
  if (page != null) {
    evaluateListEntity.page = page;
  }
  final List<EvaluateListList>? list = (json['list'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<EvaluateListList>(e) as EvaluateListList)
      .toList();
  if (list != null) {
    evaluateListEntity.list = list;
  }
  return evaluateListEntity;
}

Map<String, dynamic> $EvaluateListEntityToJson(EvaluateListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['page'] = entity.page?.toJson();
  data['list'] = entity.list?.map((v) => v.toJson()).toList();
  return data;
}

extension EvaluateListEntityExtension on EvaluateListEntity {
  EvaluateListEntity copyWith({
    EvaluateListPage? page,
    List<EvaluateListList>? list,
  }) {
    return EvaluateListEntity()
      ..page = page ?? this.page
      ..list = list ?? this.list;
  }
}

EvaluateListPage $EvaluateListPageFromJson(Map<String, dynamic> json) {
  final EvaluateListPage evaluateListPage = EvaluateListPage();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    evaluateListPage.total = total;
  }
  final int? pageNo = jsonConvert.convert<int>(json['pageNo']);
  if (pageNo != null) {
    evaluateListPage.pageNo = pageNo;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    evaluateListPage.pageSize = pageSize;
  }
  final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
  if (pageCount != null) {
    evaluateListPage.pageCount = pageCount;
  }
  return evaluateListPage;
}

Map<String, dynamic> $EvaluateListPageToJson(EvaluateListPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['pageNo'] = entity.pageNo;
  data['pageSize'] = entity.pageSize;
  data['pageCount'] = entity.pageCount;
  return data;
}

extension EvaluateListPageExtension on EvaluateListPage {
  EvaluateListPage copyWith({
    int? total,
    int? pageNo,
    int? pageSize,
    int? pageCount,
  }) {
    return EvaluateListPage()
      ..total = total ?? this.total
      ..pageNo = pageNo ?? this.pageNo
      ..pageSize = pageSize ?? this.pageSize
      ..pageCount = pageCount ?? this.pageCount;
  }
}

EvaluateListList $EvaluateListListFromJson(Map<String, dynamic> json) {
  final EvaluateListList evaluateListList = EvaluateListList();
  final String? guestName = jsonConvert.convert<String>(json['guestName']);
  if (guestName != null) {
    evaluateListList.guestName = guestName;
  }
  final String? commentTime = jsonConvert.convert<String>(json['commentTime']);
  if (commentTime != null) {
    evaluateListList.commentTime = commentTime;
  }
  final int? score = jsonConvert.convert<int>(json['score']);
  if (score != null) {
    evaluateListList.score = score;
  }
  final String? shopName = jsonConvert.convert<String>(json['shopName']);
  if (shopName != null) {
    evaluateListList.shopName = shopName;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    evaluateListList.content = content;
  }
  final List<String>? reply =
      (json['reply'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (reply != null) {
    evaluateListList.reply = reply;
  }
  final List<String>? pictures =
      (json['pictures'] as List<dynamic>?)?.map((e) => jsonConvert.convert<String>(e) as String).toList();
  if (pictures != null) {
    evaluateListList.pictures = pictures;
  }
  final String? avatarPicture = jsonConvert.convert<String>(json['avatarPicture']);
  if (avatarPicture != null) {
    evaluateListList.avatarPicture = avatarPicture;
  }
  return evaluateListList;
}

Map<String, dynamic> $EvaluateListListToJson(EvaluateListList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['guestName'] = entity.guestName;
  data['commentTime'] = entity.commentTime;
  data['score'] = entity.score;
  data['shopName'] = entity.shopName;
  data['content'] = entity.content;
  data['reply'] = entity.reply;
  data['pictures'] = entity.pictures;
  data['avatarPicture'] = entity.avatarPicture;
  return data;
}

extension EvaluateListListExtension on EvaluateListList {
  EvaluateListList copyWith({
    String? guestName,
    String? commentTime,
    int? score,
    String? shopName,
    String? content,
    List<String>? reply,
    List<String>? pictures,
    String? avatarPicture,
  }) {
    return EvaluateListList()
      ..guestName = guestName ?? this.guestName
      ..commentTime = commentTime ?? this.commentTime
      ..score = score ?? this.score
      ..shopName = shopName ?? this.shopName
      ..content = content ?? this.content
      ..reply = reply ?? this.reply
      ..pictures = pictures ?? this.pictures
      ..avatarPicture = avatarPicture ?? this.avatarPicture;
  }
}
