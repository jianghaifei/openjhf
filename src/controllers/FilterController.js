import DeveloperController from "./DeveloperController";

export default class FilterController {
  static checkApplyStatus(status) {
    switch (status) {
      case 1:
        return "待授权";
      case 2:
        return "授权失败";
      case 3:
        return "授权成功";
      default:
        return "未知";
    }
  }

  static groupCallbackType(type) {
    const { ORDER, BILL, TABLE, QUESTION } = DeveloperController.getCallbackType;
    switch (type) {
      case ORDER:
        return "订单";
      case BILL:
        return "账单";
      case QUESTION:
        return "问卷";
      case TABLE:
        return "桌台";
      default:
        return "未知";
    }
  }

  static debugType(id) {
    const { REQUEST, ORDER, BILL } = DeveloperController.MENU_KEY.DEBUG;
    switch (id) {
      case REQUEST:
        return "trace";
      case BILL:
        return "bill";
      case ORDER:
        return "order";
      default:
        return "";
    }
  }
}
