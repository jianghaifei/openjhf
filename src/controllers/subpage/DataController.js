import img1 from "../../views/subpage/data/images/1.jpg";
import img2 from "../../views/subpage/data/images/2.jpg";
import img3 from "../../views/subpage/data/images/3.jpg";
import img4 from "../../views/subpage/data/images/4.jpg";
import img5 from "../../views/subpage/data/images/5.jpg";
import iconPos from "../../assets/images/subpage/pos.png";
import iconMachine from "../../assets/images/subpage/machine.png";

import case1 from "../../containers/subpage/images/jiumaojiu.png";
import case2 from "../../containers/subpage/images/axiang.png";
import case3 from "../../containers/subpage/images/moti.png";
import case4 from "../../containers/home/images/partner/logo51.png";
import case5 from "../../containers/home/images/partner/logo105.png";
import case6 from "../../containers/home/images/partner/logo96.png";
import case7 from "../../containers/home/images/partner/logo74.png";
import case8 from "../../containers/subpage/images/naichaxiansheng.jpg";

export default class DataController {
  static getScenario1() {
    return {
      imgUrl: img1,
      title: "账单实时推送",
      desc: "门店新增/反结账账单，实时推送给到第三方，便于商家及时关注账单情况。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconMachine, text: "全类型服务商" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case1, case2]
      },
      link: "SHOP_BILL_PUSH"
    };
  }

  static getScenario2() {
    return {
      imgUrl: img2,
      title: "历史账单查询",
      desc: "支持拉取商家在Resto 门店POS、小程序、点菜宝等产生的所有历史账单数据，周期t+1。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconMachine, text: "全类型服务商" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case3, case4]
      },
      link: "BILL_QUERY"
    };
  }

  static getScenario3() {
    return {
      imgUrl: img3,
      title: "外部账单上传",
      desc: "支持第三方POS产生的账单数据上传到Resto ，与Resto 报表中心打通形成数据报表，可以和供应链成本扣减业务关联。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconPos, text: "第三方POS" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case5, case6]
      },
      link: "DATA_UPLOAD"
    };
  }

  static getScenario4() {
    return {
      imgUrl: img4,
      title: "多维度数据报表",
      desc: "提供门店流水明细、店铺交易统计、菜品汇总、门店1年内账单统计等多张数据报表，便于商家分析门店销售情况。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconMachine, text: "全类型服务商" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case7, case8]
      },
      link: "DATA_REPORT"
    };
  }

  static getScenario5() {
    return {
      imgUrl: img5,
      title: "定制报表",
      desc: "根据不同商家不同业务需求，定制多维度的据报表。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconMachine, text: "全类型服务商" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [img1, img1]
      },
      link: ""
    };
  }
}
