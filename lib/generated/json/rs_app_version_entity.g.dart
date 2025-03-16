import 'package:flutter_report_project/generated/json/base/json_convert_content.dart';
import 'package:flutter_report_project/utils/version_check/rs_app_version_entity.dart';

RSAppVersionEntity $RSAppVersionEntityFromJson(Map<String, dynamic> json) {
  final RSAppVersionEntity rSAppVersionEntity = RSAppVersionEntity();
  final String? requestId = jsonConvert.convert<String>(json['request_id']);
  if (requestId != null) {
    rSAppVersionEntity.requestId = requestId;
  }
  final String? appType = jsonConvert.convert<String>(json['app_type']);
  if (appType != null) {
    rSAppVersionEntity.appType = appType;
  }
  final String? appSubType = jsonConvert.convert<String>(json['app_sub_type']);
  if (appSubType != null) {
    rSAppVersionEntity.appSubType = appSubType;
  }
  final String? os = jsonConvert.convert<String>(json['os']);
  if (os != null) {
    rSAppVersionEntity.os = os;
  }
  final String? osArch = jsonConvert.convert<String>(json['os_arch']);
  if (osArch != null) {
    rSAppVersionEntity.osArch = osArch;
  }
  final String? osVersion = jsonConvert.convert<String>(json['os_version']);
  if (osVersion != null) {
    rSAppVersionEntity.osVersion = osVersion;
  }
  final String? packageType = jsonConvert.convert<String>(json['package_type']);
  if (packageType != null) {
    rSAppVersionEntity.packageType = packageType;
  }
  final String? currentVersion = jsonConvert.convert<String>(json['current_version']);
  if (currentVersion != null) {
    rSAppVersionEntity.currentVersion = currentVersion;
  }
  final int? versionCode = jsonConvert.convert<int>(json['version_code']);
  if (versionCode != null) {
    rSAppVersionEntity.versionCode = versionCode;
  }
  final String? previousVersion = jsonConvert.convert<String>(json['previous_version']);
  if (previousVersion != null) {
    rSAppVersionEntity.previousVersion = previousVersion;
  }
  final String? nextVersion = jsonConvert.convert<String>(json['next_version']);
  if (nextVersion != null) {
    rSAppVersionEntity.nextVersion = nextVersion;
  }
  final List<RSAppVersionVersions>? versions = (json['versions'] as List<dynamic>?)
      ?.map((e) => jsonConvert.convert<RSAppVersionVersions>(e) as RSAppVersionVersions)
      .toList();
  if (versions != null) {
    rSAppVersionEntity.versions = versions;
  }
  return rSAppVersionEntity;
}

Map<String, dynamic> $RSAppVersionEntityToJson(RSAppVersionEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['request_id'] = entity.requestId;
  data['app_type'] = entity.appType;
  data['app_sub_type'] = entity.appSubType;
  data['os'] = entity.os;
  data['os_arch'] = entity.osArch;
  data['os_version'] = entity.osVersion;
  data['package_type'] = entity.packageType;
  data['current_version'] = entity.currentVersion;
  data['version_code'] = entity.versionCode;
  data['previous_version'] = entity.previousVersion;
  data['next_version'] = entity.nextVersion;
  data['versions'] = entity.versions?.map((v) => v.toJson()).toList();
  return data;
}

extension RSAppVersionEntityExtension on RSAppVersionEntity {
  RSAppVersionEntity copyWith({
    String? requestId,
    String? appType,
    String? appSubType,
    String? os,
    String? osArch,
    String? osVersion,
    String? packageType,
    String? currentVersion,
    int? versionCode,
    String? previousVersion,
    String? nextVersion,
    List<RSAppVersionVersions>? versions,
  }) {
    return RSAppVersionEntity()
      ..requestId = requestId ?? this.requestId
      ..appType = appType ?? this.appType
      ..appSubType = appSubType ?? this.appSubType
      ..os = os ?? this.os
      ..osArch = osArch ?? this.osArch
      ..osVersion = osVersion ?? this.osVersion
      ..packageType = packageType ?? this.packageType
      ..currentVersion = currentVersion ?? this.currentVersion
      ..versionCode = versionCode ?? this.versionCode
      ..previousVersion = previousVersion ?? this.previousVersion
      ..nextVersion = nextVersion ?? this.nextVersion
      ..versions = versions ?? this.versions;
  }
}

RSAppVersionVersions $RSAppVersionVersionsFromJson(Map<String, dynamic> json) {
  final RSAppVersionVersions rSAppVersionVersions = RSAppVersionVersions();
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    rSAppVersionVersions.version = version;
  }
  final String? releaseDate = jsonConvert.convert<String>(json['release_date']);
  if (releaseDate != null) {
    rSAppVersionVersions.releaseDate = releaseDate;
  }
  final String? releaseNote = jsonConvert.convert<String>(json['release_note']);
  if (releaseNote != null) {
    rSAppVersionVersions.releaseNote = releaseNote;
  }
  final String? downloadUrl = jsonConvert.convert<String>(json['download_url']);
  if (downloadUrl != null) {
    rSAppVersionVersions.downloadUrl = downloadUrl;
  }
  final String? packageName = jsonConvert.convert<String>(json['package_name']);
  if (packageName != null) {
    rSAppVersionVersions.packageName = packageName;
  }
  final int? packageSize = jsonConvert.convert<int>(json['package_size']);
  if (packageSize != null) {
    rSAppVersionVersions.packageSize = packageSize;
  }
  final String? md5 = jsonConvert.convert<String>(json['md5']);
  if (md5 != null) {
    rSAppVersionVersions.md5 = md5;
  }
  final String? minVersion = jsonConvert.convert<String>(json['min_version']);
  if (minVersion != null) {
    rSAppVersionVersions.minVersion = minVersion;
  }
  final bool? forceUpgrade = jsonConvert.convert<bool>(json['force_upgrade']);
  if (forceUpgrade != null) {
    rSAppVersionVersions.forceUpgrade = forceUpgrade;
  }
  final String? forceDeadlineAt = jsonConvert.convert<String>(json['force_deadline_at']);
  if (forceDeadlineAt != null) {
    rSAppVersionVersions.forceDeadlineAt = forceDeadlineAt;
  }
  final int? versionCode = jsonConvert.convert<int>(json['version_code']);
  if (versionCode != null) {
    rSAppVersionVersions.versionCode = versionCode;
  }
  return rSAppVersionVersions;
}

Map<String, dynamic> $RSAppVersionVersionsToJson(RSAppVersionVersions entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['version'] = entity.version;
  data['release_date'] = entity.releaseDate;
  data['release_note'] = entity.releaseNote;
  data['download_url'] = entity.downloadUrl;
  data['package_name'] = entity.packageName;
  data['package_size'] = entity.packageSize;
  data['md5'] = entity.md5;
  data['min_version'] = entity.minVersion;
  data['force_upgrade'] = entity.forceUpgrade;
  data['force_deadline_at'] = entity.forceDeadlineAt;
  data['version_code'] = entity.versionCode;
  return data;
}

extension RSAppVersionVersionsExtension on RSAppVersionVersions {
  RSAppVersionVersions copyWith({
    String? version,
    String? releaseDate,
    String? releaseNote,
    String? downloadUrl,
    String? packageName,
    int? packageSize,
    String? md5,
    String? minVersion,
    bool? forceUpgrade,
    String? forceDeadlineAt,
    int? versionCode,
  }) {
    return RSAppVersionVersions()
      ..version = version ?? this.version
      ..releaseDate = releaseDate ?? this.releaseDate
      ..releaseNote = releaseNote ?? this.releaseNote
      ..downloadUrl = downloadUrl ?? this.downloadUrl
      ..packageName = packageName ?? this.packageName
      ..packageSize = packageSize ?? this.packageSize
      ..md5 = md5 ?? this.md5
      ..minVersion = minVersion ?? this.minVersion
      ..forceUpgrade = forceUpgrade ?? this.forceUpgrade
      ..forceDeadlineAt = forceDeadlineAt ?? this.forceDeadlineAt
      ..versionCode = versionCode ?? this.versionCode;
  }
}
