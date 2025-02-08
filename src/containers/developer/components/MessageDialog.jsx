import React, { PureComponent } from "react";
import { Button, Input, Modal, message } from "antd";
import DeveloperMessageService from "../../../services/developer/DeveloperMessageService";

import "../css/DevelpoerMessageDialog.less";

class DeveloperMessageDialog extends PureComponent {
  state = {
    testExtra: null
  };

  componentDidUpdate(prevProps) {
    const { visible } = this.props;
    const { visible: prevVisible } = prevProps;
    if (visible !== prevVisible) this.inputOnChange({ target: { value: null } });
  }

  inputOnChange = e => {
    this.setState({
      testExtra: e.target.value
    });
  };

  onSubmit = () => {
    const { config } = this.props;
    const { testExtra } = this.state;
    const { channel, webhook, type } = config;
    const params = {
      channel,
      webhook,
      opt: type === "test" ? "sendMsg" : "setConfig"
    };

    if (testExtra) params.msg = testExtra;

    DeveloperMessageService.save(params).then(res => {
      const { code, result } = res;
      if (code !== "000") return false;
      message.success(result, 3);
      this.props.onFinished();
    });
  };

  render() {
    const { testExtra } = this.state;
    const { visible, config = {}, onFinished } = this.props;
    const { channel, notice, type } = config;
    const title = type === "test" ? "测试消息" : "保存设置";
    const tips = type === "test" ? `发送一条测试消息，请注意查看` : "发送一条配置确认消息,请注意查看并确认修改";
    return (
      <Modal title={title} destroyOnClose getContainer={false} visible={visible} onCancel={onFinished} footer={null}>
        <div className="developer-message-dialog">
          <div>
            将向 {channel === "dingTalk" ? "钉钉" : "企业微信"}
            -机器人
            {tips}
          </div>
          {notice ? <div className="notice">{notice}</div> : null}
          {type === "test" ? <Input placeholder="请输入附加消息" value={testExtra} onChange={this.inputOnChange} /> : null}
          <Button type="primary" onClick={this.onSubmit}>
            {type === "test" ? "发送消息" : "保存"}
          </Button>
        </div>
      </Modal>
    );
  }
}

export default DeveloperMessageDialog;
