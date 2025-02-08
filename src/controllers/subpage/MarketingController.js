import img1 from "../../views/subpage/marketing/images/1.jpg";
import img2 from "../../views/subpage/marketing/images/2.jpg";
import iconVip from "../../assets/images/subpage/vip.png";
import iconMiddle from "../../assets/images/subpage/middle.png";
import iconGame from "../../assets/images/subpage/game.png";

export default class MarketingController {
  static getScenario1() {
    return {
      imgUrl: img1,
      title: "商户会员卡",
      desc: "帮助商户开发的电子会员卡，可与商户自有的会员卡系统打通，同步会员的卡余额、积分等信息，完善商户会员数据的运营管理能力。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconVip, text: "会员营销管理" }, { icon: iconMiddle, text: "中台系统" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [img1, img1]
      },
      link: "MERCHANT_CARD"
    };
  }

  static getScenario2() {
    return {
      imgUrl: img2,
      title: "营销活动",
      desc: "通过基础营销、特色营销等多样化的营销活动，助力商户轻松实现多场景，多对象，多类型的营销，极大提升营销效率。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconVip, text: "会员营销管理" }, { icon: iconMiddle, text: "中台系统" }, { icon: iconGame, text: "游戏小程序" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [img1, img1]
      },
      link: "CARD_PROMOTION"
    };
  }
}
