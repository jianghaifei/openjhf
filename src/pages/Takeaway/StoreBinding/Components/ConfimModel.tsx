import { Space, Modal } from "antd";
import { useState, useImperativeHandle, forwardRef } from "react";
import styles from "./index.module.less";
import { ReactComponent as InfoSvg } from "../images/Info.svg";
export type IConfigRef = {
  open: (params: any) => void;
};

const View = forwardRef<IConfigRef, any>((props, ref) => {
  const [open, setOpen] = useState<boolean>(false);
  const [info, setInfo] = useState<any>({});

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      setInfo(params);
      setOpen(true);
    },
    destroy(params: any = {}) {
      setOpen(false);
    },
  }));

  const handleCancel = () => {
    setOpen(false);
  };

  return (
    <div>
      <Modal
        title={info.title}
        open={open}
        onCancel={() => {
          handleCancel();
        }}
        zIndex={info.zIndex ? info.zIndex : 10000}
        width={info.width}
        footer={() => {
          return (
            <div className={styles.footerClass}>
              <span>{info.buttonText}</span>
              <Space>{info.buttonList}</Space>
            </div>
          );
        }}
      >
        <div className={styles.classConfim} style={info.text ? { alignItems: "flex-start" } : {}}>
          {info.icon ? info.icon : <InfoSvg className="confimicon" style={{ fontSize: "22px" }} />}
          <div style={{ width: "calc(100% - 32px)" }}>
            {info.textTitle ? <h2>{info.textTitle}</h2> : ""}
            {info.text ? info.text : ""}
          </div>
        </div>
      </Modal>
    </div>
  );
});

export default View;
