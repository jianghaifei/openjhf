declare module "@restosuite/fe-skeleton" {
  export const rsRootStore: {
    // 根据实际结构定义具体类型
    financeStore?: unknown;
    bizStore?: unknown;
    [key: string]: any; // 保留其他可能的属性
  };
  //  添加缺失的 useTabActive 声明（假设是 React Hook）
  export function useTabActive(
    callback: () => void,
    deps?: React.DependencyList
  ): void;
}

// 声明所有 .less 文件的模块类型
declare module "*.less" {
  const classes: { [key: string]: string };
  export default classes;
}

// 如果使用 CSS Modules（如 index.module.less）
declare module "*.module.less" {
  const classes: { [key: string]: string };
  export default classes;
}

// 声明模块类型（基础版）
declare module "@restosuite/field-components" {
  export const ComposeTreeTable: React.ComponentType<any>;

  // 树data 的 item
  export interface ITreeDataItem {
    // 树节点显示的名称
    title: ReactNode;
    // 单个树节点的 value
    key: string;
    children?: ITreeDataItem[];
    [key: string]: any; // 保留其他可能的属性
  }

  // action_callback 的参数返回
  export interface IComposeTreeTableActionCallbackProps {
    // 第几页
    pageIndex?: number;
    // 每页显示多少条
    pageSize?: number;
    // 选中的树的 Key[]
    treeKeys?: Key[];
    // 选中的树的数据
    treeRows?: IKVProps[];
    // 表单的 <k,v>
    formData?: IKVProps;
    formSearch?: boolean;
    [key: string]: any; // 保留其他可能的属性
  }

  // 左树右表 ref 的类型
  export interface IComposeTreeTableRef {
    getTreeSelectedKeys: () => Key[];
    getTreeSelectedRows: () => IKVProps[];
    getTableSelectedData: () => IKVProps[];
    setTableData: ITableRef["setTableData"];
    setPagination: (pagination: TablePaginationConfig) => void;
    setBlockData: ITableRef["setBlockData"];
    formMethods: IFormRef;
    [key: string]: any; // 保留其他可能的属性
  }

  // 树的参数定义
  export interface IComposeTreeConfigType<T = any> {
    // 数据 默认类型为 ITreeDataItem 外边可覆盖
    data: Array<T>;
    // 树外部顶部的插槽,由外边自定义
    outsideTopSlot?: ReactNode;
    // 树内部顶部的插槽,由外边自定义
    insideTopSlot?: ReactNode;
    // 树的自定义属性 antd tree 的 props
    props?: TreeProps;
    // 是否显示搜索框
    searchable?: boolean;
    // 搜索回调
    searchCallback?: (value: string) => void;
    // 搜索框的 placeholder
    searchPlaceholder?: string;
    className?: any;
    style?: any;
    selectedTreeKeys?: Key[];
    [key: string]: any; // 保留其他可能的属性
  }

  export enum IComposeTreeTableLayout {
    Vertical = 1,
    Horizontal,
  }
  export interface IComposeTreeTable<T = any> {
    // 树的配置
    treeConfig?: IComposeTreeConfigType<T>;
    layout?: IComposeTreeTableLayout;
    // 表单配置
    formConfig?: {
      blockData: IBlockConfig | undefined;
      columns?: number;
      reset?: boolean;
      extraButton?: ReactNode;
      bottomSlot?: ReactNode;
      topSlot?: ReactNode;
      mounted?: () => void;
      disabledBtn?: boolean;
    };
    // 表格配置
    tableConfig?: Omit<ITable, "actionCallback">;
    // 触发的 callback, 需要请求最新表格数据时,会自动调用该方法
    actionCallback?: (actionProps: IComposeTreeTableActionCallbackProps) => {
      // 9.14 增加兼容,新的 action_callback应该不接受返回内容,由外部使用 ref 去设置
      // 表格数据
      data?: IKVProps[];
      pagination?: TablePaginationConfig;
    } | void;
    [key: string]: any; // 保留其他可能的属性
  }
}