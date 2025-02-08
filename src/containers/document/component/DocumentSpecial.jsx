import React from "react";
import { Alert, Collapse, Table } from "antd";
import { Markup } from "interweave";
import { jsonFormat } from "../../../utils/utils";
import "../css/DocumentSpecial.less";

const { Panel } = Collapse;
const DocumentResource = props => {
  const { name, requestUrl, requestRemark, responseRemark, requestParams, responseParams, testResult, describe } = props;
  const customPanelStyle = {
    borderRadius: 4,
    marginBottom: 24,
    border: 0,
    overflow: "hidden"
  };
  const responseColumns = [
    { title: "名称", dataIndex: "name" },
    { title: "类型", dataIndex: "type" },
    { title: "说明", dataIndex: "describe", width: 200 }
  ];
  const requestColumns = [
    { title: "名称", dataIndex: "name", key: "name" },
    { title: "类型", dataIndex: "type", key: "type" },
    { title: "是否必填", dataIndex: "isRequired", key: "isRequired", width: 100 },
    { title: "说明", dataIndex: "describe", width: 200 },
    { title: "参数来源", dataIndex: "origin", width: 200 }
  ];
  return (
    <div className="special-resource">
      <div className="api-info">
        <h1 className="title">{name}</h1>
        <h2 className="subtitle">接口简介</h2>
        <p className="desc">{describe}</p>
        <p>
          调用地址：
          <span className="color-orange">{requestUrl}</span>
        </p>
      </div>
      <Collapse defaultActiveKey={["1", "2", "3"]} bordered={false}>
        <Panel header="请求参数说明" key="1" style={customPanelStyle}>
          {requestRemark && requestRemark.length > 1 ? (
            <Alert message="注意事项" description={requestRemark} type="warning" showIcon />
          ) : null}
          <Table bordered pagination={false} dataSource={requestParams} rowKey="traceId" columns={requestColumns} />
        </Panel>
        <Panel header="返回字段说明" key="2" style={customPanelStyle}>
          {responseRemark && responseRemark.length > 1 ? (
            <Alert message="注意事项" description={responseRemark} type="warning" showIcon />
          ) : null}
          <Table bordered pagination={false} dataSource={responseParams} rowKey="traceId" columns={responseColumns} />
        </Panel>
        <Panel header="返回结果示例" key="3" style={customPanelStyle}>
          {testResult ? <Markup className="common-mark-up test-result" content={jsonFormat(testResult)} /> : null}
        </Panel>
      </Collapse>
    </div>
  );
};
export default React.memo(DocumentResource);
