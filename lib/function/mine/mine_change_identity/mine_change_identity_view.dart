import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/index.dart';
import 'package:flutter_report_project/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RSMineChangeIdentityPage extends StatefulWidget {
  const RSMineChangeIdentityPage({super.key});

  @override
  RSMineChangeIdentityPageState createState() {
    return RSMineChangeIdentityPageState();
  }
}

class RSMineChangeIdentityPageState extends State<RSMineChangeIdentityPage> {
  RSMineChangeIdentityPageState();

  String currentIdentity = RSIdentify.getIdentify();
  bool loading = false;

  Widget renderIdentityCard(Map<String, dynamic> map) {
    return InkWell(
        onTap: () async {
          if (loading) {
            return;
          }
          EasyLoading.show();
          await RSIdentify.changeIdentify(map['key']);
          // 去首页
          Get.offAllNamed(AppRoutes.mainPage);
          setState(() {
            loading = true;
          });
          EasyLoading.dismiss();
        },
        child: Container(
          height: 100,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: currentIdentity == map['key']
                ? RSColor.color_0xFF5C57E6
                : null,
            gradient: currentIdentity == map['key'] ? null: LinearGradient(
              colors: [
                Color(map['borderColor'][0]),
                Color(map['borderColor'][1])
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Color(map['bkColor'][0]), Color(map['bkColor'][1])],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 23,
                    ),
                    Image.asset(
                      map['img'],
                      width: 52,
                      height: 52,
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              map['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              map["desc"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(0, 0, 0, 0.45),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
                currentIdentity == map['key'] ? Positioned(child: Image.asset('assets/image/id_sel.png',width: 28,height: 28,),right: 0,top: 0,): Container()
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.rs_change_identity),
      ),
      body: ListView(
        children: <Widget>[
          renderIdentityCard(RSIdentify.identifyUI[RSIdentify.boss]),
          // renderIdentityCard(RSIdentify.identifyUI[RSIdentify.shopManager]),
          renderIdentityCard(RSIdentify.identifyUI[RSIdentify.scmManager]),
        ],
      ),
    );
  }
}
