import React, { useCallback, useEffect, useState } from "react";
import { connect } from "react-redux";
import { useHistory, useLocation, useParams } from "react-router-dom";
import { Button, Col, Row, Steps, Table } from "antd";
import { CloseCircleOutlined } from "@ant-design/icons";
import { checkStatusFormat, filterUrlQuery, timeFormat, arrAddIndex } from "../../../utils/utils";
import DeveloperService from "../../../services/developer/DeveloperService";
import ShopDetailModal from "../../../containers/developer/components/ShopDetailModal";
import Config from "../../../Config";
import { setMenuKey } from "../../../store/actions/Developer";
import DeveloperTitle from "../../../containers/developer/components/DeveloperTitle";
import GroupInfoCell from "../../../containers/developer/components/GroupInfoCell";
import "./index.less";

const { Step } = Steps;

const DeveloperApplyRecordDetail = props => {
  const { id } = useParams();
  const location = useLocation();
  const history = useHistory();
  const [item, updateItem] = useState({});
  const [shopDialogVisible, updateShopDialogVisible] = useState(false);
  const [shopId, updateShopId] = useState(null);
  const [pageSize, updatePageSize] = useState(Config.pageSize);

  const handleShopDialogVisible = (status = false, targetId = null) => {
    updateShopDialogVisible(status);
    updateShopId(targetId);
  };

  const columns = [
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
      width: 200
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
      render: (text, record) => {
        return (
          <span onClick={() => handleShopDialogVisible(true, record.id)} style={{ color: "#1890ff", cursor: "pointer" }}>
            {text ? `${text}个店铺` : "未知"}
          </span>
        );
      }
    },
    {
      title: "授权时间",
      dataIndex: "takeEffectTime",
      align: "center",
      width: 170,
      render: (text, record) => {
        return <span>{record.takeEffectTime ? timeFormat(record.takeEffectTime) : "---"}</span>;
      }
    },
    {
      title: "到期时间",
      dataIndex: "loseEffectTime",
      align: "center",
      width: 170,
      render: (text, record) => {
        return <span>{record.loseEffectTime ? timeFormat(record.loseEffectTime) : "---"}</span>;
      }
    },
    {
      title: "状态",
      dataIndex: "authorityStatus",
      align: "center",
      width: 110,
      render: (text, record) => {
        if (!record.action) return text === 2 ? "手动禁用" : "自动到期";
        return text === 3 ? "生效中" : "禁用中";
      }
    }
  ];

  const getItem = useCallback(() => {
    DeveloperService.queryBindDetail({ orderNo: id }).then(res => {
      const { code, result = {} } = res;
      if (code !== "000") return false;
      const { orderNo, checkStatus, reason, checkTime, createTime, authorityTime, mcUserName, applyGroupId, authorityAuthInfoVos } = result;
      const stepsCurrent = authorityTime ? 3 : checkTime ? 1 : 0;
      const stepsStatus = checkTime ? (checkStatus === 1 ? "process" : checkStatus === 2 ? "error" : "finish") : "finish";
      updateItem({
        orderId: orderNo,
        createTime,
        checkStatus,
        reason,
        stepsCurrent,
        stepsStatus,
        checkTime,
        authorityTime,
        groupName: mcUserName,
        groupId: applyGroupId,
        tableData: authorityAuthInfoVos || [],
        total: authorityAuthInfoVos ? authorityAuthInfoVos.length : 0
      });
    });
  }, [id]);

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

  const changePageSize = useCallback(pagination => updatePageSize(pagination.pageSize), []);

  const goBack = useCallback(() => history.goBack(), [history]);
  return (
    <div className="developer-apply-detail">
      <DeveloperTitle title="集团详情" />

      <Row className="mb-40">
        <Col span={6}>
          <p className="order-no">
            单号:
            {item?.orderId}
          </p>
          <p>
            创建时间:
            {timeFormat(item?.createTime)}
          </p>
        </Col>
        <Col span={6} offset={12}>
          <p>
            状态: <span className="fz-16 ">{checkStatusFormat(item?.checkStatus)}</span>
          </p>
          {item?.checkStatus === 2 ? (
            <p style={{ fontSize: "14px" }}>
              <CloseCircleOutlined
                style={{
                  color: "red",
                  paddingTop: "16px"
                }}
              />{" "}
              驳回原因:
              {item.reason}
              <br />
            </p>
          ) : null}
        </Col>
      </Row>
      <h3 className="mb-20">流程进度</h3>
      <Steps className="mb-40" labelPlacement="vertical" current={item?.stepsCurrent} status={item?.stepsStatus}>
        <Step title="创建项目" description={<div>{item?.createTime ? timeFormat(item.createTime) : null}</div>} />
        <Step
          title="集团绑定"
          description={<div style={{ color: "rgba(0,0,0,0.45)" }}>{item?.checkTime ? timeFormat(item.checkTime) : null}</div>}
        />
        <Step
          title="授权接口"
          description={<div style={{ color: "rgba(0,0,0,0.45)" }}>{item?.authorityTime ? timeFormat(item.authorityTime) : null}</div>}
        />
        <Step title="完成" />
      </Steps>
      <GroupInfoCell {...item} />

      <h3 className="mb-20">访问接口</h3>
      <Table
        className="mb-24"
        rowKey="index"
        columns={columns}
        dataSource={arrAddIndex(item?.tableData)}
        onChange={changePageSize}
        scroll={{ x: "120%" }}
        pagination={{
          defaultCurrent: 1,
          total: item?.total,
          pageSize
        }}
      />
      <Row className="form-section">
        <Col span={24} className="t-center">
          <Button style={{ marginBottom: 20 }} type="primary" onClick={goBack}>
            返回
          </Button>
        </Col>
      </Row>
      {/* 查看店铺权限的弹框 */}
      <ShopDetailModal visible={shopDialogVisible} id={shopId} onCancel={() => handleShopDialogVisible()} />
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
  )(DeveloperApplyRecordDetail)
);
