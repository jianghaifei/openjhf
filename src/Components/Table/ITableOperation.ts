import { ReactNode } from "react";
import { IKVProps } from "@restosuite/field-core";
import { TFunction } from "i18next";

// 表格内置按钮的枚举
export enum ITableOperationButtonTypeEnum {
  // 编辑
  Edit = "Edit",
  // 移除
  Remove = "Remove",
}

// 表格内置按钮的点击事件
export type ITableOperationAction<T> = (record: IKVProps, index: number) => T;

// 表格操作列的 props
export interface ITableOperationProps {
  minWidth?: number | string;

  // 内置的按钮类型
  buttonTypeList?: ITableOperationButtonTypeEnum[] | string[];
  // 内置按钮的点击事件
  buttonActionList?: {
    [key: string]: ITableOperationAction<void>;
  };
  t: TFunction<["Common"], undefined>;
  // 操作列额外的内容,追加在内置按钮后面
  /** @deprecated 后续会废弃，使用buttonListRender来替代 */
  extraRender?: ITableOperationAction<ReactNode>;
  // 动态列的点击事件
  dynamicColumnAction?: () => void;
  hideButtonList?: {
    [key: string]: any[];
  };
  rowKey?: string;
  // 在外部显示几个按钮,默认为3个
  outsideBtnCount?: number;
  // 按钮列表回调,该功能和outsideBtnCount配合可以控制外部按钮以及缩起来的按钮展示
  buttonListRender?: ITableOperationAction<ReactNode[]>
}
