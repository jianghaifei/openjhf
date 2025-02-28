import { Space, Button, Modal, message, Empty, Radio, Spin, Steps } from "antd";
import { useRef, useState, useImperativeHandle, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import styles from "./index.module.less";
import {
  newGetMerchant,
  newAddMerchant,
  channelAuthaddShop,
  newGetShop,
} from "@src/Api/Takeaway/StoreAndItems";
import MeituanBind from "./MeituanBind";
import { IFormRef, SchemaForm } from "@restosuite/field-components";
import _ from "lodash";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";

export type IConfigRef = {
  open: (params: any) => void;
};
const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { onChange, onAuth, shopTitle } = props;
  const { t, i18n } = useTranslation(["Report", "Common"]);
  const [open, setOpen] = useState<boolean>(false);
  const [current, setCurrent] = useState<number>(0);
  const [list, setList] = useState<any[]>([]);
  const [authUrl, setAuthUrl] = useState<string>("");
  const [btnLoading, setBtnLoading] = useState<boolean>(false);
  const [dataLoading, setDataLoading] = useState<boolean>(false);
  const recordRef = useRef<any>({});
  const basicFormRef = useRef<IFormRef>(null);
  const shopRef = useRef<IFormRef>(null);
  const countTimerRef = useRef<any>(null);
  const timeCountRef = useRef<number>(60);
  const [timeCount, setTimeCount] = useState<number>(timeCountRef.current);
  const [showRefresh, setShowRefresh] = useState<boolean>(false);
  const getAuthState = useRef<any>({});
  const [authType, setAuthType] = useState("");
  const [title, setTitle] = useState("");
  const [type, setType] = useState("");
  // 品牌商或up的form相关内容
  const [formBlock, setFormBlock] = useState<any>(null);
  const [form, setForm] = useState<any>(null);

  const [merchantsData, setMerchantsData] = useState<any>(null);
  const [merchantId, setMerchantId] = useState<any>(null);

  // 店铺授权的form内容
  const [basicBlock, setBasicBlock] = useState<any>(null);
  const [basicFrom, setBasicFrom] = useState<any>(null);

  const meituanBindRef = useRef<any>(null);
  const merchantsRef = useRef<any>(null);
  const dadaSearchRef = useRef<any>(null);

  const [radiocheck, setRadiocheck] = useState<any>(null);

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      const {
        authType,
        url,
        current,
        record,
        typeObj,
        merchants,
        form,
        formBlock,
      } = params;
      console.log("kkkkkk", params);
      dadaSearchRef.current = null;
      // 每次进入弹窗重制倒计时
      timeCountRef.current = 60;
      setTimeCount(60);
      setAuthType(authType);
      setForm(null);
      setType(typeObj.key);
      recordRef.current = record || {};
      merchantsRef.current = merchants;
      // 外部链接
      setAuthUrl(url || "");
      setShowRefresh(false);
      setList([]);
      if (merchants) {
        setMerchantId(merchants.id);
        setMerchantsData(merchants);
        setTitle(merchants.title);
      } else {
        setTitle("");
      }
      // 第二步绑定门店
      if ((merchants || record.platform) && current == 1) {
        getShop(merchants.id);
      }
      setCurrent(current !== undefined ? current : 0);
      setOpen(true);
      // 构建form表单数据
      if (form && form.fields && form.fields.length > 0) {
        setForm(form);
        setFormBlock(formBlock);
      }
    },
  }));

  // 获取授权店铺
  const getShop = (merchantId?: any) => {
    setBasicBlock(null);
    setList([]);
    // 获取授权店铺
    setDataLoading(true);
    channelAuthaddShop({
      ...recordRef.current,
      merchantId,
    })
      .then((res: any) => {
        setDataLoading(false);
        const { code, data } = res;
        // 如果直接返回店铺列表-则为选择店铺，如：eleme
        if (code === "000" && data.merchantShops) {
          // 因为 merchantShopsid 可能为空，所以要手动添加索引
          const _merchantShops = (data.merchantShops || []).map(
            (el: any, index: number) => {
              return {
                ...el,
                ...{
                  index: index,
                },
              };
            }
          );
          setList(_merchantShops);
          // 如果只有一个默认选中
          if (_merchantShops && _merchantShops.length == 1) {
            const item = _merchantShops[0];
            if (item) {
              recordRef.current = {
                ...recordRef.current,
                ...item,
              };
            }
          }
        }
        // 如果返回form，则填写资料，如，up
        if (
          code === "000" &&
          data.form &&
          data.form.fields &&
          data.form.fields.length > 0
        ) {
          const formBlock: any = {
            blockId: "fromBind",
            blockType: "form",
            maxColumns: 1,
            children: undefined,
            minColumns: 1,
            layout: 1,
            bizObjectCode: "TakeawayStoreBinding",
            isRefWholeObject: false,
            fields: [],
          };
          formBlock.fields = _.cloneDeep(data.form).fields.map((el: any) => {
            let _fieldProps: any = {
              required: el.require,
            };
            let _componentProps: any = {};
            let _uiProps: any = {};
            if (merchantsRef.current.channel == "dada") {
              if (el.name == "channelId") {
                _fieldProps = {
                  required: el.require,
                  renderType: "TakoutInputButton",
                };
                _componentProps = {
                  searchParams: {
                    platform: recordRef.current?.platform,
                    channel: merchantsRef.current.channel,
                    business: recordRef.current?.business,
                    shopId: recordRef.current?.shopId,
                    merchantChannelId: merchantsRef.current.channelId,
                  },
                };
              } else {
                _componentProps = {
                  disabled: true,
                };

                _uiProps = {
                  pattern: "readPretty",
                };
              }
            }
            const item: any = {
              data: {},
              fieldId: el.name,
              fieldProps: _fieldProps,
              fieldType: "Text",
              uiProps: {},
              componentProps: _componentProps,
              languageData: {},
              title: el.label,
            };
            return item;
          });
          setBasicBlock(formBlock);
          setBasicFrom(data.form);
        }
      })
      .catch(() => {
        setDataLoading(false);
        setList([]);
      });
  };

  const handleCancel = () => {
    clearTimer();
    setOpen(false);
  };

  const clearTimer = () => {
    if (countTimerRef.current) {
      clearTimeout(countTimerRef.current);
    }
    if (getAuthState.current.timeOut) {
      clearTimeout(getAuthState.current.timeOut);
    }
    getAuthState.current.state = false;
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
        // message.warning("暂未获取到授权，稍后重试")
        message.warning(t("general.authorizationRetry", { ns: "Financial" }));
        clearTimer();
        return;
      }
      buttonAutoTime();
    }, 1000);
  };

  // 授权店铺轮训-第二步操作
  const getShopAuthStateFn = () => {
    newGetShop({ ...recordRef.current }).then((res: any) => {
      setBtnLoading(false);
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
          getShopAuthStateFn();
        }, 3000);
      }
    });
  };

  // 授权商户轮训-第一步操作
  const getAuthStateFn = () => {
    newGetMerchant({ ...recordRef.current }).then((authRes: any) => {
      setBtnLoading(false);
      const { code, data } = authRes;
      if (code != "000") return;
      if (data) {
        setMerchantId(data.id);
        if (current == 0 && !recordRef.current?.shopId) {
          message.success({
            content: t("storeBind.bindSuccess", { ns: "Takeaway" }),
          });
          handleCancel();
        } else {
          setShowRefresh(false);
          setCurrent(1);
          getShop(data.id);
          clearTimer();
        }
      } else {
        if (timeCount == 0) {
          clearTimer();
          message.warning(t("general.authorizationRetry", { ns: "Financial" }));
          // message.warning("暂未获取到授权，稍后重试");
        } else {
          getAuthState.current.timeOut = setTimeout(() => {
            getAuthStateFn();
          }, 3000);
        }
      }
    });
  };

  const handleOk = () => {
    if (current == 0 && form) {
      nextStepClick();
      return;
    }

    if (!getAuthState.current.state && current == 0) {
      getAuthState.current.state = true;
      setShowRefresh(true);
      buttonAutoTime();
      getAuthStateFn();
    }
  };

  // 店铺授权-form表单填写
  const bindShopAuthForm = async () => {
    const checkValue = await shopRef.current?.validate();
    // 表格数据校验不通过
    if (!checkValue) {
      // return message.warning("请补全信息");
      return message.warning(
        t("instant.informationIncomplete", { ns: "Takeaway" })
      );
    }

    const value = shopRef.current?.getValue();
    const newForm = _.cloneDeep(basicFrom);
    newForm.fields = newForm.fields.map((el: any) => {
      for (const i in value) {
        if (el.name == i) {
          el.value = value[i];
        }

        if (el.name == "channelId" && typeof value[i] != "string") {
          el.value = (value[i] || {}).channelShopId;
        }
      }
      return el;
    });
    setBtnLoading(true);
    channelAuthaddShop({
      merchantId:
        recordRef.current && recordRef.current.id
          ? recordRef.current.id
          : merchantId,
      ...recordRef.current,
      form: newForm,
    })
      .then((res: any) => {
        setBtnLoading(false);
        const { code, data } = res;
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
          getShopAuthStateFn();
        }
      })
      .catch(() => {
        setBtnLoading(false);
      });
  };

  // 店铺授权-选择radio
  const bindShopAuthRadio = () => {
    if (!recordRef.current?.merchantShopName) {
      return message.warning(
        t("secondaryScreen.pleaseSelectStore", { ns: "Restaurant" })
      );
      // return message.warning("请选择门店！");
    }
    setBtnLoading(true);
    channelAuthaddShop({
      merchantId:
        recordRef.current && recordRef.current.id
          ? recordRef.current.id
          : merchantId,
      ...recordRef.current,
      selectedMerchantShop: {
        merchantShopId: recordRef.current?.merchantShopId,
        merchantShopName: recordRef.current?.merchantShopName,
        merchantShopAddress: recordRef.current?.merchantShopAddress,
      },
    })
      .then((res: any) => {
        console.log("hhhh", res);
        setBtnLoading(false);
        const { code, data } = res;
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
          getShopAuthStateFn();
        }
      })
      .catch(() => {
        setBtnLoading(false);
      });
    // addShopFromMerchant({
    //   merchantId: recordRef.current && recordRef.current.id ? recordRef.current.id : merchantId,
    //   ...recordRef.current,
    //   merchantShopId: recordRef.current?.merchantShopId,
    //   merchantShopName: recordRef.current?.merchantShopName,
    // })
    //   .then((authRes: any) => {
    //     setBtnLoading(false);
    //     const { code, data } = authRes;
    //     if (code === "000") {
    //       if (data) {
    //         message.success(t("storeBind.bindSuccess", { ns: "Takeaway" }));
    //         onChange && onChange();
    //         handleCancel();
    //       } else {
    //         message.warning(authRes?.msg);
    //       }
    //     }
    //   })
    //   .catch((err) => {
    //     setBtnLoading(false);
    //   });
  };

  // 品牌商下一步
  const nextStepClick = async () => {
    const checkValue = await basicFormRef.current?.validate();
    // 表格数据校验不通过
    if (!checkValue) {
      // return message.warning("请补全信息");
      return message.warning(
        t("instant.informationIncomplete", { ns: "Takeaway" })
      );
    }
    const value = basicFormRef.current?.getValue();
    const newForm = _.cloneDeep(form);
    newForm.fields = newForm.fields.map((el: any) => {
      for (const i in value) {
        if (el.name == i) {
          el.value = value[i];
        }
      }
      return el;
    });
    newAddMerchant({
      platform: recordRef.current?.platform,
      channel: merchantsData.channel,
      business: recordRef.current?.business,
      shopId: recordRef.current?.shopId,
      form: newForm,
    }).then((res: any) => {
      console.log("res", res);
      // setBtnLoading(false);
      if (res.code != "000") return;
      if (res.data.success) {
        if (recordRef.current?.shopId) {
          setShowRefresh(false);
          setCurrent(1);
          recordRef.current.id = res.data.id;
          getShop(res.data.id);
        } else {
          message.success({
            content: t("storeBind.bindSuccess", { ns: "Takeaway" }),
          });
          setShowRefresh(false);
          handleCancel();
          onChange?.();
        }
      } else if (res.data.waiting) {
        getAuthState.current.state = true;
        setShowRefresh(true);
        buttonAutoTime();
        getAuthStateFn();
      } else if (res.data.authUrl) {
        setOpen(false);
        meituanBindRef.current?.open({
          authType,
          url: res.data.authUrl,
          record: {
            ...recordRef.current,
            waitingKey: res.data.waitingKey,
          },
          merchants: merchantsRef.current,
        });
      }
    });
  };

  const listenFormChange = (key: any, value: any) => {
    if (key == "channelId" && value) {
      if (
        typeof value !== "string" &&
        value.channelShopId &&
        (!dadaSearchRef.current || dadaSearchRef.current != value.channelShopId)
      ) {
        console.log("达达搜索", JSON.parse(JSON.stringify(value)));
        dadaSearchRef.current = value.channelShopId;
        shopRef.current.setValue({
          channelId: value,
          ...value,
        });
      }
    }
  };

  return (
    <>
      <Modal
        // title={`${shopTitle[type] || type}商户授权`}
        title={t("general.merchantAuthName", {
          ns: "Financial",
          name: `${shopTitle[type] || type}`,
        })}
        open={open}
        destroyOnClose={true}
        className={`${stylesModel.customModal}`}
        width={800}
        footer={
          <div
            className={styles.footerClass}
            style={{ padding: "0 8px 0 16px" }}
          >
            {/* <span>正在通过 [{title}] 进行授权</span> */}
            <span>
              {t("mainBranch.inProgressOfApprovalInfo", { ns: "Financial" })} [
              {title}] {t("mainBranch.authorizeInfo", { ns: "Financial" })}
            </span>
            <Space>
              <Button
                onClick={() => {
                  handleCancel();
                }}
              >
                {/* 取消 */}
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
                  loading={current != 0 && btnLoading}
                  onClick={() => {
                    if (current === 0) {
                      handleOk();
                    } else {
                      // radio选择方式
                      if (list && list.length > 0) {
                        bindShopAuthRadio();
                      }
                      // 填写表单形式
                      if (
                        basicBlock &&
                        basicBlock.fields &&
                        basicBlock.fields.length > 0
                      ) {
                        bindShopAuthForm();
                      }
                    }
                  }}
                >
                  {current == 1 ? t("Confirm", { ns: "Common" }) : ""}

                  {current == 0 && authUrl
                    ? t("Takeaway.gettingAuthorizationStatus", {
                        ns: "Takeaway",
                      })
                    : ""}
                  {/* {current == 0 && form ? "下一步" : ""} */}
                  {current == 0 && form
                    ? t("mainBranch.nextStep", { ns: "Financial" })
                    : ""}
                </Button>
              )}
            </Space>
          </div>
        }
        onCancel={handleCancel}
      >
        <div className={styles.elemBind}>
          {!recordRef.current?.shopId ? (
            <div className="title">
              <span>
                {`${shopTitle[type] || type}${t("takeaway.btnServiceBind", {
                  ns: "Takeaway",
                })}`}
              </span>
            </div>
          ) : (
            <Steps
              style={{ margin: "20px 0" }}
              size="small"
              current={current}
              items={[
                {
                  title: `${title || type} ${t("takeaway.btnServiceBind", {
                    ns: "Takeaway",
                  })}`,
                },
                {
                  title: basicBlock
                    ? t("mainBranch.bindStore", { ns: "Financial" }) // "绑定门店"
                    : t("payment.SelectLocations", { ns: "Financial" }),
                },
              ]}
            />
          )}
          {/* 饿了么、抖音的ifream */}
          {current === 0 && (
            <div>
              {authUrl ? (
                <div className="ele-cont">
                  <iframe src={authUrl} style={{ height: 500 }}></iframe>
                </div>
              ) : (
                ""
              )}
              {form && formBlock ? (
                <div className="ele-cont">
                  <SchemaForm
                    formBlock={formBlock}
                    ref={basicFormRef}
                    // formMounted={() => { }}
                  ></SchemaForm>
                </div>
              ) : (
                ""
              )}
            </div>
          )}
          {/*第二步骤的门店选择 */}
          {current === 1 && (
            <div>
              {/* <Search placeholder="Search" /> */}
              {dataLoading && (
                <div className="flex justify-center">
                  <Spin />
                </div>
              )}

              <div className="pb-[20px]">
                <div style={{ textAlign: "center" }}>
                  {list && list.length > 0 ? (
                    <Radio.Group
                      style={{ width: "90%" }}
                      onChange={(evt) => {
                        const item = list.find(
                          (o) => o.index === evt.target.value
                        );
                        if (item) {
                          recordRef.current = {
                            ...recordRef.current,
                            ...item,
                          };
                        }
                        setRadiocheck(evt.target.value)
                      }}
                      value={list.length == 1 ? list[0].index : radiocheck}
                    >
                      <Space direction="vertical" className="spance">
                        {list.map((item: any) => (
                          <div
                            style={{
                              borderBottom: "1px solid #cccccc",
                              paddingBottom: "10px",
                            }}
                          >
                            <Radio value={item.index}>
                              <div className="flex items-center justify-between merchantShopName">
                                <span>{item.merchantShopName}</span>
                                <span>{item.merchantShopId}</span>
                              </div>
                            </Radio>
                          </div>
                        ))}
                      </Space>
                    </Radio.Group>
                  ) : (
                    ""
                  )}
                </div>

                <div>
                  {basicBlock &&
                  basicBlock.fields &&
                  basicBlock.fields.length > 0 ? (
                    <SchemaForm
                      formBlock={basicBlock}
                      ref={shopRef}
                      // formMounted={() => { }}
                      fieldValueChanged={listenFormChange}
                    ></SchemaForm>
                  ) : (
                    ""
                  )}
                </div>

                <div>
                  {!(
                    (list && list.length > 0) ||
                    (basicBlock &&
                      basicBlock.fields &&
                      basicBlock.fields.length > 0)
                  ) && !dataLoading ? (
                    <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} />
                  ) : (
                    ""
                  )}
                </div>
              </div>
            </div>
          )}
        </div>
      </Modal>

      <MeituanBind
        shopTitle={shopTitle}
        ref={meituanBindRef}
        title={t("Takeaway.MeituantakeawayAuthorizationbinding", {
          ns: "Takeaway",
        })}
        height="300px"
        onChange={(params: any) => {
          // 绑定成功
          const { url, record, merchants } = params;
          console.log("uberEats商户授权返回", params);
          recordRef.current = record || {};
          merchantsRef.current = merchants;
          if (merchants || record.platform) {
            getShop(merchants.id);
          }
          setCurrent(1);
          setOpen(true);
        }}
      />
    </>
  );
});

export default View;
