export interface IScheme {
  id: string | number;
  title: string;
  version: string | number;
  status: ISchemeStatus;
  category: string;
  area: string;
  businessType: string;
  mode: string;
  shopCount: number;
}

// export enum ISchemeStatus {
//   PUBLISHED = 1, //已发布
//   DRAFT = 2, //草稿
// }
export enum ISchemeStatus {
  "已发布" = 1, //已发布
  "草稿" = 2, //草稿
}
