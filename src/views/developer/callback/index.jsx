import React, { useCallback, useEffect, useState } from "react";
import { useHistory, useLocation, useParams } from "react-router-dom";
import { connect } from "react-redux";
import { Button, Col, message, Modal, Table } from "antd";
import { filterUrlQuery, timeFormat } from "../../../utils/utils";
import { setMenuKey } from "../../../store/actions/Developer";
import DeveloperTitle from "../../../containers/developer/components/DeveloperTitle";
import GroupInfoCell from "../../../containers/developer/components/GroupInfoCell";
import FilterController from "../../../controllers/FilterController";
import DeveloperGroupService from "../../../services/developer/DeveloperGroupService";
import DeveloperCallbackService from "../../../services/developer/DeveloperCallbackService";
import CallbackEditor from "../../../containers/developer/components/CallbackEditor";

const { confirm } = Modal;
const DeveloperCallback = props => {
  const { userId } = props;
  const { id } = useParams();
  const location = useLocation();
  const history = useHistory();
  const [item, updateItem] = useState({});
  const [items, updateItems] = useState([]);
  const [editVisible, updateEditVisible] = useState(false);
  const columns = [
    {
      title: "回调类型",
      dataIndex: "notifyType",
      width: 120,
      render: text => FilterController.groupCallbackType(text)
    },
    {
      title: "回调地址",
      dataIndex: "notifyPrefix"
    },
    {
      title: "状态",
      dataIndex: "valid",
      width: 80,
      render: valid => (valid ? "有效" : "失效")
    },
    {
      title: "添加时间",
      dataIndex: "modifyTime",
      render: text => timeFormat(text)
    },
    {
      title: "操作",
      dataIndex: "operation",
      render(text, dataItem) {
        return (
          <>
            <Button type="link" onClick={() => handleRemove(dataItem)}>
              删除
            </Button>
            <Button type="link" onClick={() => handleRefresh(dataItem)}>
              检查缓存
            </Button>
          </>
        );
      }
    }
  ];

  const getItem = useCallback(() => {
    DeveloperGroupService.show({ merUserId: id, platUserId: userId }).then(res => {
      const { code, result = {} } = res;
      if (code !== "000") return false;
      const { merInfoInfo = {}, devUserInfoVo = {}, notifyInfos } = result;
      const { merName: groupName, groupId } = merInfoInfo;
      const { appKey } = devUserInfoVo;
      updateItem({
        groupName,
        groupId,
        appKey
      });
      updateItems(notifyInfos || []);
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

  const goBack = useCallback(() => history.goBack(), [history]);

  const handleRemove = removeItem => {
    confirm({
      title: `请确定是否删除【${FilterController.groupCallbackType(removeItem.notifyType)}】回调地址`,
      content: "删除后会保留缓存信息,但无法再推送,还要继续吗?",
      onOk: () => {
        DeveloperCallbackService.delete(removeItem.id).then(res => {
          const { code } = res;
          if (code !== "000") return false;
          message.success("删除成功");
          getItem();
        });
      }
    });
  };

  const handleEditVisible = (status = false) => {
    updateEditVisible(status);
  };
  const handleEditOnFinished = status => {
    if (status) {
      getItem();
    }
    handleEditVisible();
  };

  const handleRefresh = dataItem => {
    DeveloperCallbackService.refresh({
      appKey: item?.appKey,
      groupId: item?.groupId,
      notifyType: dataItem.notifyType
    }).then(res => {
      const { code, result } = res;
      if (code !== "000") return false;
      message.success(result, 5);
    });
  };
  return (
    <>
      <DeveloperTitle title="回调管理" />
      <GroupInfoCell {...item} />
      <h3 className="mb-20">回调地址</h3>
      <Button className="mb-20" type="primary" onClick={() => handleEditVisible(true)}>
        新增回调
      </Button>
      <Table className="mb-40" style={{ width: "100%" }} rowKey="id" columns={columns} dataSource={items} pagination={false} />
      <Col span={24} className="t-center">
        <Button style={{ marginBottom: 20 }} type="primary" onClick={goBack}>
          返回
        </Button>
      </Col>

      {editVisible ? (
        <CallbackEditor
          visible={editVisible}
          userId={userId}
          items={items.map(dataItem => dataItem.notifyType)}
          onFinished={handleEditOnFinished}
        />
      ) : null}
    </>
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
  )(DeveloperCallback)
);
