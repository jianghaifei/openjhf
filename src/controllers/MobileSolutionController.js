import img0 from "../containers/home/images/solution/img0.jpg";
import img1 from "../containers/home/images/solution/img1.jpg";
import img2 from "../containers/home/images/solution/img2.jpg";
import img3 from "../containers/home/images/solution/img3.jpg";
import img4 from "../containers/home/images/solution/img4.jpg";
import img5 from "../containers/home/images/solution/img5.jpg";

export default class MobileSolutionController {
  static getSolution(currentTab) {
    switch (currentTab) {
      case 0:
        return this.getSolution0();
      case 1:
        return this.getSolution1();
      case 2:
        return this.getSolution2();
      case 3:
        return this.getSolution3();
      case 4:
        return this.getSolution4();
      case 5:
        return this.getSolution5();
      default:
    }
  }

  static getSolution0() {
    return {
      imageUrl: img0,
      desc: "丰富的外卖类业务接口，开放多类业务场景模式，实现系统处理商家外卖业务的全部流程",
      tags: ["外卖下单", "菜品管理", "配送同步", "订单管理", "主动估清", "门店管理"]
    };
  }

  static getSolution1() {
    return {
      imageUrl: img1,
      desc: "提供强大的商户在线营销能力，为商户提供品牌建设传播和引客到店消费服务",
      tags: ["扫码下单", "桌台管理", "加菜和退菜", "估清查询"]
    };
  }

  static getSolution2() {
    return {
      imageUrl: img2,
      desc: "多级的商品分类，满足除餐饮外的零售业务，强大的接口分类满足不同业务客户",
      tags: ["商品管理", "下单和支付"]
    };
  }

  static getSolution3() {
    return {
      imageUrl: img3,
      desc: "聚合多种配送平台，系统自动接单智能分配优质的配送平台满足多种配送需求",
      tags: ["配送下单", "智能扣款"]
    };
  }

  static getSolution4() {
    return {
      imageUrl: img4,
      desc: "支持多样化支付场景，小程序支付、商家主扫、被扫，支付退款明细查询一应俱全",
      tags: ["小程序支付", "付款码支付", "扫码支付"]
    };
  }

  static getSolution5() {
    return {
      imageUrl: img5,
      desc: "门店账单实时推送，历史账单数据一键拉取，与Resto 报表中心打通，支持多维度的数据报表查询",
      tags: ["账单实时推送", "历史账单查询", "外部账单上传", "多维度数据报表", "定制报表"]
    };
  }
}
