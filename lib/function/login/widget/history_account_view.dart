import 'package:flutter/material.dart';
import 'package:flutter_report_project/function/login/account_manager/history_account_manager.dart';
import 'package:flutter_report_project/function/login/login_state.dart';

import '../../../config/rs_color.dart';
import '../../../generated/assets.dart';

typedef SelectCallBack = Function(String string);

class HistoryAccountView extends StatefulWidget {
  const HistoryAccountView(
      {super.key,
      required this.rect,
      required this.accountType,
      required this.selectCallBack,
      required this.delCallBack});

  final Rect rect;

  final LoginType accountType;

  final SelectCallBack selectCallBack;
  final VoidCallback delCallBack;

  @override
  State<HistoryAccountView> createState() => _HistoryAccountViewState();
}

class _HistoryAccountViewState extends State<HistoryAccountView> {
  double getMaxHeight() {
    int historyCount = HistoryAccountManager.getAccounts(widget.accountType).length;
    if (historyCount > 2) {
      return 54.0 * 2;
    }
    return 54.0 * historyCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 54, 0, 0),
      width: widget.rect.width,
      height: getMaxHeight(),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          // side: const BorderSide(width: 1, color: RSColor.color_0xFFBCBCC1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _createItemList(),
    );
  }

  Widget _createItemList() {
    List<Widget> list = [];

    var accounts = HistoryAccountManager.getAccounts(widget.accountType);

    for (var element in accounts) {
      bool isLast = false;
      if (element == accounts.last) {
        isLast = true;
      } else {
        isLast = false;
      }

      list.add(_createItem(element, isLast));
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: list,
        ),
      ),
    );
  }

  Widget _createItem(String account, bool isLast) {
    return InkWell(
      onTap: () {
        widget.selectCallBack.call(account);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(
              height: 54,
              child: Row(
                children: [
                  Expanded(
                    child: Text(account,
                        maxLines: 2,
                        style: TextStyle(
                          color: RSColor.color_0x90000000,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        HistoryAccountManager.delAccount(account, widget.accountType);
                        widget.delCallBack.call();
                      });
                    },
                    child: Image.asset(
                      Assets.imageCloseSmall,
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast)
              const Divider(
                height: 1,
                thickness: 1,
                color: RSColor.color_0xFFE7E7E7,
              ),
          ],
        ),
      ),
    );
  }
}
