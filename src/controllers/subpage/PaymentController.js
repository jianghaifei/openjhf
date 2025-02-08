import img1 from "../../views/subpage/payment/images/1.jpg";
import img2 from "../../views/subpage/payment/images/2.jpg";
import img3 from "../../views/subpage/payment/images/3.jpg";
import iconMiddle from "../../assets/images/subpage/middle.png";
import iconMachine from "../../assets/images/subpage/machine.png";
import iconVip from "../../assets/images/subpage/vip.png";
import iconGame from "../../assets/images/subpage/game.png";

import case1 from "../../containers/home/images/partner/logo86.png";
import case2 from "../../containers/subpage/images/axiang.png";
import case3 from "../../containers/subpage/images/meichaofeng.png";
import case4 from "../../containers/subpage/images/sanshiqidu.jpg";
import case5 from "../../containers/subpage/images/xiaoweiyang.png";
import case6 from "../../containers/subpage/images/yerenmufang.png";

export default class PaymentController {
  static getScenario1() {
    return {
      imgUrl: img1,
      title: "小程序支付",
      desc: "顾客使用微信/支付宝小程序支付，帮第三方快速实现支付功能。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconMachine, text: "全类型服务商" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case1, case2]
      },
      link: "APPLET_PAYMENT"
    };
  }

  static getScenario2() {
    return {
      imgUrl: img2,
      title: "付款码支付",
      desc: "商家设备扫顾客微信或支付宝的付款码，实现扫码支付，帮助商家快速实现支付对接。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconVip, text: "会员营销管理" }, { icon: iconMiddle, text: "中台系统" }, { icon: iconGame, text: "游戏小程序" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case3, case4]
      },
      link: "PAYMENT_CODE"
    };
  }

  static getScenario3() {
    return {
      imgUrl: img3,
      title: "扫码支付",
      desc: "商家提供收款码，顾客微信或支付宝的扫码支付，帮助商家快速实现支付对接。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconMachine, text: "全类型服务商" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case5, case6]
      },
      link: "CODE_SCANNING_PAYMENT"
    };
  }
}
