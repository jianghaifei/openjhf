import 'package:flustars/flustars.dart';

import '../generated/l10n.dart';

class RSIdentify {
  static const String boss = 'rs_boss';
  static const String shopManager = 'rs_shop_manager';
  static const String scmManager = 'rs_scm_manager';

  static final Map<String,dynamic> identifyUI = {
    boss: {
      "key": boss,
      "img": 'assets/image/id_boss.png',
      'title': S.current.rs_identity_i_am_boss,
      'desc': S.current.rs_identity_i_am_boss_desc,
      "name": S.current.rs_identity_boss,
      'bkColor':[0xFFFFF2C0,0xFFFFE484],
      'borderColor':[0xFFFFE68C,0xFFFFF2BD],
      "tagColor":[0xFFFFF2BF,0xFFFFE585],
    },
    shopManager: {
      "key": shopManager,
      "img": 'assets/image/id_shop_m.png',
      'title': S.current.rs_identity_i_am_shop_administrator,
      'desc': S.current.rs_identity_i_am_shop_administrator_desc,
      "name":S.current.rs_identity_shop_administrator,
      'bkColor':[0xFFFFEACF,0xFFFFD6B2],
      'borderColor':[0xFFFFD7B3,0xFFFFEACE],
      "tagColor":[0xFFFFE9CE,0xFFFFD6B3],
    },
    scmManager: {
      "key": scmManager,
      "img": 'assets/image/id_scm_m.png',
      'title': S.current.rs_identity_i_am_supply_chain_coordinator,
      'desc': S.current.rs_identity_i_am_supply_chain_coordinator_desc,
      'name': S.current.rs_identity_supply_chain_coordinator,
      'bkColor':[0xFFE6ECFF,0xFFCEDAFF],
      'borderColor':[0xFFCEDAFF,0xFFE5ECFF],
      "tagColor":[0xFFE5EBFF,0xFFCEDAFF],
    },
  };



  static const String _identifyStoreKey = 'rs_identify';

  static String getIdentify() {
    return SpUtil.getString(_identifyStoreKey,defValue: '') ?? '';
  }

  static Future<bool>? changeIdentify(String identify) {
    if(identify != boss && identify != scmManager) {
      throw ArgumentError('Invalid identify');
    }
    return SpUtil.putString(_identifyStoreKey, identify);
  }
}