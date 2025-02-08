import img1 from "../../views/subpage/retail/images/1.jpg";
import img2 from "../../views/subpage/retail/images/2.jpg";
import iconApp from "../../assets/images/subpage/app.png";
import iconMini from "../../assets/images/subpage/mini.png";
import iconMachine from "../../assets/images/subpage/machine.png";

import case1 from "../../containers/subpage/images/mengziyuan.png";
import case2 from "../../containers/subpage/images/baoshifu.png";
import case3 from "../../containers/home/images/partner/logo20.png";
import case4 from "../../containers/subpage/images/chabaidao.png";

export default class RetailController {
  static getScenario1() {
    return {
      imgUrl: img1,
      title: "商品管理",
      desc: "第三方系统可以查询和管理门店商品，并同步更新展示在门店pos，降低商家维护多套菜品的成本，解决库存同步问题。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconApp, text: "第三方APP" }, { icon: iconMini, text: "商家小程序" }, { icon: iconMachine, text: "智能贩卖机" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case1, case2]
      },
      link: "GOODS_MANGEMENT"
    };
  }

  static getScenario2() {
    return {
      imgUrl: img2,
      title: "下单和支付",
      desc: "通过第三方系统下单，支付可任选，最终落到门店pos统一管理，实现订单数据多方位管理。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconApp, text: "第三方APP" }, { icon: iconMini, text: "商家小程序" }, { icon: iconMachine, text: "智能贩卖机" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case3, case4]
      },
      link: "ORDER_PAY"
    };
  }
}
