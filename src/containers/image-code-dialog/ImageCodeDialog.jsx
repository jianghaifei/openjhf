import React from "react";
import { Modal } from "antd";
import ImageCode from "./components/ImageCode";

const ImgCodeModal = props => {
  const { visible, onCancel, onMatch } = props;
  return (
    <Modal className="img-code-modal" visible={visible} onCancel={onCancel} footer={null} width={308}>
      <ImageCode onMatch={onMatch} />
    </Modal>
  );
};

export default React.memo(ImgCodeModal);
