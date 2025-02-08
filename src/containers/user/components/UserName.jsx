import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { CheckOutlined, CloseOutlined, EditOutlined, UserOutlined } from "@ant-design/icons";
import { Avatar, Col, Input, Row } from "antd";
import UserService from "../../../services/user/UserService";
import { setUserinfo } from "../../../store/actions/Common";

class UserName extends PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      isEdit: false,
      newLoginName: props.loginName,
      newLoginNameError: ""
    };
  }

  onChange = e => {
    const reg = /^(?![^0-9]+$)(?![^a-zA-Z]+$)[0-9A-Za-z]{6,12}$/;
    if (!reg.test(e.target.value)) {
      this.setState({ newLoginNameError: "用户名为6-12字母数字组合!" });
    } else {
      this.setState({ newLoginNameError: "" });
    }
    this.setState({ newLoginName: e.target.value });
  };

  editClick = () => {
    this.setState({ isEdit: true });
  };

  closeClick = () => {
    const { loginName } = this.props;
    this.setState({ isEdit: false, newLoginName: loginName, newLoginNameError: "" });
  };

  checkClick = () => {
    const { newLoginNameError, newLoginName: loginName } = this.state;
    if (newLoginNameError !== "") {
      return;
    }
    const { loginId, phone } = this.props;
    const params = { loginName, loginId };
    // 修改用户名
    UserService.resetLoginName(params).then(res => {
      if (res.code !== "000") return false;
      this.setState({ isEdit: false });
      // 修改storage、cookie、store里的信息
      const info = { isLogin: true, id: loginId, loginName, phone };
      this.props.setUserinfo(info);
      localStorage.setItem("loginName", loginName);
    });
  };

  render() {
    const { loginName, isRealName, checkStatus } = this.props;
    const { isEdit, newLoginName, newLoginNameError } = this.state;
    const inputJsx = (
      <div>
        <Input
          placeholder="用户名可作为登录账号，6-12字母数字组合"
          value={newLoginName}
          onChange={this.onChange}
          suffix={
            <div>
              <CheckOutlined onClick={this.checkClick} className="mr-16" />
              <CloseOutlined onClick={this.closeClick} />
            </div>
          }
        />
        <span className="color-warn-red">{newLoginNameError}</span>
      </div>
    );
    return (
      <Row className="user-name-warp">
        <Col span={2}>
          <Avatar size={68} icon={<UserOutlined />} style={{ background: "#1890ff", color: "#fff", marginRight: 10 }} />
        </Col>
        <Col span={6}>
          {isEdit ? (
            inputJsx
          ) : (
            <p className="name">
              用户名:
              {loginName} <EditOutlined onClick={this.editClick} />
            </p>
          )}

          <p className="check-status">
            <UserOutlined />
            {isRealName && checkStatus === 3 ? "企业认证用户" : "未实名认证"}
          </p>
        </Col>
      </Row>
    );
  }
}

const mapStateToProps = ({ common }) => {
  const { loginId, loginName, phone } = common;
  return {
    loginId,
    loginName,
    phone
  };
};
const mapDispatchToProps = {
  setUserinfo
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(UserName);
