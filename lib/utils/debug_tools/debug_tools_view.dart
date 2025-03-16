import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/debug_tools/widget/debug_network_dialog.dart';
import 'package:flutter_report_project/utils/debug_tools/widget/debug_switch_env_dialog.dart';
import 'package:get/get.dart';

import 'debug_tools_logic.dart';

const openDebugToolsTriggerTime = kDebugMode ? 2 : 10;

class DebugToolsPage extends StatefulWidget {
  const DebugToolsPage({super.key});

  @override
  State<DebugToolsPage> createState() => _DebugToolsPageState();
}

class _DebugToolsPageState extends State<DebugToolsPage> {
  final logic = Get.put(DebugToolsLogic());
  final state = Get.find<DebugToolsLogic>().state;

  static const String charlesNetwork = "CharlesNetwork";

  @override
  void dispose() {
    Get.delete<DebugToolsLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Tools'),
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //横轴三个子widget
          childAspectRatio: 1.0, //子widget宽高比例
        ),
        children: [
          _createItemWidget(Icons.wifi, '抓包'),
          _createItemWidget(Icons.switch_camera_outlined, '切换环境'),
        ],
      ),
    );
  }

  Widget _createItemWidget(IconData iconData, String title) {
    return InkWell(
      onTap: () => _clickAction(title),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(iconData),
            const SizedBox(
              height: 8,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  void _clickAction(String action) async {
    switch (action) {
      case '抓包':
        var tmpString = _getLocalProxy();
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          DebugNetworkDialog().showDebugNetworkDialog(context,
              title: tmpString ?? '输入ip', placeholderText: '示例：172.16.33.85:8888', resetCallback: () {
            dataStorageAction(true);
          }, doneCallback: (value) {
            dataStorageAction(false, value: value);
          });
        });

        break;
      case '切换环境':
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Get.dialog(const DebugSwitchEnvDialog());
        });

        break;

      default:
        EasyLoading.showToast('method not found');
        break;
    }
  }

  void dataStorageAction(bool isRemove, {String? value}) {
    if (isRemove) {
      SpUtil.remove(charlesNetwork);
    } else {
      SpUtil.putString(charlesNetwork, value!);
    }
    EasyLoading.show(status: '即将关闭APP');
    Future.delayed(const Duration(seconds: 2), () {
      exit(0);
    });
  }

  String? _getLocalProxy() {
    debugPrint("ip = ${SpUtil.getString(charlesNetwork)}");
    return SpUtil.getString(charlesNetwork, defValue: null);
  }
}
