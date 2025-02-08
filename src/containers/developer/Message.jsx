import React, { createRef, Fragment, PureComponent } from "react";
import { Button, Form, Input, Select, message, Alert } from "antd";
import { InfoCircleOutlined, ExclamationCircleFilled } from "@ant-design/icons";
import { withRouter } from "react-router-dom";
import DeveloperTitle from "./components/DeveloperTitle";
import DeveloperFormItem from "./components/DeveloperFormItem";
import MessageDialog from "./components/MessageDialog";
import { filterUrlQuery, removeUrlParams } from "../../utils/utils";
import DeveloperMessageService from "../../services/developer/DeveloperMessageService";
import "./css/DevelpoerMessage.less";

class DeveloperMessage extends PureComponent {
  formRef = createRef();

  state = {
    channelOptions: [
      {
        label: "钉钉-机器人",
        value: "dingTalk"
      },
      {
        label: "企业微信-机器人",
        value: "wxWork"
      }
    ],
    items: [],
    hasBind: false,
    curEditItem: {},
    dialogVisible: false
  };

  componentDidMount() {
    const { auth } = filterUrlQuery(this.props);
    if (auth) this.handleCheckAuth(auth);
    this.getItems();
  }

  getItems = () => {
    DeveloperMessageService.index().then(res => {
      const { code, result } = res;
      if (code !== "000") return false;
      this.setState({
        items: result,
        hasBind: result.some(resultItem => resultItem.webhook)
      });
    });
  };

  handleOnClick = type => {
    this.getFormResult(type);
  };

  getFormResult = type => {
    this.formRef.current.validateFields().then(values => {
      const { channel } = values;
      const curItem = this.state.items.find(item => item.channel === channel);
      this.setState({
        curEditItem: { ...curItem, ...values, type }
      });
      this.changeDialogVisible(true);
    });
  };

  changeDialogVisible = (value = false) => {
    this.setState({
      dialogVisible: value
    });
  };

  handleCheckAuth = auth => {
    DeveloperMessageService.auth({ authKey: auth }).then(res => {
      const { code, errMsg } = res;
      if (code !== "000") return false;
      message.success({ content: errMsg, duration: 1 }).then(() => {
        window.location.href = removeUrlParams(window.location.href, "auth");
      });
    });
  };

  handleChannelOnChange = () => {
    this.formRef.current.setFieldsValue({
      webhook: ""
    });
  };

  renderAlert = () => {
    return (
      <Alert
        message="功能介绍"
        description={
          <div>
            <p>1. 为了让开发者接收到来自开放平台的消息通知, 现支持开发者自定义绑定消息渠道;</p>
            <p>2. 目前支持的消息类型有: 账单推送告警;</p>
            <p>3. 目前支持的渠道有: 钉钉、企业微信;</p>
            <p>4. 目前只支持单渠道, 以最新绑定的渠道为准;</p>
            <p>
              5. 以钉钉为例创建群聊机器人:
              创建群聊-&gt;点击设置-&gt;选择智能群助手-&gt;添加自定义机器人-&gt;将webhook地址粘到下方输入框内进行测试;
            </p>
            <p>6. 测试消息确认收到后, 点击&ldquo;保存配置&rdquo;会发送一条授权信息到群内, 点击授权即可绑定渠道;</p>
            <p>7. 绑定渠道后, 消息通知会自动推送到群内;</p>
            <p>8. 后续会加入更多的消息类型以及渠道;</p>
          </div>
        }
        type="info"
        showIcon
        icon={<ExclamationCircleFilled />}
      />
    );
  };

  render() {
    const { channelOptions, items, hasBind, curEditItem, dialogVisible } = this.state;
    return (
      <div className="developer-message">
        <DeveloperTitle title="消息通知管理" />
        {this.renderAlert()}
        <Form ref={this.formRef} style={{ marginTop: 30 }}>
          <DeveloperFormItem label="选择渠道" formName="channel" initialValue={channelOptions[0].value}>
            <Select onChange={this.handleChannelOnChange}>
              {channelOptions.map(channelItem => {
                return (
                  <Select.Option key={channelItem.value} value={channelItem.value}>
                    {channelItem.label}
                  </Select.Option>
                );
              })}
            </Select>
          </DeveloperFormItem>
          <DeveloperFormItem label="渠道地址" formName="webhook" rules={[{ required: true, message: "请输入渠道地址" }]}>
            <Input placeholder="请输入渠道地址" allowClear />
          </DeveloperFormItem>
          <DeveloperFormItem type="other">
            <Button type="primary" style={{ marginRight: 20 }} onClick={() => this.handleOnClick("test")}>
              发送测试消息
            </Button>
            <Button type="primary" style={{ marginRight: 20 }} onClick={() => this.handleOnClick("save")}>
              保存配置
            </Button>
          </DeveloperFormItem>
        </Form>
        <DeveloperFormItem label="当前使用的消息渠道" type="other">
          <div className="channel-content">
            {hasBind ? (
              items.map(item => {
                return (
                  <Fragment key={item.channel}>
                    {item.webhook ? (
                      <>
                        <div className="name">{item.name}</div>
                        <div className="url">{item.webhook}</div>
                      </>
                    ) : null}
                  </Fragment>
                );
              })
            ) : (
              <>
                <InfoCircleOutlined className="icon" />
                <div>暂无配置项</div>
              </>
            )}
          </div>
        </DeveloperFormItem>

        <MessageDialog config={curEditItem} visible={dialogVisible} onFinished={() => this.changeDialogVisible(false)} />
      </div>
    );
  }
}

export default withRouter(DeveloperMessage);
