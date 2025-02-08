import React from "react";
import { timeFormat } from "../../../utils/utils";
import FilterController from "../../../controllers/FilterController";
import DeveloperController from "../../../controllers/DeveloperController";

export const columns = [
  {
    title: "序号",
    dataIndex: "index",
    align: "center",
    width: 70
  },
  {
    title: "业务类型",
    dataIndex: "parentName",
    align: "center",
    width: 110
  },
  {
    title: "接口名称",
    dataIndex: "menuName",
    align: "center"
  },
  // {
  //   title: "版本号",
  //   dataIndex: "version",
  //   align: "center",
  //   width: 80,
  //   render: text => text || "---"
  // },
  {
    title: "权限类型",
    dataIndex: "interfaceAuth",
    align: "center",
    width: 100,
    render: text => {
      return String(text) === "1" ? "集团权限" : "店铺权限";
    }
  },
  {
    title: "适用店铺",
    dataIndex: "shopNum",
    align: "center",
    width: 120,
    render: () => <span>所有店铺</span>
  },
  {
    title: "生效时间",
    dataIndex: "takeEffectTime",
    align: "center",
    render: (text, record) => {
      return <span>{record.takeEffectTime ? timeFormat(record.takeEffectTime) : "---"}</span>;
    }
  },
  {
    title: "到期时间",
    dataIndex: "loseEffectTime",
    align: "center",
    render: (text, record) => {
      return <span>{record.loseEffectTime ? timeFormat(record.loseEffectTime) : "---"}</span>;
    }
  }
];

export const freezeColumns = [
  {
    title: "序号",
    dataIndex: "index",
    align: "center",
    width: 70
  },
  {
    title: "业务类型",
    dataIndex: "parentName",
    align: "center",
    width: 110
  },
  {
    title: "接口名称",
    dataIndex: "menuName",
    align: "center"
  },
  // {
  //   title: "版本号",
  //   dataIndex: "version",
  //   align: "center",
  //   width: 80,
  //   render: text => text || "---"
  // },
  {
    title: "失效时间",
    dataIndex: "loseEffectTime",
    align: "center",
    render: (text, record) => {
      return <span>{record.loseEffectTime ? timeFormat(record.loseEffectTime) : "---"}</span>;
    }
  },
  {
    title: "失效原因",
    dataIndex: "authorityStatus",
    align: "center",
    render: (text, record) => {
      if (!record.action) return text === 2 ? "手动禁用" : "自动到期";
      return text === 3 ? "生效中" : "禁用中";
    }
  }
];

export const callbackColumns = [
  {
    title: "序号",
    dataIndex: "index",
    align: "center",
    width: 70
  },
  {
    title: "回调类型",
    dataIndex: "notifyType",
    align: "center",
    render: text => {
      return FilterController.groupCallbackType(text);
    }
  },
  {
    title: "回调地址",
    dataIndex: "notifyPrefix",
    align: "center",
    render: (text, record) => {
      return DeveloperController.filterCallbackUrl(record.notifyType, record.notifyPrefix);
    }
  }
];
