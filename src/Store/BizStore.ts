import { IKVProps } from "@restosuite/field-core";
import _ from "lodash";
import { makeAutoObservable } from "mobx";

enum IContentRenderType {
  Table = "table",
  ItemCardList = "itemCardList",
}

// 存储业务相关的数据
class BizStore {
  menuContentType: IContentRenderType = IContentRenderType.Table;
  itemContentType: IContentRenderType = IContentRenderType.ItemCardList;
  // 2024-0920-集团菜单需求, 基本档各业务列表都有选择品牌需求,需要缓存品牌
  listBrandMemoryObj: { [key: string]: any } = {}
  contentRefresh = false

  itemsInfo: IKVProps[] = [];
  // form里门店多选组件的数据
  formItemLocationList: IKVProps[] = [];
  constructor() {
    makeAutoObservable(this);
    this.listBrandMemoryObj = this.getListBrandMemoryObj() || {}
  }
  setMenuContentType(type: IContentRenderType) {
    this.menuContentType = type;
  }
  setItemContentType(type: IContentRenderType) {
    this.itemContentType = type;
  }

  setItemsInfo(items: IKVProps[]) {
    //先清空再设置值
    this.itemsInfo.splice(0, this.itemsInfo.length);
    this.itemsInfo = this.itemsInfo.concat(items);
  }
  setFormItemLocationList(list: IKVProps[]) {
    this.formItemLocationList = list;
  }

  setListBrandMemoryObj(path: string, info: any) {
    this.listBrandMemoryObj[path] = info
    sessionStorage.setItem('listBrandMemoryObj', JSON.stringify(this.listBrandMemoryObj))
  }

  getListBrandMemoryObj() {
    try {
      const strData = sessionStorage.getItem('listBrandMemoryObj')
      if (strData) {
        const data = JSON.parse(strData)
        return data
      }
    } catch (error) {
      return {}
    }
  }
  removeListBrandId(path: string) {
    const data = this.getListBrandMemoryObj()
    sessionStorage.setItem('listBrandMemoryObj', JSON.stringify(_.omit(data, path)))
  }
  removeListBrandMemoryByKeyword(keyword: string, cb?: () => void) {
    const data = this.getListBrandMemoryObj()
    const _newData: IKVProps = {}
    Object.keys(data).forEach(key => {
      if (!key.includes(keyword)) {
        _newData[key] = data[key]
      }
    })
    sessionStorage.setItem('listBrandMemoryObj', JSON.stringify(_newData))
    cb?.()
  }
  getListBrandId(path: string) {
    const data = this.getListBrandMemoryObj()
    return data?.[path]?.value || ""
  }

  getListBrandName(path: string) {
    const data = this.getListBrandMemoryObj()
    return data?.[path]?.label || ""
  }

  setContentRefresh(val: boolean, duration = 300) {
    this.contentRefresh = val
    // 如果是 true 的话 过 duration 时长 自动切回来
    if (val) {
      setTimeout(() => {
        this.contentRefresh = false
      }, duration);
    }
  }
}
export default BizStore;
