export default class SidebarController {
  /**
   * @description 获取侧边栏默认选中的第一个菜单
   * @param sidebarArr [] 侧边栏数据
   * */
  static findFirstMenuId(sidebarArr = []) {
    
    const firstItem = sidebarArr[0];
    console.log("fffff",firstItem)
    if (firstItem && "childNavigations" in firstItem && firstItem.childNavigations.length > 0) {
      return this.deepFind(firstItem.childNavigations, [firstItem.id.toString()]);
    }
    return { selectedKey: firstItem.id.toString(), openKeys: [] };
  }

  static deepFind(arr = [], parentArr = []) {
    const item = arr[0];
    console.log("llllll",item)
    if (item && "childNavigations" in item && item.childNavigations.length > 0) {
      this.deepFind(item.childNavigations, [...parentArr, item.id.toString()]);
    } else {
      return { selectedKey: item.id.toString(), openKeys: parentArr || [] };
    }
  }

  /**
   * @description 异步查找侧边栏的父级
   * @param id 侧边栏的子集id
   * @param arr 侧边栏所有的数据 or 某个item的children
   * @param parentIdArr 当前已经查找到的父级
   * */
  static asyncFindMenuParent(id, arr = [], parentIdArr = []) {
    return new Promise(resolve => {
      arr.map(item => {
        if (String(item.id) === String(id)) {
          resolve(parentIdArr);
        }
        if ("childNavigations" in item) {
          this.asyncFindMenuParent(id, item.childNavigations, [...parentIdArr, String(item.id)]).then(res => resolve(res));
        }
      });
    });
  }

  /**
   * @description 同步查找侧边栏的父级
   * @param id 侧边栏的子集id
   * @param arr 侧边栏所有的数据 or 某个item的children
   * @param parentIdArr 当前已经查找到的父级
   * */
  static findMenuParent(id, arr = [], parentIdArr = []) {
    for (let i = 0; i < arr.length; i++) {
      const item = arr[i];
      if (String(item.id) === String(id)) {
        return parentIdArr;
      }

      if ("childNavigations" in item) {
        return this.findMenuParent(id, item.childNavigations, [...parentIdArr, String(item.id)]);
      }
    }
  }
}
