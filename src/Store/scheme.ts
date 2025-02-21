import { makeAutoObservable } from "mobx";
import RootStore from "./root";
import { IScheme } from "@/@types/scheme";

const schemeList: IScheme[] = new Array(10).fill(0).map((_, index) => {
  return {
    id: index + 1,
    title: "茶饮POS",
    version: `${index + 1}.0`,
    status: index % 2 ? 1 : 2,
    category: "POS",
    area: "CHINA",
    businessType: "茶饮",
    mode: "柜台",
    shopCount: 20,
  };
});

export default class SchemeStore {
  restautantName = "";
  schemeList: IScheme[] = schemeList;
  rootStore: RootStore;

  constructor(rootStore: RootStore) {
    makeAutoObservable(this);
    this.rootStore = rootStore;
  }
}
