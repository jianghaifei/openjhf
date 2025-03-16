import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import '../../network/app_compile_env.dart';
import '../../network/server_url.dart';

class DebugSwitchEnvDialog extends StatefulWidget {
  const DebugSwitchEnvDialog({super.key});

  @override
  State<DebugSwitchEnvDialog> createState() => _DebugSwitchEnvDialogState();
}

class _DebugSwitchEnvDialogState extends State<DebugSwitchEnvDialog> {
  @override
  Widget build(BuildContext context) {
    String currentEv = RSAppCompileEnv.getCurrentEnvTypeString();

    bool onOff = SpUtil.getBool(RSAppCompileEnv.appCompileEnvDebugKey, defValue: false) ?? false;

    return Center(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular((10.0)), // 圆角度
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "当前环境：$currentEv",
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "开启Debug模式\n回到首页切换即可",
              style: TextStyle(fontSize: 15, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Switch(
                value: onOff,
                onChanged: (v) async {
                  if (!v) {
                    // 恢复默认
                    RSAppCompileEnv.resetEnvString();
                    // 初始化APP域名配置
                    await RSServerUrl.initDomainUrl();
                  }
                  setState(() {
                    RSAppCompileEnv.modifyEnvDebugModel(v);
                    onOff = v;
                  });
                }),
          )
        ],
      ),
    ));
  }
}
