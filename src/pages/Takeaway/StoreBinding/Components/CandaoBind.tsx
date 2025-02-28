import { Space, Button, Modal, message } from "antd";
import { useRef, useState, useImperativeHandle, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import styles from "./index.module.less";
import { channelAuthaddShop } from "@src/Api/Takeaway/StoreAndItems";
import { ReactComponent as InfoSvg } from "../images/Info.svg";
import { ExclamationCircleOutlined } from "@ant-design/icons";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
export type IConfigRef = {
  open: (params: any) => void;
};

const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { onChange, businessCodeOptions, onSuccess } = props;
  const { t, i18n } = useTranslation(["Report", "Common"]);
  const [open, setOpen] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  const recordRef = useRef<any>({});
  const [title, setTitle] = useState("");
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { url, current, record, type, merchants } = params;
      recordRef.current = record || {};
      if (merchants) {
        setTitle(merchants.title);
      }
      setOpen(true);
    },
  }));

  const confimCancel = () => {
    setOpen(false);
  };

  const confimOk = () => {
    setLoading(true);
    channelAuthaddShop(recordRef.current)
      .then((res: any) => {
        setLoading(false);
        if (res.code != "000") {
          message.warning(t("storeBind.noAuthBusiness", { ns: "Takeaway" }));
          return;
        }
        if (res.data.success) {
          message.success(t("storeBind.getAuthSuccess", { ns: "Takeaway" }));
          onChange?.();
          confimCancel();
        }
      })
      .catch(() => {
        setLoading(false);
      });
  };
  return (
    <div>
      <Modal
        title={null}
        open={open}
        onCancel={() => {
          confimCancel();
        }}
        className={`${stylesModel.customModal} ${stylesModel.customModalnoTitle}`}
        width={"600px"}
        footer={() => {
          return (
            <div className={styles.footerClass}>
              <span>
                {t("mainBranch.inProgressOfApprovalInfo", { ns: "Financial" })} [{title}]{" "}
                {t("mainBranch.authorizeInfo", { ns: "Financial" })}
              </span>
              {/* <span>正在通过 [{title}] 进行授权</span> */}
              <Space>
                <Button onClick={confimCancel}>{t(CommonEnum.CANCEL, { ns: "Common" })}</Button>
                <Button type="primary" loading={loading} onClick={confimOk}>
                  {t(CommonEnum.CONFIRM, { ns: "Common" })}
                </Button>
              </Space>
            </div>
          );
        }}
      >
        <div>
          <div className={styles.classConfim}>
            <InfoSvg className="confimicon" style={{ fontSize: "22px" }} />
            <div style={{ width: "calc(100% - 32px)" }}>
              <h2>{t("storeBind.titleAreYouTrue", { ns: "Takeaway" })}？</h2>
            </div>
          </div>
        </div>
      </Modal>
    </div>
  );
});

export default View;
