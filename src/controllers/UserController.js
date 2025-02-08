export default class UserController {
  static MENU_KEY() {
    return {
      USERINFO: "userinfo", // 账户信息
      SETTING: "setting", // 安全设置
      REAL_NAME: "verify" // 实名认证
    };
  }

  static getMenuItems() {
    return [
      {
        id: this.MENU_KEY().USERINFO,
        menuName: "账户信息"
      },
      {
        id: this.MENU_KEY().SETTING,
        menuName: "安全设置"
      }
    ];
  }
}
