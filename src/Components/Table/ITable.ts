import { Key, ReactNode } from "react";
import { TableColumnProps, TablePaginationConfig } from "antd";
import { IKVProps, IBlockConfig } from "@restosuite/field-core";
import { TableProps } from "antd/lib";
import { ITableOperationProps } from "./ITableOperation";
import PageMetaUtils from "@/Utils/PageMetaUtils";
import { TableRowSelection } from "antd/es/table/interface";

// 表格的 ref 类型
export interface ITableRef {
  // 获取当前选中数据
  getSelectedData: () => IKVProps[];
  // 设置表格数据
  setTableData: (data: IKVProps[]) => void;
  setBlockData: (data: IBlockConfig) => void;
  // 设置表格分页
  setPagination: (config: TablePaginationConfig | undefined) => void;
  setSelectedKeys?: (keys: Key[]) => void;
  getSelectedKeys?: () => Key[];
}

export type ITablePagination = TablePaginationConfig;

// 表格 action_callback 的参数返回
export interface ITableActionCallbackProps {
  // 第几页
  pageIndex?: number;
  // 每页显示多少条
  pageSize?: number;
}
// 普通表格的类型
export interface ITable {
  // 触发的 callback, 需要请求最新表格数据时,会自动调用该方法
  actionCallback?: (actionProps: ITableActionCallbackProps) => any;
  // 块的数据, 这里主要使用 fields 和 sortable
  blockData?: IBlockConfig;
  pageMetaUtils?: PageMetaUtils;
  // 表格属性
  // 是否显示操作列 默认显示
  showOperationColumn?: boolean;
  props?: {
    className?: string;
    // 表格可勾选的配置项
    selectConfig?: {
      preserveSelectedRowKeys?: boolean;
      selectable?: boolean;
      type?: "checkbox" | "radio";
      extra?:TableRowSelection<IKVProps>;
      checkStrictly?: boolean;
      // 选中 callback,如果需要实时获取就用这个,不需要实时用 ref 的方法
      onChange?: (selectedRows: IKVProps[], selectedRowKeys: Key[]) => void;
      // 该项存在的话,子级不会被选中
      disableChildDataKey?: string;
      selectedRowKeys?: Key[];
      // 设置选择框的默认属性配置
      getCheckboxProps?: (record: IKVProps) => any
    };
    extraProps?: TableProps<IKVProps>;
  };
  // 自定义列, 内部会定义默认的列,外部不可更改列的顺序,顺序由 fields 决定,不允许增加除 fields 之外的列
  // 自定义列主要为了满足有业务需求,表格内容需要独特显示
  columns?: TableColumnProps<IKVProps>[];
  operationColumnProps?: Omit<ITableOperationProps, "buttonTypeList" | "t">;
  // 表格顶部的插槽,由外边自定义
  topSlot?: ReactNode;
  // 表格无数据时显示的内容
  nodataPlaceholder?: ReactNode | JSX.Element;
  // 行的唯一标识  如果不传 默认使用 id
  rowKey?: string;
  pureTableWidth?: number;
  pureTableHeight?: number;
  minPureTableHeight?: number;
  defaultPageSize?: number;
}
