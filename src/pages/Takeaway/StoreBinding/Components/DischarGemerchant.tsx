import { Space, Button, Modal, message } from "antd";
import { useRef, useState, useImperativeHandle, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import styles from "./index.module.less";
import { ReactComponent as InfoSvg } from "../images/Info.svg";
import { useLoaderData } from "react-router-dom";
import { ExclamationCircleOutlined } from "@ant-design/icons";
import { channelAutharemoveMerchant, newGetMerchant } from "@src/Api/Takeaway/StoreAndItems";
export type IConfigRef = {
  open: (params: any) => void;
};

const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { pageUtils } = useLoaderData() as any;
  const { onChange, businessCodeOptions, onAuth, shopTitle } = props;
  const { t, i18n } = useTranslation(["Report", "Common"]);
  const [open, setOpen] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  const recordRef = useRef<any>({});

  const timerRef = useRef<any>(null);
  const countTimerRef = useRef<any>(null);
  const timeCountRef = useRef<number>(60);
  const getAuthState = useRef<any>({});
  const [timeCount, setTimeCount] = useState<number>(timeCountRef.current);
  const [btnLoading, setBtnLoading] = useState<boolean>(false);
  const [showRefresh, setShowRefresh] = useState<boolean>(false);
  const [url, setUrl] = useState<string>("");
  const [title, setTitle] = useState("");
  const [channel, setChannel] = useState("");
  const [id, setId] = useState("");

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { url, current, id, record, channelObj, merchants } = params;
      timeCountRef.current = 60;
      setTimeCount(60);
      if (merchants) {
        setTitle(merchants.title);
      }
      setId(id);
      setChannel(channelObj.channel);
      setOpen(true);
      setShowRefresh(false);
      if (record && Object.keys(record).length > 0) {
        recordRef.current = record;
      }
    },
  }));

  // 解除商户授权
  const disauthmerchants = (el: any, detype: string, index: number) => {
    channelAutharemoveMerchant({ id: el.id }).then((res: any) => {
      console.log("aaa");
    });
  };

  const handleCancel = () => {
    clearTimer();
    setOpen(false);
  };

  const onGetAuth = () => {
    setShowRefresh(true);
    // 打开自动获取
    buttonAutoTime();
    getAuthStatus();
  };
  const clearTimer = () => {
    if (countTimerRef.current) {
      clearTimeout(countTimerRef.current);
    }
    if (timerRef.current) {
      clearTimeout(timerRef.current);
    }
  };
  // 倒计时
  // 按钮状态倒计时
  const buttonAutoTime = () => {
    countTimerRef.current = setTimeout(() => {
      timeCountRef.current -= 1;
      setTimeCount(timeCountRef.current);
      if (timeCountRef.current <= 0) {
        setShowRefresh(false);
        timeCountRef.current = 60;
        setTimeCount(timeCountRef.current);
        clearTimer();
        return;
      }
      buttonAutoTime();
    }, 1000);
  };
  // 自动获取绑定结果
  const autoGetTime = () => {
    timerRef.current = setTimeout(() => {
      getAuthStatus();
    }, 3000);
  };
  const getAuthStatus = () => {
    newGetMerchant({ ...recordRef.current }).then((res) => {
      const { code, data = {} } = res;
      if (code === "000") {
        if (!recordRef.current.entityId) {
          if (data?.authStatus === "authorized") {
            // message.success("解除绑定成功");
            message.success(t("general.bindingUnsuccessful", { ns: "Financial" }));
            handleCancel();
            onChange?.();
          } else {
            autoGetTime();
          }
        } else {
          if (data?.authStatus != "authorized") {
            message.success(t("Takeaway.storeUntiedSuccessfully", { ns: "Takeaway" }));
            handleCancel();
            onChange?.();
          } else {
            autoGetTime();
          }
        }
      }
    });
  };

  return (
    <div>
      <Modal
        title={null}
        open={open}
        onCancel={() => {
          handleCancel();
        }}
        width={"700px"}
        footer={() => {
          return (
            <div className={styles.footerClass}>
              <span></span>
              <Space>
                <Button onClick={handleCancel}>{t("Takeaway.close", { ns: "Takeaway" })}</Button>
                <Button
                  type="primary"
                  style={
                    showRefresh
                      ? {
                          backgroundColor: "#C4C4C4",
                          color: "#fff",
                        }
                      : {}
                  }
                  onClick={() => {
                    if (!showRefresh) {
                      channelAutharemoveMerchant({
                        id: id,
                      }).then((res: any) => {
                        const { data, code } = res;
                        console.log("remove", res);
                        if (code != "000") return;
                        if (data.success) {
                          message.success(t("general.bindingUnsuccessful", { ns: "Financial" }));
                          // message.success("解除绑定成功");
                          handleCancel();
                          onChange?.();
                        } else if (!data.waiting) {
                          onGetAuth();
                        }
                      });
                    }
                  }}
                >
                  {showRefresh
                    ? `${t("Takeaway.gettheUntiedState", { ns: "Takeaway" })}（${timeCount}S）`
                    : t("locationclone.Ok", { ns: "BaseServe" })}
                </Button>
              </Space>
            </div>
          );
        }}
      >
        <div>
          <div className={styles.classConfim} style={{ alignItems: "flex-start" }}>
            <InfoSvg className="confimicon" style={{ fontSize: "22px" }} />
            <div style={{ width: "calc(100% - 32px)" }}>
              {/* <h2>确认解除“{title}”的授权吗？</h2> */}
              <h2>
                {t("mainBranch.confirmDissolveAuthorization", { ns: "Financial" })}“{title}”
                {t("mainBranch.confirmAuthorization", { ns: "Financial" })}
              </h2>
              <p style={{ color: "#FF0000" }}>
                {/* 解绑后，在该商户下授权绑定的门店，将全部失效，请谨慎操作 */}
                {t("productMap.beCarefulAfterUnbind", { ns: "Takeaway" })}
              </p>
            </div>
          </div>
        </div>
      </Modal>
    </div>
  );
});

export default View;
