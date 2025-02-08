export default class DeveloperController {
  static SUB_MENU_KEY = {
    GROUP: "group", // 集团管理
    DEVELOP: "develop", // 开发工具
    DEBUG: "debug" // 开发工具
  };

  static MENU_KEY = {
    GROUP_LIST: "1", // 集团列表
    APPLY_RECORD: "2", // 集团申请记录
    SIGNATURE: "3", // 签名工具
    DECODE: "4", // 解密工具
    DEBUG: {
      REQUEST: "5", // debug->请求查询
      BILL: "6", // debug->账单
      ORDER: "7" // debug->订单状态
    },
    MESSAGE: "10", // 消息通知
    DOWNLOAD_SDK: "9" // SDK下载
  };

  // todo 回调地址的类型
  static getCallbackType = {
    ORDER: 1, // 账单
    BILL: 2, // 订单
    QUESTION: 3, // 问卷
    TABLE: 5 // 桌台
  };

  static getMenuItems() {
    return [
      {
        id: this.SUB_MENU_KEY.GROUP,
        menuName: "集团管理",
        childNavigations: [
          {
            id: this.MENU_KEY.GROUP_LIST,
            menuName: "已绑定集团列表"
          },
          {
            id: this.MENU_KEY.APPLY_RECORD,
            menuName: "集团申请记录"
          }
        ]
      },
      {
        id: this.SUB_MENU_KEY.DEVELOP,
        menuName: "开发工具",
        childNavigations: [
          // {
          //   id: this.MENU_KEY.SIGNATURE,
          //   menuName: "签名工具",
          //   parentId: this.SUB_MENU_KEY.DEVELOP
          // },
          // {
          //   id: this.MENU_KEY.DECODE,
          //   menuName: "解密工具",
          //   parentId: this.SUB_MENU_KEY.DEVELOP
          // },
          {
            id: this.SUB_MENU_KEY.DEBUG,
            menuName: "Debug工具",
            parentId: this.SUB_MENU_KEY.DEVELOP,
            childNavigations: [
              {
                id: this.MENU_KEY.DEBUG.REQUEST,
                menuName: "请求查询",
                parentId: this.SUB_MENU_KEY.DEBUG
              },
              {
                id: this.MENU_KEY.DEBUG.BILL,
                menuName: "账单推送",
                parentId: this.SUB_MENU_KEY.DEBUG
              },
              {
                id: this.MENU_KEY.DEBUG.ORDER,
                menuName: "订单状态推送",
                parentId: this.SUB_MENU_KEY.DEBUG
              }
            ]
          },
          {
            id: this.MENU_KEY.MESSAGE,
            menuName: "消息通知管理",
            parentId: this.SUB_MENU_KEY.DEVELOP
          }
        ]
      },
      {
        id: this.MENU_KEY.DOWNLOAD_SDK,
        menuName: "SDK下载",
        childNavigations: []
      }
    ];
  }

  // 验证回调地址是否携带相应的后缀Url 没带的话 补一下
  static filterCallbackUrl(type, url) {
    const { ORDER, TABLE, BILL } = this.getCallbackType;
    const filterUrl = suffixUrl => {
      return url.includes(suffixUrl) ? url : url + suffixUrl;
    };
    switch (type) {
      case ORDER:
        return filterUrl("/notify/orderStatus");
      case BILL:
        return filterUrl("/addBillData");
      case TABLE:
        return filterUrl("/push/tableInfo");
      default:
        return url;
    }
  }
}
