import { Button, Modal, message, Spin, Segmented } from "antd";
import { useRef, useState, useImperativeHandle, forwardRef } from "react";
import { CloseOutlined } from "@ant-design/icons";
import { useTranslation } from "react-i18next";
import styles from "./index.module.less";
import {
  merchantlistMerchant,
  merchantChannelsForAddShop,
  newRemoveShop,
} from "@src/Api/Takeaway/StoreAndItems";
import _ from "lodash";
import DischarGemerchant from "./DischarGemerchant";
import ConfimModel from "./ConfimModel";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const {
    onChange,
    threeLevelLinkageLanguage,
    onDischarge,
    onCloseBing,
    shopTitle,
  } = props;
  const { t, i18n } = useTranslation();
  const recordRef = useRef<any>({});
  const DischarGemeref = useRef<any>({});

  const [title, setTitle] = useState("");
  const [channelObj, setChannelObj] = useState<any>({});
  const [open, setOpen] = useState<boolean>(false);
  const [isShop, setIsShop] = useState(false);
  const [loading, setLoading] = useState<boolean>(false);
  const [allData, setAllData] = useState<any>(null);
  const [currentData, setCurrentData] = useState<any>(null);

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const { modelTitle, typeObj, current, record, isShop } = params;
      setIsShop(isShop);
      setCurrentData(null);
      setAllData(null);
      if (modelTitle) {
        setTitle(modelTitle);
      } else {
        setTitle("");
      }
      recordRef.current = record || {};

      setChannelObj(typeObj);
      setOpen(true);

      getmerchantlistMerchant(isShop);
    },
  }));

  // 获取授权模式
  const getmerchantlistMerchant = (resShop: boolean) => {
    setLoading(true);
    const languageObj: any = {};
    const thirdConfiguration: any = threeLevelLinkageLanguage;
    if (thirdConfiguration?.contentLanguageList) {
      thirdConfiguration.contentLanguageList.forEach((item: any) => {
        if (!languageObj[item.key]) {
          languageObj[item.key] = {};
        }
        languageObj[item.key][item.languageCode] = item.text;
      });
    }
    const apifetch = resShop
      ? merchantChannelsForAddShop
      : merchantlistMerchant;
    apifetch({
      shopId: recordRef.current.shopId,
      platform: recordRef.current.platform,
    })
      .then((res: any) => {
        setLoading(false);
        const { code, data } = res;
        if (code != "000") return;
        const businessesList = data.businesses.map((el: any, index: number) => {
          // 判断当前授权业务是否有已经授权的模式
          let num = 0;
          for (const i in el) {
            if (i != "business") {
              el[i].forEach((item: any) => {
                if (item.authed) {
                  num++;
                }
              });
            }
          }
          if (num > 0) {
            el.authed = true;
          } else {
            el.authed = false;
          }

          // 换取channel多语
          el.label = languageObj[el.business]
            ? languageObj[el.business][i18n.language]
            : el.business || "";
          // 默认选中第一个授权业务
          if (index == 0) {
            el.active = true;
          } else {
            el.active = false;
          }
          // 判断显示提示文本
          if (
            el.creatable.length > 0 ||
            el.merchants.length > 0 ||
            el.system.length > 0
          ) {
            el.isText = true;
          } else {
            el.isText = false;
          }
          el.value = index;

          return el;
        });
        setAllData(businessesList);
        setCurrentData(businessesList.filter((el: any) => el.active)[0]);
      })
      .catch(() => {
        setLoading(false);
      });
  };

  // 授权业务切换
  const OperazionilistFn = (el: any, index: number) => {
    console.log("pppppp", el);
    const newOperazionilist = _.cloneDeep(allData);
    const businessesList = newOperazionilist.map((item: any) => {
      item.active = false;
      if (el.value == item.value) {
        item.active = true;
      }
      return item;
    });
    setAllData(businessesList);
    setCurrentData(businessesList.filter((el: any) => el.active)[0]);
  };

  // 关闭多通道弹窗
  const handleCancel = () => {
    setOpen(false);
  };

  // 去授权
  const authorization = (el?: any, current?: any, authType?: string) => {
    onChange?.({
      record: recordRef.current,
      selectNode: el,
      current,
      isShop,
      selectBusiness: currentData.business,
      channel: el.channel,
      merchants: el,
      authType,
    });
    handleCancel();
  };

  // 解除授权门店
  const disauthorization = (el: any, detype: string, index: number) => {
    if (!el.authId) {
      return;
    }

    if (el.channel == "meituan") {
      newRemoveShop({
        id: el.authId,
      }).then((res: any) => {
        const { data, code } = res;
        if (code != "000") return;
        if (data.success) {
          message.success(
            t("general.bindingUnsuccessful", { ns: "Financial" })
          );
          onCloseBing?.();
        } else {
          onDischarge?.({
            data,
            el,
            channelObj,
            record: {
              business: currentData.business,
              channel: el.channel,
              corporationId: recordRef.current.corporationId,
              shopId: recordRef.current.shopId,
              platform: recordRef.current.platform,
            },
            label: currentData.label,
          });
        }
      });
    } else {
      onDischarge?.({
        el,
        channelObj,
        record: {
          business: currentData.business,
          channel: el.channel,
          corporationId: recordRef.current.corporationId,
          shopId: recordRef.current.shopId,
          platform: recordRef.current.platform,
        },
        label: currentData.label,
      });
    }
    handleCancel();
  };
  // 控制按钮
  const Controls = (
    el: any,
    index: any,
    detype: any,
    authType: any,
    current: number
  ) => {
    return (
      <div>
        {el.authed ? (
          <Button
            type="primary"
            ghost
            onClick={() => disauthorization(el, detype, index)}
          >
            {/* 解除授权 */}
            {currentData.business == "miaoti"
              ? t("instant.deactivateService", { ns: "Takeaway" })
              : t("general.authorizationRevoke", { ns: "Financial" })}
          </Button>
        ) : (
          <Button
            type="primary"
            disabled={currentData.authed}
            onClick={() => {
              authorization(el, current, authType);
            }}
          >
            {currentData.business == "miaoti"
              ? t("instant.activateService", { ns: "Takeaway" })
              : t("Takeaway.Deauthorization", { ns: "Takeaway" })}
          </Button>
        )}
      </div>
    );
  };

  return (
    <>
      <Modal
        title={
          title
            ? title
            : `${shopTitle[channelObj.key] || channelObj.key} ${t(
                "Takeaway.storeAuthorizationBinding",
                {
                  ns: "Takeaway",
                }
              )}`
        }
        className={`${stylesModel.customModal}`}
        zIndex={98}
        open={open}
        destroyOnClose={true}
        width={800}
        footer={null}
        onCancel={handleCancel}
      >
        <Spin spinning={loading}>
          <div className={styles.generalbox}>
            {/* 授权门店 */}
            {isShop ? (
              <dl>
                <dd>{t("Takeaway.authorizedStore", { ns: "Takeaway" })}：</dd>
                <h3>{recordRef.current.shopName}</h3>
              </dl>
            ) : (
              ""
            )}
            {/* 授权业务 */}
            <dl>
              <dd>
                {t("Takeaway.authorizationBusiness", { ns: "Takeaway" })}：
              </dd>
              <ol className="generalOperazioni">
                {allData ? (
                  <Segmented<string>
                    options={
                      allData &&
                      allData.map((el: any) => {
                        return {
                          label: el.label,
                          value: el.value,
                        };
                      })
                    }
                    onChange={(value) => {
                      const index =
                        allData.findIndex((el: any) => el.value == value) || 0;
                      OperazionilistFn(allData[index], index);
                    }}
                  />
                ) : (
                  ""
                )}

                {/* {allData &&
                  allData.map((el: any, index: number) => (
                    <li
                      key={index}
                      style={
                        el.active
                          ? {
                              background: "var(--Light2, #E7ECFF)",
                              border: "1px solid var(--Hover, #B1C3FF)",
                              color: "var(--Master, #4078FD)",
                            }
                          : {}
                      }
                      onClick={() => OperazionilistFn(el, index)}
                    >
                      <span>{el.label}</span>
                    </li>
                  ))} */}
              </ol>
            </dl>
            {/* 已授权商户 */}
            {!isShop ? (
              <dl>
                <dd>
                  {t("general.authorizedMerchant", { ns: "Financial" })}：
                </dd>
                <div style={{ width: "calc(100% - 200px)" }}>
                  {currentData &&
                    currentData.merchants &&
                    currentData.merchants.map((el: any, index: number) => (
                      <div className={styles.merchantsclas}>
                        <ul key={index} style={{ margin: "0" }}>
                          <li>
                            <b>
                              {t("Takeaway.Merchantid", { ns: "Takeaway" })}：
                            </b>
                            <i>{el.platformId}</i>
                          </li>
                          <li>
                            <b>
                              {t("SettlementAccount.MerchantName", {
                                ns: "Financial",
                              })}
                              ：
                            </b>
                            <i>{el.platformName}</i>
                          </li>
                          <li>
                            <b>
                              {t("mainBranch.authorizationMode", {
                                ns: "Financial",
                              })}
                              ：
                            </b>
                            <i>{el.channel}</i>
                          </li>
                        </ul>
                        <div className="unbingbox">
                          {/* {[IRequestEnvEnm.Dev, IRequestEnvEnm.Test, IRequestEnvEnm.Uat].includes(
                          GlobalConfig.currentEnv as IRequestEnvEnm
                        ) ? (
                          <Button
                            type="primary"
                            shape="round"
                            ghost
                            onClick={() => {
                              handleCancel();
                              DischarGemeref.current?.open({
                                record: el,
                                id: el.id,
                                merchants: el,
                                channelObj,
                              });
                            }}
                          >
                            {t("general.authorizationRevoke", { ns: "Financial" })}
                          </Button>
                        ) : (
                          ""
                        )} */}
                          <CloseOutlined
                            className="unbingShanghu"
                            onClick={() => {
                              handleCancel();
                              DischarGemeref.current?.open({
                                record: el,
                                id: el.id,
                                merchants: el,
                                channelObj,
                              });
                            }}
                          />
                        </div>
                      </div>
                    ))}
                  {currentData &&
                  currentData.merchants &&
                  currentData.merchants.length == 0 ? (
                    <div>
                      {/* 暂无已授权商户 */}
                      {t("general.authorizedMerchants", { ns: "Financial" })}
                    </div>
                  ) : (
                    ""
                  )}
                </div>
              </dl>
            ) : (
              ""
            )}
            {/* 授权模式 */}
            <dl>
              <dd>{t("Takeaway.authorizationModel", { ns: "Takeaway" })}：</dd>
              {currentData && currentData.isText ? (
                <ol className="generalModello">
                  {isShop ? (
                    <div>
                      {currentData && currentData.merchants.length > 0 ? (
                        <h6>
                          {t("general.bindStoreAuthorized", {
                            ns: "Financial",
                          })}
                        </h6>
                      ) : (
                        ""
                      )}
                      {currentData &&
                        currentData.merchants.map((el: any, index: number) => (
                          <li key={index}>
                            <div>
                              <h1
                                style={
                                  !el.authed && currentData.authed
                                    ? { color: "#686868" }
                                    : {}
                                }
                              >
                                {el.title}
                              </h1>
                              <h2>
                                {/* 通过 {el.subTitle} 商户进行门店授权 */}
                                {el.subTitle}
                              </h2>
                            </div>
                            <div>
                              {Controls(el, index, "merchants", "merchants", 1)}
                            </div>
                          </li>
                        ))}
                    </div>
                  ) : (
                    ""
                  )}

                  {isShop ? (
                    <h6>
                      {/* 选择授权模式绑定门店 */}
                      {t("general.selectBindMode", { ns: "Financial" })}
                    </h6>
                  ) : (
                    <h6>{t("general.newMerchantAuth", { ns: "Financial" })}</h6>
                  )}

                  {currentData &&
                    currentData.system &&
                    currentData.system.map((el: any, index: number) => (
                      <li key={index}>
                        <div>
                          <h1
                            style={
                              !el.authed && currentData.authed
                                ? { color: "#686868" }
                                : {}
                            }
                          >
                            {el.title}
                          </h1>
                          <h2>{el.subTitle}</h2>
                        </div>
                        <div>{Controls(el, index, "system", "system", 0)}</div>
                      </li>
                    ))}

                  {currentData &&
                    currentData.creatable &&
                    currentData.creatable.map((el: any, index: number) => (
                      <li key={index}>
                        <div>
                          <h1
                            style={
                              !el.authed && currentData.authed
                                ? { color: "#686868" }
                                : {}
                            }
                          >
                            {el.title}
                          </h1>
                          <h2>{el.subTitle}</h2>
                        </div>
                        <div>
                          {Controls(el, index, "creatable", "creatable", 0)}
                        </div>
                      </li>
                    ))}
                </ol>
              ) : (
                <div className="generalEmpty">
                  {currentData ? (
                    <div>
                      {(currentData.merchants &&
                        currentData.merchants.length > 0) ||
                      (currentData.creatable &&
                        currentData.creatable.length > 0) ||
                      (currentData.system && currentData.system.length > 0) ? (
                        <span></span>
                      ) : (
                        // 没有查询到相应的授权模式，请联系管理员
                        <span>
                          {t("Takeaway.noAuthorizationModeFound", {
                            ns: "Takeaway",
                          })}
                        </span>
                      )}
                    </div>
                  ) : (
                    ""
                  )}
                </div>
              )}
            </dl>
          </div>
        </Spin>
      </Modal>

      <DischarGemerchant
        ref={DischarGemeref}
        onChange={() => {
          getmerchantlistMerchant(isShop);
        }}
      />
    </>
  );
});

export default View;
