import { message } from "antd";
import store from "../store";
import { changeLoginDialogVisible, getUserinfoByToken } from "../store/actions/Common";
import { sliceMenuId } from "../utils/utils";
import { queryRealNameInfo } from "../store/actions/User";

class NavigationController {
  static TOP_MENU_KEY() {
    return {
      SOLUTION: "1",
      RESOURCE: "2",
      DEVELOPER: "3",
      QUESTION: "4",
      QUESTION_SPECIAL: "5"
    };
  }

  static getTopMenuItems() {
    return [
      // {
      //   id: this.TOP_MENU_KEY().SOLUTION,
      //   text: "介绍",
      //   isPopOver: true
      // },
      {
        id: this.TOP_MENU_KEY().RESOURCE,
        text: "API 文档",
        to: "/resource"
      },
      {
        id: this.TOP_MENU_KEY().DEVELOPER,
        text: "控制台",
        to: "/user/developerAccount",
        isVerifyRealName: true
      },
      // {
      //   id: this.TOP_MENU_KEY().QUESTION,
      //   text: "帮助中心",
      //   to: "/question/flat"
      // }
      // {
      //   id: "8",
      //   text: "运营平台",
      //   to: "/operation"
      // },
    ];
  }

  static getNavigationItems() {
    return [
      {
        title: "外卖业务",
        root: "subpage",
        linkKey: "takeout",
        children: [
          {
            title: "外卖下单",
            root: "resource",
            linkKey: "TAKE_OUT_ORDER",
            isResourceId: true
          },
          // {
          // 	title: "配送同步",
          // 	root: "resource",
          // 	linkKey: "DISTRIBUTION_SYNCHRONIZED",
          // 	isResourceId: true
          // },
          {
            title: "菜品估清",
            root: "resource",
            linkKey: "DISHES_SOLD_OUTS",
            isResourceId: true
          },
          {
            title: "菜品管理",
            root: "resource",
            linkKey: "DISH_MANGEMENT",
            isResourceId: true
          },
          // {
          // 	title: "订单管理",
          // 	root: "resource",
          // 	linkKey: "ORDER_PAYMENT",
          // 	isResourceId: true
          // },
          {
            title: "门店管理",
            root: "resource",
            linkKey: "STORE_REPOTR",
            isResourceId: true
          }
        ]
      },
      {
        title: "到店餐饮",
        root: "subpage",
        linkKey: "shop",
        children: [
          {
            title: "扫码下单",
            root: "resource",
            linkKey: "CODE_SCANNING_ORDER",
            isResourceId: true
          },
          {
            title: "加菜和退菜",
            root: "resource",
            linkKey: "ADD_AND_RETURN",
            isResourceId: true
          },
          {
            title: "桌台管理",
            root: "resource",
            linkKey: "TABLE_MANAGEMENT",
            isResourceId: true
          },
          {
            title: "估清查询",
            root: "resource",
            linkKey: "DISHES_SOLD_OUT",
            isResourceId: true
          }
        ]
      },
      {
        title: "零售业务",
        root: "subpage",
        linkKey: "retail",
        children: [
          {
            title: "商品管理",
            root: "resource",
            linkKey: "GOODS_MANGEMENT",
            isResourceId: true
          },
          {
            title: "下单和支付",
            root: "resource",
            linkKey: "ORDER_PAY",
            isResourceId: true
          }
        ]
      },
      {
        title: "聚合配送",
        root: "subpage",
        linkKey: "distribution",
        children: [
          {
            title: "聚合配送",
            root: "resource",
            isResourceId: true,
            linkKey: "DISH_MARKETING"
          }
        ]
      },
      {
        title: "会员营销",
        root: "subpage",
        linkKey: "marketing",
        children: [
          {
            title: "商户会员卡",
            root: "resource",
            linkKey: "MERCHANT_CARD",
            isResourceId: true
          },
          {
            title: "营销活动",
            root: "resource",
            linkKey: "CARD_PROMOTION",
            isResourceId: true
          }
        ]
      },
      {
        title: "数据报表",
        root: "subpage",
        linkKey: "data",
        children: [
          {
            title: "账单实时推送",
            root: "resource",
            linkKey: "SHOP_BILL_PUSH",
            isResourceId: true
          },
          {
            title: "历史账单查询",
            root: "resource",
            linkKey: "BILL_QUERY",
            isResourceId: true
          },
          {
            title: "多维度数据报表",
            root: "resource",
            linkKey: "DATA_REPORT",
            isResourceId: true
          }
        ]
      },
      {
        title: "支付业务",
        root: "subpage",
        linkKey: "payment",
        children: [
          {
            title: "小程序支付",
            root: "resource",
            linkKey: "APPLET_PAYMENT",
            isResourceId: true
          },
          {
            title: "付款码支付",
            root: "resource",
            linkKey: "PAYMENT_CODE",
            isResourceId: true
          },
          {
            title: "扫码支付",
            root: "resource",
            linkKey: "CODE_SCANNING_PAYMENT",
            isResourceId: true
          }
        ]
      },
      {
        title: "热门能力",
        root: "",
        linkKey: "",
        children: [
          {
            title: "外卖业务",
            root: "subpage",
            linkKey: "takeout"
          },
          {
            title: "到店餐饮",
            root: "subpage",
            linkKey: "shop"
          },
          {
            title: "会员营销",
            root: "subpage",
            linkKey: "marketing"
          },
          {
            title: "聚合配送",
            root: "subpage",
            linkKey: "distribution"
          }
        ]
      },
      {
        title: "必读文档",
        root: "",
        linkKey: "",
        children: [
          {
            title: "服务协议",
            root: "resource",
            linkKey: "SERVICES_AGREEMENT",
            isResourceId: true
          },
          // {
          // 	title: "保密协议",
          // 	root: "resource",
          // 	linkKey: "CONFIDENTIALITY_AGREEMENT",
          // 	isResourceId: true
          // },
          // {
          // 	title: "保证金协议规则",
          // 	root: "resource",
          // 	linkKey: "MARGIN_AGREEMENT_RULES",
          // 	isResourceId: true
          // },
          {
            title: "开放平台运营管理规则",
            root: "resource",
            linkKey: "OPEN_PLATFORM_RULES",
            isResourceId: true
          },
          {
            title: "开发者指南",
            root: "resource",
            linkKey: "SETTLEMENT_PROCESS",
            isResourceId: true
          }
        ]
      }
    ];
  }

  static getTargetUrl({ root, linkKey, isResourceId }) {
    if (root && !linkKey) {
      return `/${root}`;
    }
    const { resourceIds } = store.getState().home;
    const newLinkKey = root === "resource" ? sliceMenuId(resourceIds[linkKey]) : resourceIds[linkKey];
    return isResourceId ? `/${root}/${newLinkKey}` : `/${root}/${linkKey}`;
  }

  static filterRouter(history, targetUrl) {
    if (!history || !targetUrl) return false;
    const { pathname } = history.location;
    if (pathname === targetUrl) return false;
    history.push(targetUrl);
  }

  /**
   * @description 验证是否登录
   * @param? isShowDialog 如果没登录是否显示登录框
   * */
  static verifyLogin(isShowDialog = false) {
    return new Promise(resolve => {
      const { isLogin } = store.getState().common;
      if (isLogin) return resolve(true);
      if (isShowDialog) {
        // 没登录需要弹登录框
        store.dispatch(changeLoginDialogVisible(true));
        return resolve(true);
      }
      if (!isShowDialog) {
        // 最简单验证
        return resolve(false);
      }
    });
  }

  /**
   * @description 自定义验证实名认证时返回的状态码
   * */
  static verifyRealNameStatus() {
    return {
      NO_LOGIN: 0, // 未登录
      NO_REAL_NAME: 1, // 未实名
      REAL_NAME: 2 // 已实名
    };
  }

  /**
   * @description 验证实名认证1
   * 此处只判断是否实名 不判断checkStatus具体状态 只需要知道是否实名,是否需要弹实名认证的框即可
   * 弹框具体显示的内容在header的RealNameDialog里自动判断
   * */
  static verifyRealName() {
    return new Promise(resolve => {
      const { isLogin } = store.getState().common;
      const { isRealName, checkStatus } = store.getState().user;
      // 未登录
      if (!isLogin) {
        message.warning("请先登录账号");
        resolve(this.verifyRealNameStatus().NO_LOGIN);
        return false;
      }
      // 未提交实名认证
      if (!isRealName && !checkStatus) {
        resolve(this.verifyRealNameStatus().NO_REAL_NAME);
        return false;
      }
      // 提交实名认证 但还未认证成功
      if (!isRealName && checkStatus) {
        resolve(this.verifyRealNameStatus().NO_REAL_NAME);
        return false;
      }
      // 认证成功
      if (isRealName && checkStatus === 3) {
        resolve(this.verifyRealNameStatus().REAL_NAME);
      }
    });
  }

  /**
   * @description 处理登录成功后的逻辑
   * 登录成功后获取用户信息,查看用户实名情况,是否需要重定向跳转
   * */
  static loginSuccessful(formRef, login, history) {
    store.dispatch(
      getUserinfoByToken(() => {
        store.dispatch(changeLoginDialogVisible(false));
        store.dispatch(
          queryRealNameInfo({ loginId }, () => {
            const redirectUrl = sessionStorage.getItem("redirectUrl");
            if (redirectUrl) {
              sessionStorage.removeItem("redirectUrl");
              NavigationController.filterRouter(history, redirectUrl);
            } else {
              window.location.reload();
            }
          })
        );
      })
    );
  }
}

export default NavigationController;
