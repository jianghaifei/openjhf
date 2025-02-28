import {
  EditTable,
  IEditTableButtonType,
  IEditTableRef,
  IFormRef,
  SchemaForm,
  Provider,
} from "@restosuite/field-components";
import useCustomNavigate from "@src/Hooks/useCustomNavigate";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import { ILoaderData } from "@src/Router/GenerateRoutes";
import { useStore } from "@src/Store";
import { Button, Space, Spin, InputNumber, message } from "antd";
import _ from "lodash";
import { useEffect, useMemo, useRef, useState } from "react";
import { useTranslation } from "react-i18next";
import { useLoaderData, useSearchParams, useLocation } from "react-router-dom";
import {
  deliverySave,
  deliveryUpdate,
  deliveryAuthedChannelList,
} from "@src/Api/Takeaway/AggregateManagement";
import { v4 as uuid } from "uuid";
import styles from "./Components/index.module.less";
import SelectCustom from "./Components/SelectCustom/index";
import { threeLevelLinkageQuery } from "@src/Api/Takeaway/StoreAndItems";
import { fieldComponents } from "@restosuite/bo-common";
const {EditPage} = fieldComponents;

const LocationEdit = () => {
  const location = useLocation();
  const { record } = location.state || {};
  const { t, i18n } = useTranslation(["BaseServe"]);
  const { pageUtils } = useLoaderData() as ILoaderData;
  const [searchParams] = useSearchParams();
  const [recordId] = useState((record && record.id) || "");
  const basicFormRef = useRef<IFormRef>(null);
  const foodSafetyFormRef = useRef<IFormRef>(null);
  const dispatchRef = useRef<IEditTableRef>(null);
  const [threeLevelLinkageLanguage, setThreeLevelLinkageLanguage] =
    useState<any>(null);
  const [submitLoading, setSubmitLoading] = useState(false);
  const { loginStore } = useStore();
  const { goback } = useCustomNavigate();
  const [loading, setLoading] = useState(false);
  const datasourceRef = useRef<any>([]);
  const [addButton, setAddButton] = useState(false);
  const [isRenderEdit, setIsRenderEdit] = useState(true);
  const currentRef = useRef<any>(null);
  const valueRef = useRef<any>({
    preCustomerExpectMinutes: 20, // 期望送达时间
    preDistanceMinMinutes: 20, // 初始（最少）提前
    preDistanceAddMinutes: 5, // 每增加1公里增加
    preDistanceMaxMinutes: 60, // 最多提前
    expireMinutes: "", // 超时提醒
  });
  const formLayoutProps = {
    labelWidth: 200,
  };
  // 加载多语言
  const getthreeLevelLinkageQuery = () => {
    threeLevelLinkageQuery({
      queryLanguage: true,
    }).then((res: any) => {
      if (res.code != "000") return;
      setThreeLevelLinkageLanguage(res.data);
    });
  };

  useEffect(() => {
    getthreeLevelLinkageQuery();
    Provider.registerEditTableComponents({
      SelectCustom,
    });
  }, []);

  const handleBasicFormMounted = () => {
    console.log("record", record);
    if (record) {
      const _data = _.cloneDeep(record);
      // 这里是因为枚举值都是string类型，后端给的又是number类型，所以要转一下
      for (const i in _data) {
        if (typeof _data[i] === "number") {
          _data[i] = String(_data[i]);
          if (_data[i]) {
            valueRef.current[i] = _data[i];
          }
        }
      }

      if (_data.voiceFileUrl) {
        _data.voiceFileUrl = [_data.voiceFileUrl];
      }
      basicFormRef.current?.setValue(_data);
      foodSafetyFormRef.current?.setValue(_data);
    }
  };

  useEffect(() => {
    onChangeVal();
  }, []);

  const handleBasicFormValueChanged = (key: string, value: any) => {
    if (value || value == "0") {
      if (key == "dispatchMethod") {
        const isShow = value == "1" ? true : false;
        basicFormRef.current?.setFieldShowHide("dispatchTimingMethod", isShow);
        basicFormRef.current?.setFieldShowHide("autoDuration", isShow);
        setIsRenderEdit(isShow);
      }
      if (key == "noticeVoiceChoice") {
        const isShow = value == "0" ? false : true;
        foodSafetyFormRef.current?.setFieldShowHide("voiceFileUrl", isShow);
      }
    }
  };

  // 统一的单选插槽处理，这里没放入自定义组件，因为自定义组件只有onchange回调，不能将input的value很友好的带回来
  // 同时也考虑回显问题，会同时有多个单选有输入框情况，所以选择传入插槽形式
  const onChangeVal = () => {
    basicFormRef.current?.setComponentProps("dispatchTimingMethod", {
      insertList: [
        {
          key: "2",
          beforeText: null,
          afterText: t("aggregate.startautomaticdelivery", { ns: "Takeaway" }), // "开始自动派单",
          solt: (
            <InputNumber
              defaultValue={valueRef.current.preCustomerExpectMinutes}
              size={"small"}
              addonAfter={t("aggregate.minutes", { ns: "Takeaway" })} //"分钟"
              min={1}
              max={60}
              style={{ width: "150px", margin: "0 5px" }}
              placeholder={t("aggregate.pleaseenter", { ns: "Takeaway" })}
              onChange={(e: any) => {
                valueRef.current.preCustomerExpectMinutes = e;
              }}
            />
          ),
        },
        {
          key: "3",
          beforeText: null,
          afterText: "",
          enter: true,
          solt: (
            <div className={styles.boxliswrap}>
              <div className="boxli">
                <span>
                  {t("aggregate.Initialadvance", { ns: "Takeaway" })}
                  {/* 初始（最少）提前 */}
                </span>
                <InputNumber
                  defaultValue={valueRef.current.preDistanceMinMinutes}
                  size={"small"}
                  min={0}
                  max={60}
                  addonAfter={t("aggregate.minutes", { ns: "Takeaway" })} // "分钟"
                  style={{ width: "150px", margin: "0 5px" }}
                  placeholder={t("aggregate.pleaseenter", { ns: "Takeaway" })}
                  onChange={(e: any) => {
                    valueRef.current.preDistanceMinMinutes = e;
                  }}
                />
              </div>
              <div className="boxli">
                <span>
                  {t("aggregate.eachadditionalincreases", { ns: "Takeaway" })}
                  {/* 每增加1公里增加 */}
                </span>
                <InputNumber
                  defaultValue={valueRef.current.preDistanceAddMinutes}
                  size={"small"}
                  min={0}
                  max={60}
                  addonAfter={t("aggregate.minutes", { ns: "Takeaway" })} // "分钟"
                  style={{ width: "150px", margin: "0 5px" }}
                  placeholder={t("aggregate.pleaseenter", { ns: "Takeaway" })}
                  onChange={(e: any) => {
                    valueRef.current.preDistanceAddMinutes = e;
                  }}
                />
              </div>
              <div className="boxli">
                <span>
                  {t("aggregate.uptoadvance", { ns: "Takeaway" })}
                  {/* 最多提前 */}
                </span>
                <InputNumber
                  defaultValue={valueRef.current.preDistanceMaxMinutes}
                  size={"small"}
                  min={0}
                  max={120}
                  addonAfter={t("aggregate.minutes", { ns: "Takeaway" })} // "分钟"
                  style={{ width: "150px", margin: "0 5px" }}
                  placeholder={t("aggregate.pleaseenter", { ns: "Takeaway" })}
                  onChange={(e: any) => {
                    valueRef.current.preDistanceMaxMinutes = e;
                  }}
                />
              </div>
            </div>
          ),
        },
      ],
      filterList: ["3"],
    });
    foodSafetyFormRef.current?.setComponentProps("noticeFlag", {
      insertList: [
        {
          key: "1",
          beforeText: null,
          afterText: "",
          solt: (
            <InputNumber
              defaultValue={valueRef.current.expireMinutes}
              size={"small"}
              addonAfter={t("aggregate.minutes", { ns: "Takeaway" })} // "分钟"
              style={{ width: "150px", margin: "0 5px" }}
              placeholder={t("aggregate.pleaseenter", { ns: "Takeaway" })}
              onChange={(e: any) => {
                valueRef.current.expireMinutes = e;
              }}
            />
          ),
        },
      ],
    });
  };

  const handleSaveForm = async () => {
    console.log("提交", valueRef.current);
    const validbasicForm = await basicFormRef.current?.validate();
    const validdispatch = await dispatchRef.current?.validate();
    const validfoodSafetyForm = await foodSafetyFormRef.current?.validate();
    const datadispatch = dispatchRef.current?.getData() || [];
    if (
      validbasicForm === false ||
      validdispatch === false ||
      validfoodSafetyForm === false || 
      isRenderEdit && (!datadispatch || datadispatch.length == 0)
    ) {
      message.warning(t(CommonEnum.FieldRequired, { ns: "Common" }));
      return null;
    }
    const databasicForm = basicFormRef.current?.getValue();
    
    const datafoodSafetyForm = foodSafetyFormRef.current?.getValue() || {};
    console.log("qqqqq", databasicForm, datadispatch, datafoodSafetyForm);
    const channelDatasourceText: any = {};
    if (datasourceRef.current && datasourceRef.current.length > 0) {
      datasourceRef.current.forEach((el: any) => {
        channelDatasourceText[el.value] = el.label || el.value;
      });
    }

    // 组织数据
    // 这里后端非要整一堆层级，很恶心，还得拼接
    const saveData = {
      corporationId: loginStore.getCorporationId(),
      deliveryRules: {
        id: record && record.id,
        ruleId: record && record.ruleId,
        ruleName: databasicForm.ruleName,
        rules: {
          // 派单当时
          dispatchMethod: databasicForm.dispatchMethod,
          // 派单时机
          dispatchTiming: {
            dispatchTimingMethod: databasicForm.dispatchTimingMethod,
            preCustomerExpectMinutes: valueRef.current.preCustomerExpectMinutes, // 期望送达时间
            preDistanceMinMinutes: valueRef.current.preDistanceMinMinutes, // 初始（最少）提前
            preDistanceAddMinutes: valueRef.current.preDistanceAddMinutes, // 每增加1公里增加
            preDistanceMaxMinutes: valueRef.current.preDistanceMaxMinutes, // 最多提前
          },
          // 自动派单持续时间
          autoDuration: databasicForm.autoDuration,
          // 派单优先级
          channels: datadispatch.map((el: any, index: number) => {
            return {
              order: index,
              callDuration: el.callDuration,
              channel:
                channelDatasourceText[el.companyDistribution] ||
                el.companyDistribution,
              value: el.companyDistribution,
              id: el.id,
            };
          }),
          // 是否启用自配送
          deliveryBySelf: (datafoodSafetyForm || {}).deliveryBySelf ? "1" : "0",
          // 超时提醒
          expireConfig: {
            noticeFlag: datafoodSafetyForm.noticeFlag,
            expireMinutes: valueRef.current.expireMinutes,
          },
          // 超时语音设置
          expireVoiceConfig: {
            noticeVoiceChoice: datafoodSafetyForm.noticeVoiceChoice,
            voiceFileUrl:
              datafoodSafetyForm.voiceFileUrl &&
              datafoodSafetyForm.voiceFileUrl[0],
          },
        },
      },
    };
    setSubmitLoading(true);
    console.log("vvvvvv", saveData);
    const apiFetch = record && record.ruleId ? deliveryUpdate : deliverySave;
    apiFetch(saveData)
      .then((res: any) => {
        setSubmitLoading(false);
        if (res.code != "000") {
          return;
        }
        message.success(res.msg);
        goback();
      })
      .catch(() => {
        setSubmitLoading(false);
      });
  };

  const renderBasicForm = useMemo(() => {
    const block = pageUtils.getBlockData("ruleForm");

    return (
      <div id="basic" className={styles.basformbox}>
        <SchemaForm
          formBlock={block}
          className="px-4"
          ref={basicFormRef}
          formLayoutProps={formLayoutProps}
          formMounted={handleBasicFormMounted}
          fieldValueChanged={handleBasicFormValueChanged}
        ></SchemaForm>
      </div>
    );
  }, []);

  const subAddtionalFn = (data?: any) => {
    setLoading(true);
    deliveryAuthedChannelList({}).then((res: any) => {
      setLoading(false);
      if (res.code != "000") {
        return;
      }
      const _record = _.cloneDeep(record);
      let _data =
        _record &&
        _record.rules.channels.map((el: any) => {
          if (!el.id) {
            el.id = uuid();
          }
          el.companyDistribution = el.value || el.channel;
          return el;
        });
      _data = _data && _data.sort((a: any, b: any) => a.order - b.order);
      datasourceRef.current = res.data.map((el: any) => {
        el.label =
          (
            (
              (threeLevelLinkageLanguage &&
                threeLevelLinkageLanguage.contentLanguageList.filter(
                  (m: any) => m.key == el.channel
                )) ||
              []
            ).find((n: any) => n.languageCode == i18n.language) || {}
          ).text || el.channel;
        el.value = el.channel;
        if (
          _data &&
          (_data.map((m: any) => m.value) || []).includes(el.value)
        ) {
          el.disabled = true;
        }
        return el;
      });

      console.log("aaaaa", _data, datasourceRef.current);
      const filterIdlist =
        (_data &&
          _data.map((n: any) => {
            dispatchRef.current?.setComponentPropsByRowId(
              n.id,
              "companyDistribution",
              {
                readPretty: true,
              }
            );
            return n.id;
          })) ||
        [];

      const _dataSourceCom =
        datasourceRef.current.map((el: any) => {
          if (filterIdlist.includes(el.value)) {
            el.disabled = true;
          }
          return el;
        }) || [];

      if (!_dataSourceCom || _dataSourceCom.length == 0) {
        setAddButton(true);
      } else {
        setAddButton(false);
      }

      dispatchRef.current?.setFieldDataSource(
        "companyDistribution",
        _dataSourceCom
      );
      dispatchRef.current?.setData(_data || []);
    });
  };

  const renderAddtional = useMemo(() => {
    return (
      <>
        <div className={styles.formlabel}>
          <span className="label" style={{ width: formLayoutProps.labelWidth }}>
            <label>
              {/* 派单优先级 */}
              <span className="ant-formily-item-asterisk">*</span>
              {t("aggregate.orderpriority", { ns: "Takeaway" })}
              <i>:</i>
            </label>
          </span>
          <div
            className="editer"
            style={{ width: `calc(100% - ${formLayoutProps.labelWidth}px)` }}
          >
            <EditTable
              className="px-4"
              ref={dispatchRef}
              blockData={pageUtils.getBlockData("dispatchPriority")}
              operationColumnProps={{
                visible: true,
              }}
              editable={true}
              fieldOnChange={(changedValues: any, allValues: any) => {
                console.log("sssss", changedValues, allValues);
                // currentRef.current
                // datasourceRef
                Object.keys(changedValues).forEach((m: any) => {
                  if (changedValues[m].companyDistribution) {
                    datasourceRef.current = datasourceRef.current.map(
                      (el: any) => {
                        if (currentRef.current == el.value) {
                          el.disabled = false;
                        }
                        if (changedValues[m].companyDistribution == el.value) {
                          el.disabled = true;
                          setTimeout(() => {
                            currentRef.current = el.value;
                          });
                        }
                        return el;
                      }
                    );
                    // console.log("ppppp", datasourceRef.current);
                    dispatchRef.current?.setFieldDataSource(
                      "companyDistribution",
                      datasourceRef.current
                    );
                  }
                  // console.log(
                  //   "ccccc",
                  //   changedValues[m].companyDistribution,
                  //   currentRef.current
                  // );
                });
              }}
              showIndexColumn={false}
              rowKey="id"
              builtinButtonList={[
                {
                  key: IEditTableButtonType.Delete,
                  text: (
                    <Button type="link">
                      {/* 移除 */}
                      {t("aggregate.Remove", { ns: "Takeaway" })}
                    </Button>
                  ),
                },
              ]}
              rowOnViewDelete={(key: any, row: any, cb: any) => {
                cb(() => {
                  console.log("wwwww", key, row);
                  return false;
                });
              }}
              rowOnDelete={(key: any, row: any, cb: any) => {
                console.log("onDelete", key, row);
                datasourceRef.current = datasourceRef.current.map((el: any) => {
                  if (row && row.companyDistribution == el.value) {
                    el.disabled = false;
                  }
                  return el;
                });
                if (
                  dispatchRef.current?.getData().length <=
                  datasourceRef.current.length
                ) {
                  setAddButton(false);
                } else {
                  setAddButton(true);
                }
                // console.log("ppppp", datasourceRef.current);
                dispatchRef.current?.setFieldDataSource(
                  "companyDistribution",
                  datasourceRef.current
                );
                cb(true);
              }}
              footerSlot={
                <Button
                  disabled={addButton}
                  onClick={() => {
                    const _dataSourceCom = _.cloneDeep(datasourceRef.current);

                    const findData = _dataSourceCom.find(
                      (el: any) => !el.disabled
                    );
                    console.log(
                      findData,
                      _dataSourceCom,
                      dispatchRef.current?.getData()
                    );
                    if (findData) {
                      const _data =
                        _.cloneDeep(dispatchRef.current?.getData()) || [];
                      _data.forEach((el: any) => {
                        dispatchRef.current?.setComponentPropsByRowId(
                          el.id,
                          "companyDistribution",
                          {
                            readPretty: true,
                          }
                        );
                      });
                      _data.push({
                        id: uuid(),
                        callDuration:
                          (_data[_data.length - 1] || {}).callDuration || 300,
                        companyDistribution: findData.value,
                      });
                      // 控制增加按钮
                      if (_data.length == datasourceRef.current.length) {
                        setAddButton(true);
                      } else {
                        setAddButton(false);
                      }
                      currentRef.current = findData.value;
                      dispatchRef.current?.setData(_data);
                      datasourceRef.current = datasourceRef.current.map(
                        (el: any) => {
                          if (findData.value == el.value) {
                            el.disabled = true;
                          }
                          return el;
                        }
                      );
                      dispatchRef.current?.setFieldDataSource(
                        "companyDistribution",
                        datasourceRef.current
                      );
                    }
                  }}
                >
                  + {t("aggregate.adddistributioncompany", { ns: "Takeaway" })}
                  {/* 增加配送公司 */}
                </Button>
              }
              onMounted={() => {
                // dispatchRef.current?.setComponentProps("companyDistribution", {
                //   dataSource: _dataSourceCom,
                // });
                subAddtionalFn();
              }}
            ></EditTable>
          </div>
        </div>
      </>
    );
  }, [addButton, threeLevelLinkageLanguage]);

  // 餐段和收银班次结束

  const renderFoodSafty = useMemo(() => {
    const foodSaftyBlock = pageUtils.getBlockData("timeForm");

    return (
      <div id="FoodSafety">
        <SchemaForm
          formLayoutProps={formLayoutProps}
          formBlock={foodSaftyBlock}
          ref={foodSafetyFormRef}
          fieldValueChanged={handleBasicFormValueChanged}
        ></SchemaForm>
      </div>
    );
  }, []);

  return (
    <EditPage
      title={
        recordId
          ? t("aggregate.editdeliveryrules", { ns: "Takeaway" })
          : t("aggregate.newshippingrules", { ns: "Takeaway" })
      }
      footer={
        <Space>
          <Button onClick={() => goback()}>
            {t(CommonEnum.Cancel, { ns: "Common" })}
          </Button>
          <Button
            type="primary"
            loading={submitLoading}
            onClick={handleSaveForm}
          >
            {t(CommonEnum.Save, { ns: "Common" })}
          </Button>
        </Space>
      }
    >
      <Spin spinning={loading}>
        {renderBasicForm}
        {isRenderEdit && threeLevelLinkageLanguage && renderAddtional}
        {/* {renderFoodSafty} */}
      </Spin>

      <div style={{ height: "30px" }}></div>
    </EditPage>
  );
};

export default LocationEdit;
