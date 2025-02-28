import { Space, Button, Modal, message, Checkbox, TimePicker } from "antd";
import { useRef, useState, useImperativeHandle, forwardRef } from "react";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import styles from "./index.module.less";
import _ from "lodash";
import { changeOperateShop } from "@src/Api/Takeaway/StoreAndItems";
import dayjs from "dayjs";
const format = "HH:mm";
export type IConfigRef = {
  open: (params: any) => void;
};
const formateDataBetch = {
  startTime: null,
  endTime: null,
};

const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { t, i18n } = useTranslation();
  const weeks: any = {
    "1": t("instant.Monday", { ns: "Takeaway" }),
    "2": t("instant.Tuesday", { ns: "Takeaway" }),
    "3": t("instant.Wednesday", { ns: "Takeaway" }),
    "4": t("instant.Thursday", { ns: "Takeaway" }),
    "5": t("instant.Friday", { ns: "Takeaway" }),
    "6": t("instant.Saturday", { ns: "Takeaway" }),
    "7": t("instant.Sunday", { ns: "Takeaway" }),
  };
  const { onChange, businessCodeOptions, onSuccess } = props;
  const [open, setOpen] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  const recordRef = useRef<any>({});
  const [record, setRecord] = useState<any>({});
  const [dataBatch, setDataBatch] = useState<any>({});
  const [openBatch, setOpenBatch] = useState<boolean>(false);
  const [data, setData] = useState<any>([]);
  const [validacion, setValidacion] = useState<any>(false);

  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      setValidacion(false);
      const { record } = params;
      recordRef.current = record || {};
      if (record && Object.keys(record).length > 0) {
        setRecord(record);
      }
      const businessTime: any = {};
      if (record.businessTime) {
        record.businessTime.forEach((el: any) => {
          businessTime[String(el.dayOfWeek)] = el;
        });
      }
      const _data = [];
      for (const i in weeks) {
        _data.push({
          id: i,
          dayOfWeek: i,
          weeks: weeks[i],
          checkbox: record.businessTime ? (businessTime[i] ? true : false) : true,
          periods: {
            startTime: businessTime[i] ? businessTime[i].periods[0].startTime : null,
            endTime: businessTime[i] ? businessTime[i].periods[0].endTime : null,
          },
        });
      }
      setData(_data);
      setOpen(true);
    },
  }));

  const confimCancel = () => {
    setOpen(false);
  };

  const confimOk = () => {
    let _data = _.cloneDeep(data);
    const msgInfo: any = [];
    if (_data && _data.length <= 0) {
      return message.warning({
        // content: `需至少选择一天，并设置营业时间`,
        content: t("mainBranch.selectAndSet", { ns: "Financial" }),
        duration: 5,
      });
    }
    _data = _data
      .filter((el: any) => el.checkbox)
      .map((el: any, index: number) => {
        if (!el.periods.startTime || !el.periods.endTime) {
          msgInfo.push({
            index,
            weeks: el.weeks,
          });
        }
        return {
          dayOfWeek: el.dayOfWeek,
          periods: [el.periods],
        };
      });
    if (msgInfo && msgInfo.length > 0) {
      setValidacion(true);
      return;
    } else {
      setValidacion(false);
    }

    setLoading(true);
    changeOperateShop({
      id: record.id,
      businessTime: {
        weeks: _data,
      },
    })
      .then((res: any) => {
        setLoading(false);
        if (res.code != "000") {
          return;
        }
        message.success(t("common.save_success", { ns: "Common" }));
        setOpen(false);
        onChange?.();
      })
      .catch(() => {
        setLoading(false);
      });
  };
  const onChangeCheck = (row: any, value: any, index: number, type: string) => {
    const _data = _.cloneDeep(data);
    if (type == "checkbox") {
      _data[index][type] = value;
    } else {
      _data[index]["periods"][type] = value;
    }
    setData(_data);
  };

  const onChangeBatch = (value: any, type: string) => {
    const _dataBatch = _.cloneDeep(dataBatch);
    _dataBatch[type] = value;
    setDataBatch(_dataBatch);
  };

  const batchConfim = () => {
    if (
      Object.keys(dataBatch).every(
        (key) => dataBatch[key] !== null && dataBatch[key] !== undefined && dataBatch[key] !== ""
      )
    ) {
      let _data = _.cloneDeep(data);
      const keylist = ["startTime", "endTime"];
      _data = _data.map((el: any) => {
        keylist.forEach((item: any) => {
          el["periods"][item] = dataBatch[item];
        });
        return el;
      });
      setData(_data);
      setOpenBatch(false);
      setValidacion(false);
    } else {
      setValidacion(true);
    }
  };

  return (
    <div>
      <Modal
        title={t("mainBranch.businessHourSetup", { ns: "Financial" })}
        // title={"营业时间设置"}
        open={open}
        onCancel={() => {
          confimCancel();
        }}
        zIndex={99}
        width={"900px"}
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
        <div>
          <div className={styles.flacjsb} style={{ padding: "10px 0" }}>
            <div className="text-[14px]">
              {t("common.Locations", { ns: "Common" })}：{record.shopName}（ID：
              {record.shopId}）
            </div>
            <div>
              {t("SettlementAccount.BusinessTypes", { ns: "Financial" })}：
              <span
                className={styles.Tagclass}
                style={{
                  padding: "3px 10px",
                  color: "rgba(47, 84, 235, 1)",
                }}
              >
                {t("instant.MiaoTi", { ns: "Takeaway" })}
              </span>
            </div>
          </div>
          <div className={styles.flacjsb}>
            <span>{t("instant.BusinessHours", { ns: "Takeaway" })}</span>
            <Button
              type="link"
              style={{ padding: "0" }}
              onClick={() => {
                setValidacion(false);
                setDataBatch(formateDataBetch);
                setOpenBatch(true);
              }}
            >
              {/* 批量设置 */}
              {t("instant.BatchSetting", { ns: "Takeaway" })}
            </Button>
          </div>

          <div>
            {data.map((row: any, index: number) => (
              <div key={index} style={{ display: "flex", alignItems: "center", padding: "0 5%" }}>
                <Checkbox
                  checked={row.checkbox}
                  className={styles.space}
                  onChange={(e: any) => {
                    onChangeCheck(row, e.target.checked, index, "checkbox");
                  }}
                  style={{ width: "4%" }}
                />
                <span
                  className={styles.space}
                  style={{
                    width: "10%",
                    textOverflow: "ellipsis",
                    whiteSpace: "nowrap",
                    overflow: "hidden",
                  }}
                >
                  {row.weeks}
                </span>
                <TimePicker
                  status={row.periods.startTime ? "" : validacion ? "error" : ""}
                  placeholder={t("Common.PleaseSelect", { ns: "Customers" })}
                  format={format}
                  className={styles.space}
                  value={row.periods.startTime ? dayjs(row.periods.startTime, format) : null}
                  style={{ width: "35%" }}
                  disabled={!row.checkbox}
                  onChange={(time, timeString) => {
                    onChangeCheck(row, timeString || null, index, "startTime");
                  }}
                />
                <span className={styles.space} style={{ width: "6%", textAlign: "center" }}>
                  {t("instant.Until", { ns: "Takeaway" })}
                </span>
                <TimePicker
                  status={row.periods.endTime ? "" : validacion ? "error" : ""}
                  className={styles.space}
                  value={row.periods.endTime ? dayjs(row.periods.endTime, format) : null}
                  format={format}
                  placeholder={t("Common.PleaseSelect", { ns: "Customers" })}
                  style={{ width: "35%" }}
                  disabled={!row.checkbox}
                  onChange={(time, timeString) => {
                    onChangeCheck(row, timeString || null, index, "endTime");
                  }}
                />
              </div>
            ))}
          </div>
        </div>
      </Modal>
      <Modal
        title={t("instant.BatchSetting", { ns: "Takeaway" })}
        open={openBatch}
        onCancel={() => {
          setOpenBatch(false);
        }}
        zIndex={101}
        width={"900px"}
        footer={() => {
          return (
            <div className={styles.footerClass}>
              <span></span>
              <Space>
                <Button
                  onClick={() => {
                    setOpenBatch(false);
                  }}
                >
                  {t(CommonEnum.CANCEL, { ns: "Common" })}
                </Button>
                <Button type="primary" loading={loading} onClick={batchConfim}>
                  {t(CommonEnum.CONFIRM, { ns: "Common" })}
                </Button>
              </Space>
            </div>
          );
        }}
      >
        <div>
          <div>
            {openBatch ? (
              <div style={{ display: "flex", alignItems: "center" }}>
                <TimePicker
                  status={dataBatch.startTime ? "" : validacion ? "error" : ""}
                  format={format}
                  className={styles.space}
                  value={dataBatch.startTime ? dayjs(dataBatch.startTime, format) : null}
                  style={{ flex: 2 }}
                  placeholder={t("Common.PleaseSelect", { ns: "Customers" })}
                  onChange={(time, timeString) => {
                    onChangeBatch(timeString || null, "startTime");
                  }}
                />
                <span className={styles.space}> {t("instant.Until", { ns: "Takeaway" })}</span>
                <TimePicker
                  status={dataBatch.endTime ? "" : validacion ? "error" : ""}
                  className={styles.space}
                  value={dataBatch.endTime ? dayjs(dataBatch.endTime, format) : null}
                  format={format}
                  style={{ flex: 2 }}
                  placeholder={t("Common.PleaseSelect", { ns: "Customers" })}
                  onChange={(time, timeString) => {
                    onChangeBatch(timeString || null, "endTime");
                  }}
                />
              </div>
            ) : (
              ""
            )}
          </div>
        </div>
      </Modal>
    </div>
  );
});

export default View;
