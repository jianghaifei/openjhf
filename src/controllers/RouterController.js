export default class RouterController {
  static getRoutes() {
    return [
      {
        name: "forgetpwd",
        link: "/forgetpassword"
      },
      {
        name: "protocol",
        link: "/protocol"
      },
      {
        name: "search",
        link: "/search"
      }
    ];
  }

  /** *
   * @description 获取pathname
   * @param location
   * @return pathname
   */
  static getPathname({ location = {} }) {
    if ("pathname" in location) {
      return location.pathname;
    }
    return null;
  }

  static getPathSearch({ location = {} }) {
    if ("search" in location) {
      return location.search;
    }
    return null;
  }

  static getSubRouterUrl(props) {
    const pathname = this.getPathname(props);
    const newPathname = pathname.slice(1);
    return newPathname.slice(newPathname.indexOf("/") + 1);
  }
}
