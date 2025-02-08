import React, { PureComponent } from "react";
import { Descriptions, Modal } from "antd";
import Highlight from "react-highlight";
import DeveloperController from "../../controllers/DeveloperController";
import "highlight.js/styles/zenburn.css";

class DebugDialog extends PureComponent {
  // todo 请求查询使用
  traceColumns = [
    {
      title: "请求时间",
      key: "requestTime"
    },
    {
      title: "响应时间",
      key: "responseTime"
    },
    {
      title: "耗时(ms)",
      key: "cost"
    },
    {
      title: "集团ID",
      key: "groupID"
    },
    {
      title: "店铺ID",
      key: "shopID"
    },
    {
      title: "URL",
      key: "url"
    },
    {
      title: "输入",
      key: "requestBody",
      code: true
    },
    {
      title: "输出",
      key: "responseBody",
      code: true
    }
  ];

  // todo 其余两个使用
  columns = [
    {
      title: "时间",
      key: "time"
    },
    {
      title: "集团ID",
      key: "groupID"
    },
    {
      title: "店铺ID",
      key: "shopID"
    },
    {
      title: "URL",
      key: "url"
    },
    {
      title: "状态码",
      key: "statusCode"
    },
    {
      title: "信息",
      key: "remark",
      code: true
    }
  ];

  renderTable = () => {
    const { item, menuid } = this.props;
    const { REQUEST } = DeveloperController.MENU_KEY.DEBUG;
    const columns = menuid === REQUEST ? this.traceColumns : this.columns;
    return columns.map((subItem, subIndex) => {
      const { title, key, code } = subItem;
      if (key in item) {
        return (
          <Descriptions.Item label={title} key={`${subIndex}`} span={3}>
            {!item[key] ? "---" : code ? <Highlight className="JSON">{item[key]}</Highlight> : item[key]}
          </Descriptions.Item>
        );
      }
    });
  };

  render() {
    const { item, handleClick, visible } = this.props;
    return (
      <Modal title="Debug详情" visible={visible} width={1000} maskClosable getContainer={false} onCancel={handleClick} onOk={handleClick}>
        {item ? <Descriptions bordered>{this.renderTable()}</Descriptions> : null}
      </Modal>
    );
  }
}

export default DebugDialog;
