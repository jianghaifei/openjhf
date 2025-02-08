import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { EditOutlined, CopyOutlined, LockOutlined, MailOutlined, KeyOutlined, EyeOutlined, WalletOutlined } from "@ant-design/icons";
import { Button, Form, Input, message, Spin } from "antd";
import { queryRealNameInfo } from "../../../store/actions/User";
import "./index.less";
import { loginCheckUser, infoUpdate, infoDetail } from "../../../services/auth/authNew";
import dayjs from "dayjs";
class Userinfo extends PureComponent {
  formRef = React.createRef();
  state = {
    isEdit: false,
    userInfo: {},
    appKey: "••••••••",
    secretKey: "••••••••",
    loading: false
  };

  // 使用 navigator.clipboard.writeText 方法复制文本
  copyTextToClipboard(text) {
    const textArea = document.createElement("textarea");
    textArea.value = text;
    textArea.style.position = "fixed";
    textArea.style.opacity = 0;
    document.body.appendChild(textArea);
    textArea.select();
    try {
      const successful = document.execCommand("copy");
      if (successful) {
        message.success("复制成功!");
      } else {
        console.error("复制失败: 无法执行复制命令");
      }
    } catch (err) {
      console.error("复制失败:", err);
    }
    document.body.removeChild(textArea);
  }

  copyText(test) {
    // 使用备用方法进行复制
    if (!navigator.clipboard) {
      this.copyTextToClipboard(test);
    } else {
      navigator.clipboard
        .writeText(test)
        .then(() => {
          message.success("复制成功!");
        })
        .catch(err => {
          console.error("复制失败:", err);
        });
    }
    // navigator.clipboard
    //   .writeText(test)
    //   .then(() => {
    //     // 复制成功后的操作，例如显示提示信息
    //     message.success("复制成功!");
    //   })
    //   .catch(err => {
    //     // 复制失败后的操作
    //     console.error("复制失败:", err);
    //   });
  }

  componentDidMount() {
    this.getData();
  }

  componentWillUnmount() {
    // 销毁后防止继续setState
    this.setState = () => {};
  }

  // 查询用户信息
  getData() {
    this.setState({ loading: true });
    infoDetail({})
      .then(res => {
        console.log("sssss", res);
        this.setState({ userInfo: res.data, loading: false });

        this.formRef.current.setFieldsValue(res.data);
      })
      .finally(() => {
        this.setState({ loading: false });
      });
  }

  handleToRealName = () => {
    const { history } = this.props;
    const { REAL_NAME } = UserController.MENU_KEY();
    history.push(`/user/${REAL_NAME}`);
  };

  isEditFn = state => {
    if (state) {
      this.setState({ isEdit: state });
    } else {
      this.formRef.current.submit();
    }
  };

  handleSubmit = value => {
    const { userInfo } = this.state;
    const params = {
      ...userInfo,
      ...value
    };
    this.setState({ loading: true });
    infoUpdate(params)
      .then(res => {
        console.log("ddddd", res);
        this.setState({ loading: false });
        if (res.code != "000") return;
        message.success("保存成功!");
        this.setState({ isEdit: false });
      })
      .finally(() => {
        this.setState({ loading: false });
      });
  };

  showInfoKey = (state, text, key) => {
    console.log("xxxx", state, text);
    this.setState({ [key]: text });
  };

  render() {
    const { isRealName, checkStatus } = this.props;
    const { isEdit, userInfo, appKey, secretKey, loading } = this.state;
    return (
      <div className="u_box">
        <Spin spinning={loading}>
          <div className="u_title">开发者账户</div>
          <ul className="u_ul_box">
            <li>
              <label>开发者 id</label> : <b>{userInfo.developerId || ""}</b>
              <CopyOutlined style={{ color: "#4078FD" }} onClick={() => this.copyText(userInfo.developerId)} />
            </li>
            <li>
              <label>创建时间</label>:<b>{dayjs(userInfo.createTime).format("YYYY.MM.DD HH:mm:ss")}</b>
            </li>
            <div className="u_btnyellow">
              <span>开发服务商</span>
            </div>
          </ul>

          <div className="u_account">
            <div className="u_a_title">
              <b>账户信息</b>
              {isEdit ? (
                <Button
                  type="primary"
                  onClick={() => {
                    this.isEditFn(false);
                  }}
                >
                  <WalletOutlined /> 保存
                </Button>
              ) : (
                <Button
                  onClick={() => {
                    this.isEditFn(true);
                  }}
                >
                  <EditOutlined /> 编辑
                </Button>
              )}
            </div>
            <Form ref={this.formRef} colon={false} scrollToFirstError onFinish={this.handleSubmit} layout="vertical" disabled={!isEdit}>
              <Form.Item
                name="contact"
                label="姓名"
                rules={[
                  {
                    required: true,
                    message: "请输入姓名"
                  }
                  // {
                  //   pattern: /^(?![^0-9]+$)(?![^a-zA-Z]+$)[0-9A-Za-z]{6,12}$/,
                  //   message: "用户名为6-12字母数字组合!"
                  // }
                ]}
              >
                <Input className="form-item" placeholder="请输入姓名" />
              </Form.Item>

              <Form.Item
                name="company"
                label="公司"
                rules={[
                  {
                    required: true,
                    message: "请输入公司名称!"
                  }
                ]}
              >
                <Input className="form-item" placeholder="请输入公司名称" />
              </Form.Item>

              <Form.Item
                name="companyAddress"
                label="公司地址"
                rules={
                  [
                    // {
                    //   required: true,
                    //   message: "请输入公司地址!"
                    // }
                  ]
                }
              >
                <Input className="form-item" placeholder="请输入公司地址" />
              </Form.Item>

              <Form.Item
                name="description"
                label="描述"
                rules={
                  [
                    // {
                    //   required: true,
                    //   message: "请输入描述!"
                    // }
                  ]
                }
              >
                <Input className="form-item" placeholder="请输入描述" />
              </Form.Item>
            </Form>
          </div>

          <div className="u_account">
            <div className="u_a_title">
              <b>账户安全</b>
            </div>

            <ul className="u_s_ul">
              <li>
                <div>
                  <KeyOutlined />
                </div>
                <div>
                  <h3>开发人员认证</h3>
                  <h2>
                    <h4>
                      <h5>App Key</h5>
                      <h6>{appKey}</h6>
                      <EyeOutlined
                        onMouseDown={() => {
                          this.showInfoKey(true, userInfo.appKey, "appKey");
                        }}
                        onMouseUp={() => {
                          this.showInfoKey(false, "••••••••", "appKey");
                        }}
                      />
                      <CopyOutlined onClick={() => this.copyText(userInfo.appKey)} />
                    </h4>
                    <h4>
                      <h5>Secret Key</h5>
                      <h6>{secretKey}</h6>
                      <EyeOutlined
                        onMouseDown={() => {
                          this.showInfoKey(true, userInfo.secretKey, "secretKey");
                        }}
                        onMouseUp={() => {
                          this.showInfoKey(false, "••••••••", "secretKey");
                        }}
                      />
                      <CopyOutlined onClick={() => this.copyText(userInfo.secretKey)} />
                    </h4>
                  </h2>
                </div>
                <div>{/* <Button>Reset</Button> */}</div>
              </li>
              <li>
                <div>
                  <MailOutlined />
                </div>
                <div>
                  <h3>邮箱</h3>
                  <p>当前邮箱 : {userInfo.email}</p>
                </div>
                <div>{/* <Button>Change</Button> */}</div>
              </li>
              <li>
                <div>
                  <LockOutlined />
                </div>
                <div>
                  <h3>密码</h3>
                  <p>密码已设置</p>
                </div>
                <div>{/* <Button>Change</Button> */}</div>
              </li>
            </ul>
          </div>
        </Spin>
      </div>
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
