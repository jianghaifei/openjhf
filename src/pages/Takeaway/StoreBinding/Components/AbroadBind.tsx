import { Space, Button, Modal, message } from "antd";
import { useRef, useState, useImperativeHandle, forwardRef } from "react";
import { useLoaderData } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import { newGetShop, channelAuthaddShop } from "@src/Api/Takeaway/StoreAndItems";
import { IFormRef, SchemaForm } from "@restosuite/field-components";
import styles from "./index.module.less";
import _ from "lodash";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";

export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { typeObj, onChange, shopTitle } = props;
  const { t, i18n } = useTranslation(["Report", "Common"]);
  const [open, setOpen] = useState<boolean>(false);
  const formRef = useRef<IFormRef>(null);
  const [type, setType] = useState<string>("");
  const [record, setRecord] = useState<any>({});
  const [basicBlock, setBasicBlock] = useState<any>({});
  const [title, setTitle] = useState<string>("");
  const [form, setForm] = useState<any>(null);

  const countTimerRef = useRef<any>(null);
  const timeCountRef = useRef<number>(60);
  const getAuthState = useRef<any>({});
  const [timeCount, setTimeCount] = useState<number>(timeCountRef.current);
  const [showRefresh, setShowRefresh] = useState<boolean>(false);
  const [btnLoading, setBtnLoading] = useState<boolean>(false);

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { type, block, record, merchants, form } = params;

      if (form && form.fields && form.fields.length > 0) {
        setForm(form);
      }
      setType(typeObj.key);
      // 每次进入弹窗重制倒计时
      timeCountRef.current = 60;
      setTimeCount(60);
      setShowRefresh(false);

      setOpen(true);
      if (merchants) {
        setTitle(merchants.title);
      }

      if (record && Object.keys(record).length > 0) {
        setRecord(record);
      }
      if (block) {
        setBasicBlock(block);
      }
    },
  }));

  // 倒计时
  const clearTimer = () => {
    if (getAuthState.current.timeOut) {
      clearTimeout(getAuthState.current.timeOut);
    }
    if (countTimerRef.current) {
      clearTimeout(countTimerRef.current);
    }
    getAuthState.current.state = false;
  };

  // 按钮状态倒计时
  const buttonAutoTime = () => {
    countTimerRef.current = setTimeout(() => {
      timeCountRef.current -= 1;
      setTimeCount(timeCountRef.current);
      if (timeCountRef.current <= 0) {
        setShowRefresh(false);
        timeCountRef.current = 60;
        clearTimer();
        setTimeCount(timeCountRef.current);
        // message.warning("暂未获取到授权，稍后重试");
        message.warning(t("general.authorizationRetry", { ns: "Financial" }));
        return;
      }
      buttonAutoTime();
    }, 1000);
  };

  const getAuthStateFn = () => {
    newGetShop({ ...record }).then((res: any) => {
      const { code, data } = res;
      if (code != "000") return;
      if (data) {
        message.success({
          content: t("storeBind.bindSuccess", { ns: "Takeaway" }),
        });
        handleCancel();
        onChange?.();
        clearTimer();
      } else {
        getAuthState.current.timeOut = setTimeout(() => {
          getAuthStateFn();
        }, 3000);
      }
    });
  };

  const handleOk = async () => {
    const status = await formRef.current?.validate();
    if (status) {
      const value = formRef.current?.getValue();

      const newForm = _.cloneDeep(form);
      newForm.fields = newForm.fields.map((el: any) => {
        for (const i in value) {
          if (el.name == i) {
            el.value = value[i];
          }
        }
        return el;
      });
      setBtnLoading(true);
      channelAuthaddShop({
        ...record,
        form: newForm,
      })
        .then((res: any) => {
          setBtnLoading(false);
          const { data, code } = res;
          if (code != "000") return;
          if (data.success) {
            message.success({
              content: t("storeBind.bindSuccess", { ns: "Takeaway" }),
            });
            handleCancel();
            onChange?.();
          } else if (data.waiting) {
            getAuthState.current.state = true;
            setShowRefresh(true);
            buttonAutoTime();
            getAuthStateFn();
          }
        })
        .catch(() => {
          setBtnLoading(false);
        });
    }
  };

  const handleCancel = () => {
    setOpen(false);
    clearTimer();
  };

  const handleBasicFormMounted = () => {
    console.log("handleBasicFormMounted");
  };

  return (
    <>
      <Modal
        title={t("general.bindStoreAuthName", {
          ns: "Financial",
          name: `${title} `,
        })}
        open={open}
        className={`${stylesModel.customModal}`}
        destroyOnClose={true}
        width={800}
        footer={
          <div className={styles.footerClass} style={{ padding: "0 8px 0 16px" }}>
            <span>
              {t("mainBranch.inProgressOfApprovalInfo", { ns: "Financial" })} [{title}]{" "}
              {t("mainBranch.authorizeInfo", { ns: "Financial" })}
            </span>
            {/* <span>正在通过 [{title}] 进行授权</span> */}
            <Space>
              <Button
                onClick={() => {
                  handleCancel();
                }}
              >
                {t(CommonEnum.CANCEL, { ns: "Common" })}
              </Button>
              {showRefresh ? (
                <Button
                  type="primary"
                  style={{
                    backgroundColor: "#C4C4C4",
                    color: "#fff",
                  }}
                >
                  {/* 获取授权状态中 */}
                  {t("Takeaway.gettingTheAuthorizationStatus", {
                    ns: "Takeaway",
                  })}
                  （{timeCount}S）
                </Button>
              ) : (
                <Button
                  type="primary"
                  loading={btnLoading}
                  onClick={() => {
                    handleOk();
                  }}
                >
                  {t(CommonEnum.CONFIRM, { ns: "Common" })}
                </Button>
              )}
            </Space>
          </div>
        }
        onCancel={handleCancel}
      >
        <div style={{ padding: "10px 30px" }}>
          <div className="text-[14px] pb-[15px] pt-[15px]">
            {t("common.Locations", { ns: "Common" })}：{record.shopName}（ID：
            {record.shopId}）
          </div>
          <SchemaForm
            formBlock={basicBlock}
            ref={formRef}
            formMounted={handleBasicFormMounted}
          ></SchemaForm>
        </div>
      </Modal>
    </>
  );
});

export default View;
