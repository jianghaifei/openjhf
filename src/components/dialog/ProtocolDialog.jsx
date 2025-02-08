import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Checkbox, Modal } from "antd";
import { protocolConfirm } from "../../store/actions/Common";
import "./css/ProtocolDialog.less";
import Config from "../../Config";

class ProtocolDialog extends PureComponent {
  state = {
    iframeStyles: {
      width: "100%",
      height: "626px",
      borderRadius: "4px",
      border: "1px solid #e4e4e4"
    },
    agreeProtocol: false
  };

  setTitleStyle = () => {
    return <div className="protocol-title">“Resto ”开放平台线上授权协议</div>;
  };

  handleAgreeProtocol = () => {
    this.setState(state => {
      return { agreeProtocol: !state.agreeProtocol };
    });
  };

  onConfirm = () => {
    const { agreeProtocol } = this.state;
    if (!agreeProtocol) return false;
    this.props.protocolConfirm(() => {
      this.setState({ agreeProtocol: false });
    });
  };

  render() {
    const { developerProtocolDialogVisible } = this.props;
    const { iframeStyles, agreeProtocol } = this.state;
    return (
      <Modal
        getContainer={false}
        visible={developerProtocolDialogVisible}
        title={this.setTitleStyle()}
        okText="确认"
        width="1250px"
        centered
        closable={false}
        footer={null}
      >
        <div className="protocol-dialog">
          <iframe src={`${Config.api.url}/protocol/developer`} title="Resto 开发者平台服线上授权协议" style={iframeStyles} />
          <div className="tips-text">
            <Checkbox className="checkbox" checked={agreeProtocol} onChange={this.handleAgreeProtocol}>
              <span className="agree-text">我已同意</span>
              <span className="protocol-text">《Resto 开发者平台线上授权协议》</span>
            </Checkbox>
          </div>
          <div className="bottom-info">
            <div className={`btn ${agreeProtocol ? "btn-active" : ""} `} onClick={this.onConfirm}>
              确认
            </div>
          </div>
        </div>
      </Modal>
    );
  }
}

const mapStateToProps = ({ common }) => {
  const { developerProtocolDialogVisible } = common;
  return {
    developerProtocolDialogVisible
  };
};
const mapDispatchToProps = {
  protocolConfirm
};
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ProtocolDialog);
