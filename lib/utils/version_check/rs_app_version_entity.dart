import 'dart:convert';

import 'package:flutter_report_project/generated/json/base/json_field.dart';
import 'package:flutter_report_project/generated/json/rs_app_version_entity.g.dart';

@JsonSerializable()
class RSAppVersionEntity {
  @JSONField(name: "request_id")
  String? requestId;
  @JSONField(name: "app_type")
  String? appType;
  @JSONField(name: "app_sub_type")
  String? appSubType;
  String? os;
  @JSONField(name: "os_arch")
  String? osArch;
  @JSONField(name: "os_version")
  String? osVersion;
  @JSONField(name: "package_type")
  String? packageType;
  @JSONField(name: "current_version")
  String? currentVersion;
  @JSONField(name: "version_code")
  int? versionCode;
  @JSONField(name: "previous_version")
  String? previousVersion;
  @JSONField(name: "next_version")
  String? nextVersion;
  List<RSAppVersionVersions>? versions;

  RSAppVersionEntity();

  factory RSAppVersionEntity.fromJson(Map<String, dynamic> json) => $RSAppVersionEntityFromJson(json);

  Map<String, dynamic> toJson() => $RSAppVersionEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class RSAppVersionVersions {
  String? version;
  @JSONField(name: "release_date")
  String? releaseDate;
  @JSONField(name: "release_note")
  String? releaseNote;
  @JSONField(name: "download_url")
  String? downloadUrl;
  @JSONField(name: "package_name")
  String? packageName;
  @JSONField(name: "package_size")
  int? packageSize;
  String? md5;
  @JSONField(name: "min_version")
  String? minVersion;
  @JSONField(name: "force_upgrade")
  bool forceUpgrade = false;
  @JSONField(name: "force_deadline_at")
  String? forceDeadlineAt;
  @JSONField(name: "version_code")
  int? versionCode;

  RSAppVersionVersions();

  factory RSAppVersionVersions.fromJson(Map<String, dynamic> json) => $RSAppVersionVersionsFromJson(json);

  Map<String, dynamic> toJson() => $RSAppVersionVersionsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
