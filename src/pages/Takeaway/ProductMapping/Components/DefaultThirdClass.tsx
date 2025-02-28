import { Space, Button, Modal, message, TreeSelect } from "antd";
import { useState, useImperativeHandle, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import styles from "./index.module.less";
import { useSearchParams } from "react-router-dom";
import { categoryMap } from "@src/Api/Takeaway/takeoutDelivery";
import { findItemById } from "../../Components/IHelper";
export type IConfigRef = {
  open: (params: any) => void;
};

const View = forwardRef<IConfigRef, any>((props, ref) => {
  const [searchParams] = useSearchParams();
  const { onChange, categoryInfo, categoryList, state } = props;
  const { t, i18n } = useTranslation();
  const [open, setOpen] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  const [classVal, setClassVal] = useState("");
  const [error, setError] = useState<any>("");
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      setOpen(true);
      setClassVal("");
      setError("");
    },
  }));

  const confimCancel = () => {
    setOpen(false);
  };

  const confimOk = () => {
    if (!classVal) {
      setError("error");
    }
    const categoryName = findItemById(categoryList, classVal) || "";

    const params = {
      channelShopId: state.channelShopId,
      menuId: state.menuId,
      defaultName: categoryName,
      defaultId: classVal,
    };

    setLoading(true);
    categoryMap(params)
      .then((res: any) => {
        setLoading(false);
        if (res.code == "000") {
          message.success(t("instant.categorySetSuccess", { ns: "Takeaway" }));
          setOpen(false);
          onChange();
        }
      })
      .catch(() => {
        setLoading(false);
      });
  };
  const onChangeTree = (newValue: string) => {
    setClassVal(newValue);
  };

  return (
    <div>
      <Modal
        title={t("instant.setDefaultCategory", { ns: "Takeaway" })}
        open={open}
        onCancel={() => {
          confimCancel();
        }}
        width={"800px"}
        footer={() => {
          return (
            <div className={styles.footerClass}>
              <span></span>
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
        <div style={{ padding: "10px 0" }}>
          <div className={styles.thirdLi}>
            <h1>
              <i>*</i>
              <span>
                {/* 当前默认商品分类 */}
                {t("instant.currentDefaultCategory", { ns: "Takeaway" })}
              </span>
            </h1>
            <div>
              <h3>{categoryInfo.defaultName}</h3>
            </div>
          </div>

          <div className={styles.thirdLi}>
            <h1>
              <i>*</i>
              <span>{t("productMap.defaultProductCategory", { ns: "Takeaway" })}</span>
            </h1>
            <div>
              <TreeSelect
                status={error}
                treeNodeFilterProp="name"
                showSearch
                style={{ width: "100%" }}
                value={classVal ? classVal : undefined}
                dropdownStyle={{ maxHeight: 400, overflow: "auto" }}
                placeholder={t("instant.pleaseSelect", { ns: "Takeaway" })}
                allowClear
                treeDefaultExpandAll
                onChange={onChangeTree}
                treeData={categoryList}
              />
              <p>
                {t("instant.unboundProductsHandling", { ns: "Takeaway" })}
                {/* 未绑定的三方平台商品，落单时如未自动匹配到本地菜品，则按商品的商品分类进行处理，无商品分类时，按默认商品分类 */}
              </p>
            </div>
          </div>
        </div>
      </Modal>
    </div>
  );
});

export default View;
