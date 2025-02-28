// 外卖菜单弹层
import { Button, message, Tooltip } from "antd";
import { useState, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import { RedoOutlined } from "@ant-design/icons";
import { itemPull } from "@src/Api/Takeaway/takeoutDelivery";

export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { type, channelShopId, onChange } = props;
  const { t, i18n } = useTranslation();
  const [updateLoading, setUpdateLoading] = useState(false);

  // 同步三方商品
  const batchUpdateTrd = () => {
    setUpdateLoading(true);
    itemPull({ channelShopId: channelShopId })
      .then((res: any) => {
        setUpdateLoading(false);
        if (res.code == "000") {
          // message.success("已获取最新的三方平台商品信息同步至当前页面");
          message.success(t("productMap.syncThirdPartyProductInfo", { ns: "Takeaway" }));
          onChange?.();
        }
      })
      .catch(() => {
        setUpdateLoading(false);
      });
  };

  return (
    <>
      {type == "0" ? (
        <Button
          type="primary"
          ghost
          loading={updateLoading}
          onClick={() => {
            batchUpdateTrd();
          }}
        >
          {/* <Tooltip title="同步三方商品可获取最新三方商品信息"> */}
          <Tooltip title={t("productMap.syncToGetLatestThirdPartyProductInfo", { ns: "Takeaway" })}>
            {t("Takeaway.synchronizeThirdPartyProducts", { ns: "Takeaway" })}
          </Tooltip>
          {/* 同步三方商品 */}
        </Button>
      ) : (
        ""
      )}
      {type == 1 ? (
        <div className="text-center">
          <div className="pt-[20px]" style={{ color: " rgba(148, 148, 148, 1)" }}>
            {/* 暂无三方平台商品，同步三方商品可获取最新三方商品信息 */}
            {t("productMap.noThirdPartyProduct", { ns: "Takeaway" })}
          </div>
          <div className="pt-[20px]">
            <Button
              type="primary"
              loading={updateLoading}
              onClick={() => {
                batchUpdateTrd();
              }}
            >
              {t("Takeaway.synchronizeThirdPartyProducts", { ns: "Takeaway" })}
            </Button>
          </div>
        </div>
      ) : (
        ""
      )}

      {type == 2 ? (
        <span>
          {/* <Tooltip title="同步三方商品可获取最新三方商品信息"> */}
          <Tooltip title={t("productMap.syncToGetLatestThirdPartyProductInfo", { ns: "Takeaway" })}>
            <RedoOutlined
              spin={updateLoading}
              style={{ marginLeft: "2px", cursor: "pointer", color: "rgba(64, 120, 253, 1)" }}
              onClick={() => {
                batchUpdateTrd();
              }}
            />
          </Tooltip>
        </span>
      ) : (
        ""
      )}
    </>
  );
});

export default View;
