import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Button, Modal, Table } from "antd";
import { Link, withRouter } from "react-router-dom";
import { timeFormat } from "../../utils/utils";
import DeveloperService from "../../services/developer/DeveloperService";
import ApplyFilterBar from "./components/ApplyFilterBar";
import ApplyDialog from "./components/ApplyDialog";
import DeveloperController from "../../controllers/DeveloperController";
import Config from "../../Config";
import FilterController from "../../controllers/FilterController";
import DeveloperTitle from "./components/DeveloperTitle";
import "./css/ApplyRecord.less";

const columns1 = [
  {
    title: "单号",
    dataIndex: "orderNo"
  },
  {
    title: "集团名称",
    dataIndex: "mcUserName"
  },
  {
    title: "集团ID",
    dataIndex: "groupId"
  },
  {
    title: "状态",
    dataIndex: "checkStatus",
    render: status => FilterController.checkApplyStatus(status)
  },
  {
    title: "申请时间",
    dataIndex: "createTime",
    sorter: (a, b) => a.createTime - b.createTime,
    render: text => timeFormat(text)
  },
  {
    title: "操作",
    dataIndex: "operation",
    render: (text, record) => {
      return <Link to={`/developer/record/${record.orderNo}?m=${DeveloperController.MENU_KEY.APPLY_RECORD}`}>详情</Link>;
    }
  }
];
class DeveloperApplyRecord extends PureComponent {
  state = {
    mcUserName: undefined,
    startTime: undefined,
    endTime: undefined,
    authorityStatus: 4,
    tableData: [],
    total: 1,
    activePage: 1,
    applyModalVisible: false,
    loading: false,
    deleteDialogVisible: false,
    curOrderNo: null
  };

  columns2 = [
    {
      title: "单号",
      dataIndex: "orderNo"
    },
    {
      title: "集团名称",
      dataIndex: "mcUserName"
    },
    {
      title: "集团ID",
      dataIndex: "groupId"
    },
    {
      title: "申请时间",
      dataIndex: "createTime",
      sorter: (a, b) => a.createTime - b.createTime,
      render: text => timeFormat(text)
    },
    {
      title: "驳回时间",
      dataIndex: "checkTime",
      sorter: (a, b) => a.createTime - b.createTime,
      render: text => timeFormat(text)
    },
    {
      title: "驳回原因",
      dataIndex: "reason"
    },
    {
      title: "状态",
      dataIndex: "status",
      render: status => FilterController.checkApplyStatus(status)
    },
    {
      title: "操作",
      dataIndex: "operation",
      render: (text, record) => {
        return (
          <span className="color-link-blue" onClick={() => this.handleDeleteClick(record.orderNo)}>
            删除{" "}
          </span>
        );
      }
    }
  ];

  componentDidMount() {
    const { authorityStatus } = this.state;
    this.getData({ authorityStatus });
  }

  componentWillUnmount() {
    this.setState = () => {};
  }

  // 已绑定开发者-翻页
  listPageChange = page => {
    this.setState({ activePage: page.current });
  };

  // 已绑定开发者-查询工具函数
  getData = (params = {}) => {
    const { userId } = this.props;
    DeveloperService.getGroupApplyRecord({ ...params, userId })
      .then(res => {
        const { code, result = [] } = res;
        if (code !== "000") return false;
        this.setState({
          tableData: result,
          total: (result && result.length) || 1,
          activePage: 1
        });
      })
      .finally(() => {
        this.setState({ loading: false });
      });
  };

  // 申请商户授权
  handleApplyClick = () => {
    this.setState({
      applyModalVisible: true
    });
  };

  // 申请商户授权点击取消
  handleApplyModalCancelClick = () => {
    this.setState({ applyModalVisible: false });
  };

  // 申请商户授权点击确定
  handleApplyModalConfirmClick = groupId => {
    const { userId } = this.props;
    const params = { userId, groupId };
    DeveloperService.platUserBind(params).then(res => {
      const { code } = res;
      if (code !== "000") return false;
      this.handleApplyModalCancelClick();
      const { mcUserName, startTime, endTime, authorityStatus } = this.state;
      this.getData({ mcUserName, startTime, endTime, authorityStatus });
    });
  };

  handleDeleteOk = () => {
    const { curOrderNo } = this.state;
    this.setState({ deleteDialogVisible: false });
    DeveloperService.deleteFailBind({ orderNo: curOrderNo }).then(res => {
      const { code } = res;
      if (code !== "000") return false;
      const { mcUserName, startTime, endTime, authorityStatus } = this.state;
      const params = { mcUserName, startTime, endTime, authorityStatus };
      this.getData(params);
    });
  };

  // 删除
  handleDeleteClick = orderNo => {
    this.setState({
      curOrderNo: orderNo,
      deleteDialogVisible: true
    });
  };

  handleFilterBarClick = params => {
    this.setState({ ...params, loading: true });
    this.getData(params);
  };

  renderTableData() {
    const { tableData, total, activePage, authorityStatus } = this.state;
    const columns = authorityStatus === 2 ? this.columns2 : columns1;
    return (
      <Table
        rowKey="id"
        columns={columns}
        dataSource={tableData}
        pagination={{
          defaultCurrent: 1,
          current: activePage,
          total,
          pageSize: Config.pageSize
        }}
        onChange={this.listPageChange}
      />
    );
  }

  render() {
    const { applyModalVisible, loading, deleteDialogVisible } = this.state;

    return (
      <div className="developer-apply-record">
        <DeveloperTitle title="集团申请记录" />
        <ApplyFilterBar loading={loading} onClick={this.handleFilterBarClick} />
        <Button style={{ margin: "16px 0" }} type="primary" onClick={this.handleApplyClick}>
          申请集团授权
        </Button>
        {this.renderTableData()}

        {applyModalVisible ? (
          <ApplyDialog visible={applyModalVisible} onCancel={this.handleApplyModalCancelClick} onOk={this.handleApplyModalConfirmClick} />
        ) : null}

        <Modal
          title="确认是否删除该条绑定申请记录"
          getContainer={false}
          visible={deleteDialogVisible}
          onOk={this.handleDeleteOk}
          onCancel={() => this.setState({ deleteDialogVisible: false })}
        >
          删除后，该消息将从列表消失 ，你还要继续吗？
        </Modal>
      </div>
    );
  }
}

const mapStateToProps = ({ user }) => {
  const { id: userId } = user;
  return { userId };
};

export default connect(mapStateToProps)(withRouter(DeveloperApplyRecord));
