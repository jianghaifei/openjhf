export default class AdvantageController {
  static getCardItems(type = "pc") {
    const items = [
      {
        title: "基础数据管理",
        desc: "集团门店、菜品、设备、桌台区域等基础数据，一应俱全"
      },
      {
        title: "会员营销",
        desc: "协助管理精准型用户，结合多种营销活动，实现精准化营销"
      },
      {
        title: "实时订单",
        desc: "支持点菜、下单、支付等一站式服务，订单实时同步门店pos，提高人效"
      },
      {
        title: "聚合配送",
        desc: "聚合多种配送平台，系统自动接单，无需人为介入"
      },
      {
        title: "支付场景",
        desc: "支持多种支付场景，小程序支付、付款码支付、被扫"
      },
      {
        title: "数据报表",
        desc: "门店pos订单实时推送，历史账单数据一键拉取"
      }
    ];
    return type === "pc" ? items : items.slice(0, 3);
  }
}
