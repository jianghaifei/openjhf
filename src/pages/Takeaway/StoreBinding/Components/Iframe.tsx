import { Modal } from "antd";
import { useState, useImperativeHandle, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import styles from "./index.module.less";

export type IConfigRef = {
  open: (params: any) => void;
};

const Iframe = forwardRef<IConfigRef, any>((props, ref) => {
  const { title, height, onSuccess } = props;
  const { t, i18n } = useTranslation(["Report", "Common"]);
  const [open, setOpen] = useState<boolean>(false);
  const [list, setList] = useState<any[]>([]);
  const [shopDetail, setShopDetail] = useState<any>({});
  const [url, setUrl] = useState<string>("");
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { shopInfo, url } = params;
      setUrl(url || "");
      setOpen(true);
    },
  }));

  const handleOk = () => {
    //
  };
  const handleCancel = () => {
    setOpen(false);
  };

  return (
    <Modal
      title={title || ""}
      open={open}
      onOk={handleOk}
      maskClosable={false}
      destroyOnClose={true}
      closeIcon={null}
      cancelText={null}
      okText="关闭并刷新"
      width={1024}
      onCancel={handleCancel}
    >
      <div
        className={`${styles.iframeBox}`}
        style={{
          height: height || "500px",
        }}
      >
        <iframe src={`${url}`} />
      </div>
    </Modal>
  );
});

export default Iframe;
