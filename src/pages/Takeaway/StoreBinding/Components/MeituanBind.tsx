import { Space, Button, Modal, message } from "antd";
import { useRef, useState, useImperativeHandle, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import styles from "./index.module.less";
import { useLoaderData } from "react-router-dom";
import { ExclamationCircleOutlined } from "@ant-design/icons";
import { newGetShop, newGetMerchant } from "@src/Api/Takeaway/StoreAndItems";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
import { ReactComponent as InfoSvg } from "../images/Info.svg";
export type IConfigRef = {
  open: (params: any) => void;
};

const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { onChange, businessCodeOptions, onAuth } = props;
  const { t, i18n } = useTranslation(["Report", "Common"]);
  const [open, setOpen] = useState<boolean>(false);
  const paramsRef = useRef<any>({});
  const recordRef = useRef<any>({});

  const timerRef = useRef<any>(null);
  const countTimerRef = useRef<any>(null);
  const timeCountRef = useRef<number>(60);
  const [timeCount, setTimeCount] = useState<number>(timeCountRef.current);
  const [btnLoading, setBtnLoading] = useState<boolean>(false);
  const [showRefresh, setShowRefresh] = useState<boolean>(false);
  const [url, setUrl] = useState<string>("");
  const [title, setTitle] = useState("");
  const [authType, setAuthType] = useState("");

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { url, record, merchants } = params;
      paramsRef.current = params;
      console.log("hhhhhh", params);
      setAuthType(params.authType || "");
      timeCountRef.current = 60;
      setTimeCount(60);
      if (merchants) {
        setTitle(merchants.title);
      }
      setOpen(true);
      setShowRefresh(false);
      setUrl(url || "");
      if (record && Object.keys(record).length > 0) {
        recordRef.current = record;
      }
      setTimeout(() => {
        const link = document.createElement("a");
        link.href = url;
        link.target = "_blank";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      }, 400);
    },
  }));

  const handleCancel = () => {
    clearTimer();
    setOpen(false);
  };

  const onGetAuth = () => {
    setShowRefresh(true);
    // 打开自动获取
    buttonAutoTime();
    console.log("recordRef.current", recordRef.current, authType);
    if (
      recordRef.current.shopId &&
      recordRef.current.channel &&
      // recordRef.current.channel != "uberEats"
      authType != "creatable"
    ) {
      // 门店轮训
      getAuthStatus();
    } else {
      // 商户轮训
      getAuthStateFn();
    }
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
        message.warning(t("general.authorizationRetry", { ns: "Financial" }));
        clearTimer();
        return;
      }
      buttonAutoTime();
    }, 1000);
  };
  // 授权商户轮训-ubereast
  const getAuthStateFn = () => {
    newGetMerchant({ ...recordRef.current }).then((authRes: any) => {
      setBtnLoading(false);
      const { code, data } = authRes;
      if (code != "000") return;
      if (data) {
        message.success({
          content: t("storeBind.bindSuccess", { ns: "Takeaway" }),
        });
        handleCancel();
        paramsRef.current.merchants.id = data.id;
        paramsRef.current.record.id = data.id;
        onChange?.(paramsRef.current);
      } else {
        timerRef.current = setTimeout(() => {
          getAuthStateFn();
        }, 3000);
      }
    });
  };
  // 门店授权轮训-美团
  const getAuthStatus = () => {
    newGetShop({ ...recordRef.current }).then((res) => {
      const { code, data = {} } = res;
      if (code === "000") {
        if (data) {
          message.success({
            content: t("storeBind.bindSuccess", { ns: "Takeaway" }),
          });
          handleCancel();
          onChange?.();
        } else {
          timerRef.current = setTimeout(() => {
            getAuthStatus();
          }, 3000);
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
        width={"600px"}
        footer={() => {
          return (
            <div className={styles.footerClass}>
              {/* <span>
                正在通过 [{title}] 进行授权
              </span> */}
              <span>
                {t("mainBranch.inProgressOfApprovalInfo", { ns: "Financial" })}{" "}
                [{title}] {t("mainBranch.authorizeInfo", { ns: "Financial" })}
              </span>
              <Space>
                <Button onClick={handleCancel}>
                  {t("Takeaway.close", { ns: "Takeaway" })}
                </Button>
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
                      onGetAuth();
                    }
                  }}
                >
                  {!recordRef.current.entityId
                    ? showRefresh
                      ? `${t("Takeaway.gettingTheAuthorizationStatus", {
                          ns: "Takeaway",
                        })}（${timeCount}S）`
                      : t("Takeaway.gettingAuthorizationStatus", {
                          ns: "Takeaway",
                        })
                    : showRefresh
                    ? `${t("Takeaway.gettheUntiedState", {
                        ns: "Takeaway",
                      })}（${timeCount}S）`
                    : t("Takeaway.gettheUntiedStatus", { ns: "Takeaway" })}
                </Button>
              </Space>
            </div>
          );
        }}
      >
        <div>
          <div
            className={styles.classConfim}
            style={{ alignItems: "flex-start" }}
          >
            <InfoSvg className="confimicon" style={{ fontSize: "22px" }} />
            <div style={{ width: "calc(100% - 32px)" }}>
              {!recordRef.current.entityId ? (
                <h2>
                  {t("Takeaway.operaTecompleteBinding", { ns: "Takeaway" })}
                </h2>
              ) : (
                <h2>
                  {t("Takeaway.operatethePopupunbinding", { ns: "Takeaway" })}
                </h2>
              )}
            </div>
          </div>
        </div>
      </Modal>
    </div>
  );
});

export default View;
