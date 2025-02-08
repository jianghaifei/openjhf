export default class BreadcrumbController {
  /**
   * @description 默认的侧边栏数据
   * */
  static sidebarArr = [];

  /**
   * @description 默认的面包屑
   * */
  static breadcrumbs = [];

  /**
   * @description 额外的一些配置项 部分接口字段不一样 需要自定义
   * */
  static config = {};

  /**
   * @description 查找当前侧边栏选中项 在data中的下标(递归)
   * @param arr [] 默认是侧边栏数据 之后递归的是数据的子集
   * @param id String 当前选中的id
   * @param indexArr [] 默认为空数组 之后递归都会增加一个找到的数据下标
   * @return Promise([]) 下标顺序从外到里->0为最外层
   * */
  static filterSidebarIndexArr(arr = [], id, indexArr = []) {
    return new Promise(resolve => {
      arr.map((item, index) => {
        if (String(item.id) === String(id)) {
          resolve(this.getBreadcrumbByIndex([...indexArr, index]));
        } else if ("childNavigations" in item) {
          this.filterSidebarIndexArr(item.childNavigations, id, [...indexArr, index]).then(info => resolve(info));
        }
      });
    });
  }

  /**
   * @description 暴露给外部的查找面包屑的方法
   * @param sidebarArr []  侧边栏数据
   * @param curMenuId String  当前选中的按钮id
   * @param breadcrumbs [] 默认的面包屑数据
   * @param config Object 额外的参数
   * @return Promise([]) 整理好的面包屑数据
   * */
  static findBreadcrumb(sidebarArr = [], curMenuId, breadcrumbs = [], config = {}) {
    this.sidebarArr = sidebarArr;
    this.breadcrumbs = breadcrumbs;
    this.config = { menuName: "menuName", ...config };
    return this.filterSidebarIndexArr(sidebarArr, curMenuId);
  }

  /**
   * @description 根据提前找到的侧边栏层级的下标 递归寻找名称
   * @param indexArr [] 当前侧边栏选中的层级的下标数组
   * @param targetArr [] 默认为初始的侧边栏数据 之后递归的是当前数据的子集
   * @param resultArr [] 默认为初始面包屑数据 之后递归都会增加一层找到的数据
   * */
  static getBreadcrumbByIndex(indexArr = [], targetArr = this.sidebarArr, resultArr = this.breadcrumbs) {
    if (indexArr.length > 0) {
      const targetItem = targetArr[indexArr[0]];
      if (!targetItem) return resultArr;
      const { childNavigations = [] } = targetItem;
      return this.getBreadcrumbByIndex(indexArr.slice(1), childNavigations, [...resultArr, { text: targetItem[this.config.menuName] }]);
    }
    return resultArr;
  }
}
