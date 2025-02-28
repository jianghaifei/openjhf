import { Space, Button, Modal, message, TreeSelect } from "antd";
import { useState, useImperativeHandle, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import styles from "./index.module.less";
import { useSearchParams } from "react-router-dom";
import { CloseOutlined } from "@ant-design/icons";
import { categoryMap } from "@src/Api/Takeaway/takeoutDelivery";
import { findItemById } from "../../Components/IHelper";
export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { onChange, onDelete, dimensionaRow, categoryList, state } = props;
  const { t, i18n } = useTranslation();
  const [open, setOpen] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  const [classVal, setClassVal] = useState("");
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { record } = params;
      setOpen(true);
      setClassVal("");
    },
  }));

  const confimCancel = () => {
    setOpen(false);
  };

  const confimOk = () => {
    const categoryName = findItemById(categoryList, classVal) || "";
    const params = {
      channelShopId: state.channelShopId,
      menuId: state.menuId,
      byItems: dimensionaRow.map((el: any) => {
        return {
          trdItemId: el.trdItemId,
          trdItemName: el.trdItemName,
          categoryId: classVal,
          categoryName,
        };
      }),
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
        title={t("instant.selectUnboundProducts", { ns: "Takeaway" })}
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
              <span>{t("takeaway.txtTrdMenu", { ns: "Takeaway" })}</span>
            </h1>
            <div>
              <ul>
                {dimensionaRow.map((el: any, index: number) => (
                  <li key={index}>
                    <i>
                      {el.trdItemName}/{el.trdUnitName || "-"}[{el.trdPrice}]
                    </i>
                    <CloseOutlined
                      onClick={() => {
                        onDelete?.(el);
                      }}
                    />
                  </li>
                ))}
              </ul>
              <h2>
                {t("instant.selectedProduct", {
                  ns: "Takeaway",
                  name: dimensionaRow.length,
                })}
                {/* 已选：<b>{dimensionaRow.length}</b>商品 */}
              </h2>
            </div>
          </div>

          <div className={styles.thirdLi}>
            <h1>
              <i></i>
              <span>
                {/* 商品分类 */}
                {t("instant.productCategory", { ns: "Takeaway" })}
              </span>
            </h1>
            <div>
              <TreeSelect
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
                {/* 不设置商品分类时，将按默认商品分类处理；如后续未绑定的三方平台商品被绑定本地商品后，商品分类将被更新为本地菜品的菜品分类 */}
                {t("instant.defaultCategoryHandling", { ns: "Takeaway" })}
              </p>
            </div>
          </div>
        </div>
      </Modal>
    </div>
  );
});

export default View;
