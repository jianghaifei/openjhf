import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:r_upgrade/r_upgrade.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/network/exception.dart';
import '../../../../utils/version_check/rs_app_version_entity.dart';
import '../../../../utils/version_check/version_check.dart';
import '../../../../widget/card_load_state_layout.dart';
import 'version_update_state.dart';

// 应用包类型	 枚举: setup,upgrade
enum RSUpgradePackageTye {
  setup,
  upgrade,
}

// TODO: 此处修改是否切换app内升级
class VersionUpdateLogic extends GetxController {
  final VersionUpdateState state = VersionUpdateState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> loadRequest() async {
    state.loadState.value = CardLoadState.stateLoading;

    RSAPPVersionCheck.checkOfficialPlatform((ApiException? error, RSAppVersionEntity? entity) async {
      if (entity != null) {
        state.loadState.value = CardLoadState.stateSuccess;
        if (entity.nextVersion != null && entity.nextVersion!.isNotEmpty && entity.versions != null) {
          var tmpVersionEntity = entity.versions?.firstWhere((e) => e.version == entity.nextVersion);
          if (tmpVersionEntity != null) {
            state.versionEntity.value = tmpVersionEntity;
            // 是否已下载过
            getLastUpgradeId();
          }
        }
      } else {
        state.loadState.value = CardLoadState.stateError;
        state.errorCode = error?.code;
        state.errorMessage = error?.message;
      }
    });
  }

  // 立即更新按钮
  Future<void> updateNow({int? existDownloadId}) async {
    streamListen();

    if (existDownloadId != null) {
      var status = await getDownloadStatus(existDownloadId);
      if (status != null) {
        state.downloadStatus.value = status;
        debugPrint("已存在的下载状态：$status");
        getCurrentTitle(state.isStartDownload.value, state.downloadStatus.value);
      }
    }

    var downloadId = existDownloadId ?? await upgradeAction(state.versionEntity.value);
    if (downloadId != null) {
      state.downloadId.value = downloadId;
    } else {
      EasyLoading.showError('下载出错');
      state.isStartDownload.value = false;
    }
  }

  // 下载流监听
  void streamListen() {
    if (!state.isStartDownload.value) {
      state.isStartDownload.value = true;
      RUpgrade.stream.listen((DownloadInfo info) {
        if (info.status != null) {
          state.downloadStatus.value = info.status!;
        }

        if (info.status == DownloadStatus.STATUS_RUNNING) {
          // 赋值下载进度
          state.downloadCurrentLength.value = (info.currentLength ?? 0) / (1024 * 1024);
          state.downloadMaxLength.value = (info.maxLength ?? 0) / (1024 * 1024);

          state.downloadProgress.value = ((info.currentLength ?? 0) >= (info.maxLength ?? 0))
              ? 1
              : (info.currentLength ?? 0) / (info.maxLength ?? 0);
        } else if (info.status == DownloadStatus.STATUS_SUCCESSFUL) {
          state.downloadCurrentLength.value = state.downloadMaxLength.value;

          state.downloadProgress.value = 1;
        }
      });
    }
  }

  // 下载操作
  Future<int?> upgradeAction(RSAppVersionVersions? versionEntity) async {
    // 清理下载文件目录
    cleanDownloadFolder();

    int? id = await RUpgrade.upgrade(
      versionEntity?.downloadUrl ?? '',
      fileName: versionEntity?.packageName ?? '',
      installType: RUpgradeInstallType.none,
      notificationVisibility: NotificationVisibility.VISIBILITY_HIDDEN,
      notificationStyle: NotificationStyle.none,
    );

    return id;
  }

  // 获取最后一次下载的ID（该方法只会寻找当前应用版本名和版本号下下载过的ID）
  void getLastUpgradeId() async {
    int? id = await RUpgrade.getLastUpgradedId();

    debugPrint("是否已存在已下载的id: $id");
    if (id != null) {
      updateNow(existDownloadId: id);
    }
  }

  // 获取ID对应的下载状态
  Future<DownloadStatus?> getDownloadStatus(int id) async {
    DownloadStatus? status = await RUpgrade.getDownloadStatus(id);
    return status;
  }

  // 清理下载文件夹
  Future<void> cleanDownloadFolder() async {
    try {
      // 获取下载目录
      Directory? downloadsDirectory = await getExternalStorageDirectory();

      // 指定下载文件夹路径
      String downloadPath = '${downloadsDirectory?.path}/Download';
      final downloadDir = Directory(downloadPath);

      // 检查目录是否存在
      if (await downloadDir.exists()) {
        // 获取下载目录下的所有文件
        List<FileSystemEntity> files = downloadDir.listSync();

        // 删除所有文件
        for (FileSystemEntity file in files) {
          if (file is File) {
            await file.delete();
            debugPrint('已删除文件: ${file.path}');
          }
        }
        debugPrint('Download文件夹已清理');
      } else {
        debugPrint('Download文件夹不存在');
      }
    } catch (e) {
      debugPrint('清理文件夹时出错: $e');
    }
  }

  String getCurrentTitle(bool isStart, DownloadStatus downloadStatus) {
    if (isStart) {
      String title = '';
      switch (downloadStatus) {
        case DownloadStatus.STATUS_CANCEL:
          title = S.current.rs_update_download_canceled_re_download;
          cleanDownloadFolder();
          break;
        case DownloadStatus.STATUS_FAILED:
          title = S.current.rs_update_download_failed_re_download;
          cleanDownloadFolder();
          break;
        case DownloadStatus.STATUS_PAUSED:
          title = S.current.rs_update_continue_download;
          break;
        case DownloadStatus.STATUS_PENDING:
          title = '${S.current.rs_update_waiting_download}...';
          break;
        case DownloadStatus.STATUS_RUNNING:
          title = S.current.rs_update_paused;
          break;
        case DownloadStatus.STATUS_SUCCESSFUL:
          title = S.current.rs_update_install;
          break;
      }
      return title;
    } else {
      return S.current.rs_update_update_now;
    }
  }

  void clickAction(DownloadStatus downloadStatus) async {
    if (state.isStartDownload.value) {
      switch (downloadStatus) {
        case DownloadStatus.STATUS_CANCEL:
          updateNow();
          break;
        case DownloadStatus.STATUS_FAILED:
          updateNow();
          break;
        case DownloadStatus.STATUS_PAUSED:
          await RUpgrade.upgradeWithId(state.downloadId.value);
          // 返回 false 即表示从来不存在此ID
          // 返回 true
          //    调用此方法前状态为 [STATUS_PAUSED]、[STATUS_FAILED]、[STATUS_CANCEL],将继续下载
          //    调用此方法前状态为 [STATUS_RUNNING]、[STATUS_PENDING]，不会发生任何变化
          //    调用此方法前状态为 [STATUS_SUCCESSFUL]，将会安装应用
          // 当文件被删除时，重新下载
          break;
        case DownloadStatus.STATUS_PENDING:
          await RUpgrade.cancel(state.downloadId.value);
          break;
        case DownloadStatus.STATUS_RUNNING:
          await RUpgrade.pause(state.downloadId.value);
          break;
        case DownloadStatus.STATUS_SUCCESSFUL:
          await RUpgrade.install(state.downloadId.value);
          break;
      }
    } else {
      updateNow();
    }
  }
}
