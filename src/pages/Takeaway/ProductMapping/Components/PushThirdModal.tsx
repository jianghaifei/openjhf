// 外卖菜单弹层
import { Button, Modal, message, Input, Radio, Form, Space } from "antd";
import { useRef, useState, useImperativeHandle, forwardRef } from "react";
import { useLoaderData } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import { SchemaForm, IFormRef } from "@restosuite/field-components";
import {
  publishMenuItems,
  upPublish,
  queryOptionResult,
  newQueryPublishResult,
  keetaTrditemPublish,
} from "@src/Api/Takeaway/StoreAndItems";
import { rootStore } from "@src/Store";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";

export type IConfigRef = {
  open: (params: any) => void;
};

const View = forwardRef<IConfigRef, any>((props, ref) => {
  const [form] = Form.useForm();
  const { title, menuInfo, query, onChange } = props;
  const { t, i18n } = useTranslation(["Report", "Common"]);
  const [open, setOpen] = useState<boolean>(false);
  const { pageUtils } = useLoaderData() as any;
  const [loading, setLoading] = useState<boolean>(false);
  const timeOutRef = useRef<any>(null);
  const basicFormRef = useRef<any>(null);

  const description: any = {
    hungryPanda: t("product.labelPublishMenuPandaTips", { ns: "Takeaway" }),
    urbanPiper: t("product.labelPublishMenuPiperTips", { ns: "Takeaway" }),
    grab: t("productMap.grabText", { ns: "Takeaway" }),
    chowly: t("product.labelPublishMenuChowlyTips", { ns: "Takeaway" }),
    foodPanda: t("productMap.foodPandaText", { ns: "Takeaway" }),
    deliveroo: t("productMap.deliverooText", { ns: "Takeaway" }),
    fantuan: t("productMap.fantuanText", { ns: "Takeaway" }),
    keeta: t("productMap.keetaText", { ns: "Takeaway" }),
  };

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      setOpen(true);
      console.log("channel", query);
    },
  }));

  const handleOk = async () => {
    const status = await basicFormRef.current?.validate();
    if (status) {
      const values = basicFormRef.current?.getValue();
      setLoading(true);
      const userInfo = rootStore.loginStore.getUserInfo();
      if (["chowly"].indexOf(query.channel) > -1) {
        // chowly默认一种
        values.publishType = "full";
      }
      if (
        ["chowly", "urbanPiper", "grab", "foodPanda", "fantuan", "deliveroo"].includes(
          query.channel
        )
      ) {
        const getStatus = (referenceId: string) => {
          const apiFetch = ["grab"].includes(query.channel)
            ? newQueryPublishResult
            : queryOptionResult;
          apiFetch({ referenceId }).then((res: any) => {
            if (res.code == "000") {
              if (
                res.data.success == "1" ||
                res.data.success == "2" ||
                res.data.status == "completed"
              ) {
                if (timeOutRef.current) {
                  clearTimeout(timeOutRef.current);
                }
                setLoading(false);
                message.success(t("project.alertPublishSuccess", { ns: "Takeaway" }));
                handleCancel();
                onChange?.();
              } else {
                timeOutRef.current = setTimeout(() => {
                  getStatus(referenceId);
                }, 3000);
              }
            }
          });
        };

        upPublish({
          shopIds: [query.shopId],
          platform: query.platform,
          menuId: menuInfo.menuId,
          publishType: values.publishType || "",
          visibilityImageUrl: values.visibilityImageUrl || "",
        })
          .then((res: any) => {
            const { code, data } = res;
            if (code === "000") {
              if (["chowly", "fantuan"].includes(query.channel)) {
                message.success(t("project.alertPublishSuccess", { ns: "Takeaway" }));
                handleCancel();
                setLoading(false);
                onChange?.();
              } else {
                getStatus(data[0].jobId);
              }
            } else {
              setLoading(false);
            }
          })
          .catch(() => {
            setLoading(false);
          });
      } else if (["keeta"].includes(query.channel)) {
        keetaTrditemPublish({
          channelShopId: (query.trd && query.trd.channelShopId) || "",
          platform: query.platform,
          menuId: menuInfo.menuId,
          flushAll: false,
        })
          .then((res: any) => {
            setLoading(false);
            const { code, data } = res;
            if (code === "000") {
              message.success(t("project.alertPublishSuccess", { ns: "Takeaway" }));
              handleCancel();
              onChange?.();
            }
          })
          .catch(() => {
            setLoading(false);
          });
      } else {
        publishMenuItems({
          shopIds: [query.shopId],
          platform: query.platform,
          menuId: menuInfo.menuId,
          publishType: values.publishType || "",
          publishOrg: userInfo?.orgType === "7" ? "shop" : "corp",
        })
          .then((res: any) => {
            setLoading(false);
            const { code, data } = res;
            if (code === "000") {
              message.success(t("project.alertPublishSuccess", { ns: "Takeaway" }));
              handleCancel();
              onChange?.();
            }
          })
          .catch(() => {
            setLoading(false);
          });
      }
    } else {
      message.warning(t("instant.informationIncomplete", { ns: "Takeaway" }));
    }
  };

  const handleCancel = () => {
    setOpen(false);
    if (timeOutRef.current) {
      clearTimeout(timeOutRef.current);
    }
  };

  return (
    <>
      <Modal
        title={<div>{title}</div>}
        open={open}
        destroyOnClose={true}
        width={"800px"}
        onCancel={handleCancel}
        className={`${stylesModel.customModal}`}
        footer={
          <div style={{ padding: "0 8px 0 16px" }}>
            <Space>
              <Button key="back" onClick={handleCancel}>
                {t(CommonEnum.CANCEL, { ns: "Common" })}
              </Button>
              <Button key="submit" type="primary" onClick={handleOk} loading={loading}>
                {t(CommonEnum.Publish, { ns: "Common" })}
              </Button>
            </Space>
          </div>
        }
      >
        <div style={{ padding: "10px 26px" }}>
          <SchemaForm
            ref={basicFormRef}
            formBlock={pageUtils.getBlockData("publishForm")}
            formMounted={() => {
              // 设置外卖菜单和门店的值
              basicFormRef.current?.setValue({
                publishMenuName: menuInfo.menuName,
                locationName: query?.treeRow?.name,
              });
              // 控制外卖菜单文本
              basicFormRef.current?.setDecoratorProps("publishMenuName", {
                feedbackText: [description[query.channel]],
              });
              // 控制未发布商品显示
              if (
                ["chowly", "grab", "foodPanda", "fantuan", "deliveroo", "keeta"].includes(
                  query.channel
                )
              ) {
                basicFormRef.current?.setFieldShowHide("publishType", false);
              } else {
                basicFormRef.current?.setFieldShowHide("publishType", true);
              }
              // 控制营业时间表显示
              if (["deliveroo"].includes(query.channel)) {
                basicFormRef.current?.setFieldShowHide("visibilityImageUrl", true);
              } else {
                basicFormRef.current?.setFieldShowHide("visibilityImageUrl", false);
              }
            }}
          ></SchemaForm>
        </div>
      </Modal>
    </>
  );
});

export default View;
