import img1 from "../../views/subpage/takeout/images/1.jpg";
import img2 from "../../views/subpage/takeout/images/2.jpg";
import img3 from "../../views/subpage/takeout/images/3.jpg";
import img4 from "../../views/subpage/takeout/images/4.jpg";
import img5 from "../../views/subpage/takeout/images/5.jpg";
import img6 from "../../views/subpage/takeout/images/6.jpg";
import iconApp from "../../assets/images/subpage/app.png";
import iconDinner from "../../assets/images/subpage/dinner.png";
import iconMini from "../../assets/images/subpage/mini.png";
import iconTakeout from "../../assets/images/subpage/takeout.png";
import iconOrder from "../../assets/images/subpage/order.png";
import iconFood from "../../assets/images/subpage/food.png";
import iconMiddle from "../../assets/images/subpage/middle.png";
import iconUser from "../../assets/images/subpage/user.png";

import case1 from "../../containers/home/images/partner/logo24.png";
import case2 from "../../containers/home/images/partner/logo85.png";
import case3 from "../../containers/subpage/images/shuyi.png";
import case4 from "../../containers/subpage/images/guiyuanpu.png";
import case5 from "../../containers/home/images/partner/logo96.png";
import case6 from "../../containers/subpage/images/yujianxiaomian.png";
import case7 from "../../containers/home/images/partner/logo14.png";
import case8 from "../../containers/subpage/images/liaoji.png";
import case9 from "../../containers/home/images/partner/logo59.png";
// import case10 from "../../containers/subpage/images/taoyuansanzhang.png";
import case11 from "../../containers/subpage/images/laoxiangji.jpg";
import case12 from "../../containers/home/images/partner/logo44.png";

export default class TakeoutController {
  static getScenario1() {
    return {
      imgUrl: img1,
      title: "外卖下单",
      desc: "通过SDK、openAPI等形式，帮助第三方快速实现外卖功能。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconApp, text: "第三方APP" }, { icon: iconDinner, text: "企业团餐" }, { icon: iconMini, text: "商家小程序" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case1, case2]
      },
      link: "TAKE_OUT_ORDER"
    };
  }

  static getScenario2() {
    return {
      imgUrl: img2,
      title: "配送同步",
      desc: "外卖订单配送情况（骑手信息、配送状态等）实时同步。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconApp, text: "第三方APP" }, { icon: iconDinner, text: "企业团餐" }, { icon: iconMini, text: "商家小程序" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case3, case4]
      },
      link: "DISTRIBUTION_SYNCHRONIZED"
    };
  }

  static getScenario3() {
    return {
      imgUrl: img3,
      title: "主动估清",
      desc: "主动估清三方外卖平台上的菜品可售菜品数量，确保平台菜品不超卖。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconApp, text: "第三方APP" }, { icon: iconTakeout, text: "外卖平台" }, { icon: iconMini, text: "商家小程序" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case5, case6]
      },
      link: "DISHES_SOLD_OUTS"
    };
  }

  static getScenario4() {
    return {
      imgUrl: img4,
      title: "菜品管理",
      desc: "第三方系统管理门店菜品，支持新增、删除、修改等，并同步更新展示在门店pos，降低商家维护多套菜品的成本，解决库存同步问题。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconOrder, text: "订单管理系统" }, { icon: iconFood, text: "餐饮管理系统" }, { icon: iconMiddle, text: "中台系统" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case7, case8]
      },
      link: "DISH_MANGEMENT"
    };
  }

  static getScenario5() {
    return {
      imgUrl: img5,
      title: "订单管理",
      desc: "实现订单产生到完成全流程系统管理，接单高峰期帮助商家进行订单多维度数据汇总，提升订单管理效率。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconUser, text: "全类型服务商" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case9]
        // items: [case9, case10]
      },
      link: "ORDER_PAYMENT"
    };
  }

  static getScenario6() {
    return {
      imgUrl: img6,
      title: "门店管理",
      desc: "帮助商家提升外卖门店经营效率，可对外卖门店的基础信息，如营业状态、营业时间、配送费等进行查询和及时操作。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconOrder, text: "订单管理系统" }, { icon: iconFood, text: "餐饮管理系统" }, { icon: iconMiddle, text: "中台系统" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case11, case12]
      },
      link: "STORE_REPOTR"
    };
  }
}
