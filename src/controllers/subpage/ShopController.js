import img1 from "../../views/subpage/shop/images/1.jpg";
import img2 from "../../views/subpage/shop/images/2.jpg";
import img3 from "../../views/subpage/shop/images/3.jpg";
import img4 from "../../views/subpage/shop/images/4.jpg";
import iconApp from "../../assets/images/subpage/app.png";
import iconDinner from "../../assets/images/subpage/dinner.png";
import iconMini from "../../assets/images/subpage/mini.png";
import iconFood from "../../assets/images/subpage/food.png";

import case1 from "../../containers/subpage/images/duole.png";
import case2 from "../../containers/subpage/images/yihetang.png";
import case3 from "../../containers/subpage/images/malubianbian.jpg";
import case4 from "../../containers/subpage/images/xiuzhicha.png";
import case5 from "../../containers/home/images/partner/logo107.png";
import case6 from "../../containers/subpage/images/ziguangyuan.jpg";
import case7 from "../../containers/subpage/images/laoxiangji.jpg";

export default class ShopController {
  static getScenario1() {
    return {
      imgUrl: img1,
      title: "扫码下单",
      desc: "帮助商户店铺实现自助点菜功能，消费者使用手机扫码即可点菜，点菜结果实时同步至门店pos，大大缩短点菜时间，简化用餐流程。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconApp, text: "第三方APP" }, { icon: iconMini, text: "商家小程序" }, { icon: iconDinner, text: "企业团餐" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case1, case2]
      },
      link: "CODE_SCANNING_ORDER"
    };
  }

  static getScenario2() {
    return {
      imgUrl: img2,
      title: "加菜&退菜",
      desc: "堂食业务下可能存在的场景，主要用于客户用餐过程中需要加菜/退菜时，无论何种方式下单，最终菜品均可落在一个订单下。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconApp, text: "第三方APP" }, { icon: iconMini, text: "商家小程序" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case3, case4]
      },
      link: "ADD_AND_RETURN"
    };
  }

  static getScenario3() {
    return {
      imgUrl: img3,
      title: "桌台管理",
      desc: "查询当前桌台上的订单信息，快速定位。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconApp, text: "第三方APP" }, { icon: iconMini, text: "商家小程序" }, { icon: iconFood, text: "企业团餐" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case5, case6]
      },
      link: "TABLE_MANAGEMENT"
    };
  }

  static getScenario4() {
    return {
      imgUrl: img4,
      title: "估清查询",
      desc: "店铺菜品可售卖数量主动查询，避免超卖。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconApp, text: "第三方APP" }, { icon: iconMini, text: "商家小程序" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case7]
      },
      link: "DISHES_SOLD_OUT"
    };
  }
}
