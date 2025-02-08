import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { SearchOutlined, PlusOutlined } from "@ant-design/icons";
import { Button, Form, Input, Table, Tag, Space, Modal, Select, message, InputNumber } from "antd";
import { queryRealNameInfo } from "../../../store/actions/User";
import "./index.less";
import { authCorpApply, authCorpList, infoDetail } from "../../../services/auth/authNew";
import dayjs from "dayjs";
const { TextArea } = Input;

class Userinfo extends PureComponent {
  formRefSearch = React.createRef();
  formRef = React.createRef();

  state = {
    modalLoading: false,
    columns: [
      {
        title: "#",
        dataIndex: "key",
        rowScope: "row"
      },
      {
        title: "商户ID",
        dataIndex: "corpId",
        key: "corpId",
        render: text => text
      },
      {
        title: "区域",
        dataIndex: "serviceZone",
        key: "serviceZone"
      },
      {
        title: "授权时间",
        dataIndex: "createTime",
        key: "createTime",
        render: text => dayjs(text).format("YYYY.MM.DD HH:mm:ss")
      },
      {
        title: "状态",
        key: "authStatus",
        dataIndex: "authStatus",
        render: (value, record) => {
          let _text = "";
          let _color = "";
          switch (value) {
            case "Unauthorized":
              _text = "未授权";
              _color = "processing";
              break;
            case "Authorized":
              _text = "已授权";
              _color = "success";
              break;
            default:
              _text = "撤销";
              _color = "error";
              break;
          }
          return (
            <Tag color={_color} key={value}>
              {_text}
            </Tag>
          );
        }
      },
      // {
      //   title: "回调地址",
      //   dataIndex: "callback",
      //   key: "callback"
      // },
      // {
      //   title: "操作",
      //   key: "action",
      //   render: (_, record) => (
      //     <Space size="middle">
      //       <Button
      //         type="link"
      //         onClick={() => {
      //           this.setState({ formData: record, applyOpen: true });
      //           setTimeout(() => {
      //             for (let i in record) {
      //               this.formRef.current.setFieldValue([i], record[i]);
      //             }
      //           });
      //         }}
      //       >
      //         编辑
      //       </Button>
      //     </Space>
      //   )
      // }
    ],
    data: [],
    applyOpen: false,
    dataLoading: false,
    formData: {}
  };

  componentDidMount() {
    this.getData();
  }

  componentWillUnmount() {
    // 销毁后防止继续setState
    this.setState = () => {};
  }

  // 查询用户信息
  getData(search) {
    this.setState({ dataLoading: true });
    authCorpList({})
      .then(res => {
        console.log("sssss", res, search);
        if (res.code != "000") return;
        let _data = res.data.map((el, index) => {
          el.key = index + 1;
          return el;
        });
        if (search) {
          if (search.corpId) {
            _data = _data.filter(el => el.corpId == search.corpId);
          }
          if (search.serviceZone) {
            _data = _data.filter(el => el.serviceZone == search.serviceZone);
          }
        }
        this.setState({
          data: _data
        });
      })
      .finally(() => {
        this.setState({ dataLoading: false });
      });
  }

  handleToRealName = () => {
    const { history } = this.props;
    const { REAL_NAME } = UserController.MENU_KEY();
    history.push(`/user/${REAL_NAME}`);
  };

  // model提交
  handleSubmitmodal = value => {
    console.log("aaaaa", value);
    this.setState({ modalLoading: true });
    authCorpApply(value)
      .then(res => {
        this.setState({ modalLoading: false, applyOpen: false });
        if (res.code != "000") {
          return message.warning(res.msg);
        }
        message.success("提交成功");
      })
      .finally(() => {
        this.setState({ modalLoading: false });
      });
  };

  handleSubmit = value => {
    this.getData(value);
  };

  render() {
    const { columns, data, applyOpen, modalLoading, dataLoading, formData } = this.state;
    return (
      <>
        <div className="u_box">
          <div className="u_title">
            <span>开发者账户</span>{" "}
            <Button
              type="primary"
              icon={<PlusOutlined style={{ fontSize: "12px" }} />}
              onClick={() => {
                this.setState({ applyOpen: true });
                this.formRef.current.resetFields();
              }}
            >
              商户申请
            </Button>
          </div>

          <Form
            ref={this.formRefSearch}
            colon={false}
            scrollToFirstError
            onFinish={this.handleSubmit}
            layout="inline"
            className="searchFrom"
          >
            <Form.Item name="corpId" label="商户ID">
              <Input className="form-item" placeholder="请输入商户ID" allowClear />
            </Form.Item>

            <Form.Item name="serviceZone" label="区域">
              <Select
                allowClear
                options={[
                  {
                    label: "CN",
                    value: "CN"
                  },
                  {
                    label: "EU",
                    value: "EU"
                  },
                  {
                    label: "US",
                    value: "US"
                  },
                  {
                    label: "SEA",
                    value: "SEA"
                  }
                ]}
                placeholder="请选择区域"
              ></Select>
            </Form.Item>
            <Form.Item shouldUpdate className="searchbtn">
              {() => (
                <Button type="primary" htmlType="submit" ghost icon={<SearchOutlined />}>
                  查询
                </Button>
              )}
            </Form.Item>
            <Form.Item shouldUpdate className="searchbtn" style={{ marginRight: "10px" }}>
              {() => (
                <Button
                  htmlType="submit"
                  onClick={() => {
                    this.formRefSearch.current.resetFields();
                    this.getData();
                  }}
                >
                  重置
                </Button>
              )}
            </Form.Item>
          </Form>

          <Table columns={columns} dataSource={data} loading={dataLoading} pagination={false} />
        </div>

        <Modal
          open={applyOpen}
          width={800}
          title={"商户授权申请"}
          onCancel={() => {
            this.setState({ applyOpen: false });
          }}
          loading={modalLoading}
          onOk={() => {
            this.formRef.current.submit();
          }}
          footer={[
            <Button
              onClick={() => {
                this.setState({ applyOpen: false });
              }}
            >
              返回
            </Button>,
            <Button
              loading={modalLoading}
              onClick={() => {
                this.formRef.current.submit();
              }}
              type="primary"
            >
              确定
            </Button>
          ]}
        >
          <Form ref={this.formRef} onFinish={this.handleSubmitmodal} layout="vertical">
            <Form.Item
              name="corpId"
              label="商户Id"
              rules={[
                {
                  required: true
                }
              ]}
            >
              <InputNumber className="form-item" placeholder="请输入商户Id" style={{ width: "100%" }} />
            </Form.Item>
            {/* <Form.Item
              name="loginPwd"
              label="商户名称"
              rules={[
                {
                  required: true
                }
              ]}
            >
              <Input className="form-item" placeholder="请输入商户名称" />
            </Form.Item> */}
            <Form.Item
              name="serviceZone"
              label="区域"
              rules={[
                {
                  required: true
                }
              ]}
            >
              <Select
                options={[
                  {
                    label: "CN",
                    value: "CN"
                  },
                  {
                    label: "EU",
                    value: "EU"
                  },
                  {
                    label: "US",
                    value: "US"
                  },
                  {
                    label: "SEA",
                    value: "SEA"
                  }
                ]}
                placeholder="请选择区域"
              ></Select>
            </Form.Item>
            <Form.Item name="loginPwd" label="申请原因" rules={[]}>
              <TextArea className="form-item" placeholder="请输入申请原因" />
            </Form.Item>
            {/* <Form.Item name="reason" label="回调地址" rules={[]}>
              <Input className="form-item" placeholder="请输入回调地址" />
            </Form.Item> */}
          </Form>
        </Modal>
      </>
    );
  }
}
const mapStateToProps = ({ common, user }) => {
  const { loginId } = common;
  const { isRealName, checkStatus } = user;
  return {
    loginId,
    isRealName,
    checkStatus
  };
};
const mapDispatchToProps = {
  queryRealNameInfo
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Userinfo);
