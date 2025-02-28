import { Space, Button, Modal, message } from "antd";
import { useRef, useState, useImperativeHandle, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import styles from "./index.module.less";
import { newRemoveShop, newGetShop } from "@src/Api/Takeaway/StoreAndItems";
import { ReactComponent as InfoSvg } from "../images/Info.svg";
export type IConfigRef = {
  open: (params: any) => void;
};

const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { onChange, businessCodeOptions, onAuth, shopTitle } = props;
  const { t, i18n } = useTranslation(["Report", "Common"]);
  const [open, setOpen] = useState<boolean>(false);
  const recordRef = useRef<any>({});
  const timerRef = useRef<any>(null);
  const countTimerRef = useRef<any>(null);
  const timeCountRef = useRef<number>(60);
  const [timeCount, setTimeCount] = useState<number>(timeCountRef.current);
  const [btnLoading, setBtnLoading] = useState<boolean>(false);
  const [showRefresh, setShowRefresh] = useState<boolean>(false);
  const [title, setTitle] = useState("");
  const [channel, setChannel] = useState("");
  const [id, setId] = useState("");
  const [mlabel, setMlabel] = useState("");
  const [url, setUrl] = useState("");
  const [confimOpen, setConfimOpen] = useState(false);
  const [unBingForce, setUnBingForce] = useState(false);

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { url, current, authId, record, label, channelObj, merchants } = params;
      timeCountRef.current = 60;
      setTimeCount(60);
      if (channelObj) {
        setTitle(channelObj.label);
      }
      if (label) {
        setMlabel(label);
      }
      setUnBingForce(false);
      setId(record.id || authId);
      setChannel(record.channel);
      setOpen(true);
      setShowRefresh(false);
      if (record && Object.keys(record).length > 0) {
        recordRef.current = record;
      }
      if (url) {
        setUrl(url);
        setTimeout(() => {
          const link = document.createElement("a");
          link.href = url;
          link.target = "_blank";
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
        }, 400);
      }
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
        setUnBingForce(true);
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
    newGetShop({ ...recordRef.current }).then((res) => {
      const { code, data = {} } = res;
      if (code === "000") {
        if (!data || JSON.stringify(data) == "{}" || !data.id) {
          // message.success("解除绑定成功");
          message.success(t("general.bindingUnsuccessful", { ns: "Financial" }));
          handleCancel();
          onChange?.();
        } else {
          autoGetTime();
        }
      }
    });
  };

  return (
    <div>
      <Modal
        title={""}
        open={open}
        onCancel={() => {
          handleCancel();
        }}
        width={"600px"}
        footer={() => {
          return (
            <div className={styles.footerClass}>
              {/* <span>正在通过 [{title}] 解除授权</span> */}
              <span>
                {t("mainBranch.inProgressOfApprovalInfo", { ns: "Financial" })} [{title}]{" "}
                {t("mainBranch.removeAuthorizationInfo", { ns: "Financial" })}
              </span>
              <Space>
                <Button onClick={handleCancel}>{t("Takeaway.close", { ns: "Takeaway" })}</Button>
                <Button
                  type="primary"
                  loading={btnLoading}
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
                      if (channel == "meituan") {
                        onGetAuth();
                      } else {
                        setBtnLoading(true);
                        newRemoveShop({
                          id: id,
                        })
                          .then((res: any) => {
                            setBtnLoading(false);
                            const { data, code } = res;
                            console.log("remove", res);
                            if (code != "000") return;
                            if (data.success) {
                              // message.success("解除绑定成功");
                              message.success(
                                t("general.bindingUnsuccessful", { ns: "Financial" })
                              );
                              handleCancel();
                              onChange?.();
                            } else if (!data.waiting) {
                              onGetAuth();
                            }
                          })
                          .catch(() => {
                            setBtnLoading(false);
                          });
                      }
                    }
                  }}
                >
                  {showRefresh
                    ? `${t("Takeaway.gettheUntiedState", { ns: "Takeaway" })}（${timeCount}S）`
                    : channel == "meituan"
                    ? t("Takeaway.gettheUntiedStatus", { ns: "Takeaway" })
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
              {channel == "meituan" ? (
                <>
                  <h2>{t("Takeaway.operatethePopupunbinding", { ns: "Takeaway" })}</h2>
                  {unBingForce ? (
                    <p>
                      {t("productMap.unableToRemoveBinding", { ns: "Takeaway" })}
                      {/* 无法完成解绑，需单方面强制移除？ */}
                      <span
                        onClick={() => {
                          setOpen(false);
                          setConfimOpen(true);
                        }}
                      >
                        {t("productMap.forceRemoval", { ns: "Takeaway" })}
                        {/* 强制移除 */}
                      </span>
                    </p>
                  ) : (
                    ""
                  )}
                </>
              ) : (
                <>
                  <h2>
                    {t("product.confirmUnbindStore", {
                      ns: "Takeaway",
                    })}
                  </h2>
                </>
              )}
            </div>
          </div>
        </div>
      </Modal>
      <Modal
        title={null}
        open={confimOpen}
        onCancel={() => {
          setConfimOpen(false);
        }}
        width={"600px"}
        footer={() => {
          return (
            <div className={styles.footerClass}>
              <span></span>
              <Space>
                <Button
                  onClick={() => {
                    setConfimOpen(false);
                  }}
                >
                  {t("Takeaway.close", { ns: "Takeaway" })}
                </Button>
                <Button
                  type="primary"
                  loading={btnLoading}
                  style={
                    showRefresh
                      ? {
                          backgroundColor: "#C4C4C4",
                          color: "#fff",
                        }
                      : {}
                  }
                  onClick={() => {
                    setBtnLoading(true);
                    newRemoveShop({
                      id: id,
                      force: true,
                    })
                      .then((res: any) => {
                        setBtnLoading(false);
                        const { data, code } = res;
                        if (code != "000") return;
                        if (data.success) {
                          // message.success("解除绑定成功");
                          // message.success("已单方面强制移除");
                          message.success(t("productMap.alreadyForceRemoved", { ns: "Takeaway" }));

                          setConfimOpen(false);
                          onChange?.();
                        } else {
                          message.warning(res.msg);
                        }
                      })
                      .catch(() => {
                        setBtnLoading(false);
                      });
                  }}
                >
                  {/* 确认强制移除 */}
                  {t("productMap.confirmForceRemoval", { ns: "Takeaway" })}
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
              {/* <h2>确认单方面强制移除当前已绑定的三方平台门店吗？</h2> */}
              <h2>{t("productMap.confirmUnilateralForceRemoval", { ns: "Takeaway" })}?</h2>
              {/* <p style={{ color: "#FF0000" }}>
                强制移除前，请先确认您的三方平台门店已真的解除绑定，否则可能导致无法再次绑定该三方平台门店，请谨慎操作，自负后果
              </p> */}
              <p style={{ color: "#FF0000" }}>
                {t("productMap.beforeForceRemovalConfirm", { ns: "Takeaway" })}
              </p>
            </div>
          </div>
        </div>
      </Modal>
    </div>
  );
});

export default View;
