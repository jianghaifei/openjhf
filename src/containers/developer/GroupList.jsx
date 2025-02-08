import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Link } from "react-router-dom";
import { Button, Form, Input, Space, Table } from "antd";
import DeveloperController from "../../controllers/DeveloperController";
import Config from "../../Config";
import DeveloperTitle from "./components/DeveloperTitle";
import DeveloperGroupService from "../../services/developer/DeveloperGroupService";
import "./css/GroupList.less";

const { GROUP_LIST } = DeveloperController.MENU_KEY;
const columns = [
  {
    title: "集团名称",
    dataIndex: "groupIDName"
  },
  {
    title: "集团ID",
    dataIndex: "groupID"
  },
  {
    title: "操作",
    dataIndex: "operation",
    render: (text, record) => {
      return (
        <Space>
          <Link to={`/developer/group/${record.merUserId}?m=${GROUP_LIST}`}>详情</Link>
          <Link to={`/developer/callback/${record.merUserId}?m=${GROUP_LIST}`}>设置回调</Link>
        </Space>
      );
    }
  }
];

class DeveloperGroupList extends PureComponent {
  formRef = React.createRef();

  state = {
    tableData: [],
    total: 1,
    activePage: 1,
    loading: false
  };

  componentDidMount() {
    this.getData();
  }

  componentWillUnmount() {
    this.setState = () => {};
  }

  // 已绑定开发者-翻页
  listPageChange = page => {
    this.setState({ activePage: page.current });
  };

  getData = (params = {}) => {
    const { userId } = this.props;
    this.setState({ loading: true });
    DeveloperGroupService.index({ ...params, userId })
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

  handleBtnClick = values => {
    const { mcUserName } = values;
    this.getData({ groupIDName: mcUserName });
  };

  renderTableData() {
    const { tableData, total, activePage } = this.state;
    return (
      <Table
        rowKey="groupID"
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
    const { loading } = this.state;
    return (
      <div className="developer-group-list">
        <DeveloperTitle title="已绑定集团列表" />
        <Form ref={this.formRef} layout="inline" onFinish={this.handleBtnClick}>
          <Form.Item label="集团名称/集团ID" name="mcUserName">
            <Input disabled={loading} allowClear placeholder="请输入集团名称/集团ID" />
          </Form.Item>
          <Button style={{ marginBottom: 16 }} type="primary" htmlType="submit" disabled={loading}>
            查询
          </Button>
        </Form>
        {this.renderTableData()}
      </div>
    );
  }
}

const mapStateToProps = ({ user }) => {
  const { id: userId } = user;
  return { userId };
};
export default connect(mapStateToProps)(DeveloperGroupList);
