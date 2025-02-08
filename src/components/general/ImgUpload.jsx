import React, { PureComponent } from "react";
import { PlusOutlined, LoadingOutlined } from "@ant-design/icons";
import { message, Modal, Upload } from "antd";
import { nanoid } from "nanoid";
import "./css/ImgUpload.less";
import Config from "../../Config";

function getBase64(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = error => reject(error);
  });
}

function beforeUpload(file) {
  const isJPG = file.type === "image/jpeg";
  const isPNG = file.type === "image/png";
  const isBMP = file.type === "image/bmp";
  if (!isJPG && !isPNG && !isBMP) {
    message.error("请上传jpg/png/bmp等格式照片!");
  }
  const isLt2M = file.size / 1024 / 1024 < 2;
  if (!isLt2M) {
    message.error("文件必须小于2M!");
  }
  return (isJPG || isPNG || isBMP) && isLt2M;
}

class ImgUpload extends PureComponent {
  state = {
    previewVisible: false,
    previewImage: "",
    fileList: [],
    isFirst: true
  };

  componentWillUnmount() {
    this.setState = () => {};
  }

  handleCancel = () => this.setState({ previewVisible: false });

  handlePreview = async file => {
    this.setState({
      previewImage: file.url || file.preview || (await getBase64(file.originFileObj)),
      previewVisible: true
    });
  };

  handleChange = ({ fileList }) => {
    this.setState({ fileList, isFirst: false });
    if (fileList[0] && fileList[0].status === "done") {
      const res = fileList[0].response;
      const result = res && res.result;
      // 错误信息拦截器
      if (res.code && res.code !== "000" && res.code.startsWith("1")) {
        message.error(res.errMsg === "" || res.errMsg == null ? "系统异常" : res.errMsg);
        if (res.code === "111206") {
          this.props.setLogout();
          this.props.changeLoginDialogVisible(true);
          setTimeout(() => {
            window.location.href = Config.app.url;
          }, 1000);
        }
      } else if (result) {
        this.props.upLoadCallback(result);
      }
    }
  };

  handleRemove = () => {
    // 删除图片后要删除对应反显信息
    this.props.upLoadCallback({}, undefined);
    // 返显信息，点击删除后，不能在显示this.prop.fileList的信息了
    this.setState({ isFirst: false });
  };

  render() {
    const { type, upLoadtxt, fileList } = this.props;
    const { previewVisible, previewImage, isFirst, fileList: stateFileList } = this.state;
    let tempFileList = [];
    if (stateFileList.length > 0) {
      tempFileList = stateFileList;
    } else if (fileList && isFirst) {
      tempFileList = fileList;
    }
    const uploadButton = (
      <div>
        {this.state.loading ? <LoadingOutlined /> : <PlusOutlined />}

        <div className="ant-upload-text">
          {upLoadtxt || (
            <p>
              上传
              <br />
              需盖公章
            </p>
          )}
        </div>
      </div>
    );
    return (
      <>
        <Upload
          accept="capture"
          name="imgFile"
          listType="picture-card"
          className="avatar-uploader"
          showUploadList
          action={`${Config.api.url}/platform/register/queryImgInfo?traceId=${nanoid()}&type=${type}`}
          withCredentials
          fileList={tempFileList}
          beforeUpload={beforeUpload}
          onChange={this.handleChange}
          onPreview={this.handlePreview}
          onRemove={this.handleRemove}
        >
          {tempFileList.length >= 1 ? null : uploadButton}
        </Upload>
        <Modal getContainer={false} visible={previewVisible} footer={null} onCancel={this.handleCancel}>
          <img alt="example" style={{ width: "100%" }} src={previewImage} />
        </Modal>
      </>
    );
  }
}

export default ImgUpload;
