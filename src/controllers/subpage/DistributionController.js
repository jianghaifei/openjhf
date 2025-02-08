import img1 from "../../views/subpage/distribution/images/1.jpg";
import iconPos from "../../assets/images/subpage/pos.png";

import case1 from "../../containers/subpage/images/feie.png";
import case2 from "../../containers/subpage/images/tongqinglou.png";

export default class DistributionController {
  static getScenario1() {
    return {
      imgUrl: img1,
      title: "聚合配送",
      desc: "聚合多种配送平台，支持多样化接单方式，及第三方POS对接。",
      serviceInfo: {
        title: "适合服务商类型",
        items: [{ icon: iconPos, text: "第三方POS" }]
      },
      caseInfo: {
        title: "对接案例",
        items: [case1, case2]
      },
      link: "DISH_MARKETING"
    };
  }
}
