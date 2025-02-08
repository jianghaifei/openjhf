import React, { useCallback, useEffect, useState } from "react";
import { connect } from "react-redux";
import { Button, Tabs, Col, Table } from "antd";
import { useHistory, useLocation, useParams } from "react-router-dom";
import DeveloperGroupService from "../../../services/developer/DeveloperGroupService";
import { filterUrlQuery, arrAddIndex } from "../../../utils/utils";
import Config from "../../../Config";
import { setMenuKey } from "../../../store/actions/Developer";
import { columns, freezeColumns, callbackColumns } from "./Columns";
import DeveloperTitle from "../../../containers/developer/components/DeveloperTitle";
import GroupInfoCell from "../../../containers/developer/components/GroupInfoCell";
import "./index.less";

const { TabPane } = Tabs;
const DeveloperGroupDetail = props => {
  const { userId } = props;
  const history = useHistory();
  const { id } = useParams();
  const location = useLocation();
  const [item, updateItem] = useState({});
  const [currentTabIndex, updateCurrentTabIndex] = useState("1");
  const [pageSize, updatePageSize] = useState(Config.pageSize);

  const getItem = useCallback(() => {
    DeveloperGroupService.show({ merUserId: id, platUserId: userId }).then(res => {
      const { code, result = {} } = res;
      if (code !== "000") return false;
      const { useLst, loseLst, merInfoInfo = {}, notifyInfos } = result;
      const { merName: groupName, groupId } = merInfoInfo;
      updateItem({
        groupName,
        groupId,
        defaultTableData: useLst || [],
        freezeTableData: loseLst,
        callbackItems: notifyInfos || []
      });
    });
  }, [id, userId]);

  useEffect(() => {
    getItem();
  }, [getItem]);

  useEffect(() => {
    if (location) {
      const { m } = filterUrlQuery({ location });
      if (m) props.setMenuKey(m);
    }
    // eslint-disable-next-line
  }, [location]);

  const changeTab = useCallback(key => updateCurrentTabIndex(key), []);

  const changePageSize = useCallback(pagination => updatePageSize(pagination.pageSize), []);

  const goBack = useCallback(() => history.goBack(), [history]);

  const getCurrentResource = useCallback(
    type => {
      const { defaultTableData = [], freezeTableData = [], callbackItems = [] } = item;
      switch (type) {
        case "column":
          return currentTabIndex === "1" ? columns : freezeColumns;
        case "data":
          return currentTabIndex === "1" ? defaultTableData : freezeTableData;
        case "total":
          return currentTabIndex === "1" ? defaultTableData.length : freezeTableData.length;
        case "callback":
          return callbackItems;
        default:
          return null;
      }
    },
    [currentTabIndex, item]
  );

  return (
    <div className="developer-group-detail">
      <DeveloperTitle title="集团详情" />
      <GroupInfoCell {...item} />
      <h3 className="mb-20">回调地址</h3>
      <Table
        className="mb-40"
        style={{ width: "100%" }}
        rowKey="id"
        columns={callbackColumns}
        dataSource={arrAddIndex(getCurrentResource("callback"))}
        pagination={false}
      />
      <h3 className="mb-20">访问接口</h3>
      <Tabs defaultActiveKey="1" onChange={changeTab}>
        <TabPane tab="生效中" key="1" />
        <TabPane tab="已失效" key="2" />
      </Tabs>
      <Table
        className="mb-24"
        rowKey="index"
        columns={getCurrentResource("column")}
        dataSource={arrAddIndex(getCurrentResource("data"))}
        onChange={changePageSize}
        pagination={{
          defaultCurrent: 1,
          total: getCurrentResource("total"),
          pageSize
        }}
      />
      <Col span={24} className="t-center">
        <Button style={{ marginBottom: 20 }} type="primary" onClick={goBack}>
          返回
        </Button>
      </Col>
    </div>
  );
};

const mapStateToProps = state => {
  return {
    userId: state.user.id
  };
};
const mapDispatchToProps = {
  setMenuKey
};
export default React.memo(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(DeveloperGroupDetail)
);
