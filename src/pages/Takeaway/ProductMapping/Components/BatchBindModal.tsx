// 外卖菜单弹层
import { Space, Button, Modal, message, Input, Spin, Select } from "antd";
import {
  useRef,
  useState,
  useImperativeHandle,
  useEffect,
  forwardRef,
} from "react";
import { LeftOutlined, LinkOutlined } from "@ant-design/icons";
import { useTranslation } from "react-i18next";
import { CommonEnum } from "@src/Locales/Constants/CommonEnum";
import styles from "./index.module.less";
import { DndContext } from "@dnd-kit/core";
import { Droppable } from "./Droppable";
import { Draggable } from "./Draggable";
import { IKVProps } from "@restosuite/field-core";
import { getCurrencySymbol } from "@src/Utils/CommonUtils";
import Mouse from "./Mouse";
import _ from "lodash";
import ThirdItemsLoad from "./ThirdItemsLoad";
import {
  FilterKeys,
  existenceOrnot,
  getMapdata,
  bindAndUnbind,
} from "../../Components/IHelper";
import { trdItemQuery } from "@src/Api/Takeaway/takeoutDelivery";
import stylesModel from "@src/pages/BaseServe/Location/index.module.less";
const { Search } = Input;
export type IConfigRef = {
  open: (params: any) => void;
};

const View = forwardRef<IConfigRef, any>((props, ref) => {
  const { title, menuInfo, query, onChange, typeObj, total } = props;
  const { t, i18n } = useTranslation();
  const [open, setOpen] = useState<boolean>(false);
  const [leftDishs, setLeftDishs] = useState<IKVProps[]>([]);
  const [rightDishs, setRightDishs] = useState<IKVProps[]>([]);
  const [leftQueryVal, setLeftQueryVal] = useState<string>("");
  const [rightQueryVal, setRightQueryVal] = useState<string>("");
  const [saveLoading, setSaveLoading] = useState<boolean>(false);
  const [leftLoading, setLeftLoading] = useState<boolean>(false);
  const [rightLoading, setRightLoading] = useState<boolean>(false);
  const [isDraging, setIsDraging] = useState<boolean>(false);
  const [copyDrag, setCopyDrag] = useState<string>("");
  const [saveRightData, setSaveRightData] = useState<any>([]);
  const [saveLeftData, setSaveLeftData] = useState<any>([]);
  const [copyDragPos, setCopyDragPos] = useState<any>({ x: 0, y: 0 });
  const dragStartPos = useRef({ x: 0, y: 0, width: 0 });
  const rightBoxScrollTop = useRef(0);
  const mouseRef = useRef<any>(null);
  const [sortType, setSortType] = useState("0");
  const [dragActiveItem, setDragActiveItem] = useState<any>(null);
  const [bing, setBing] = useState<any>([]);
  const leftRuleMapRef = useRef<any>({});
  const rightRuleMapRef = useRef<any>({});

  // 开始拖拽
  const handleDragStart = (event: any) => {
    const dragId = event.active.id;
    const dragTarget: any = document.getElementById(`drag${dragId}`);
    const rect = dragTarget.getBoundingClientRect();
    setCopyDrag(dragTarget.outerHTML);
    mouseRef.current = new Mouse();
    dragStartPos.current = {
      x: rect.left,
      y: rect.top,
      width: rect.width,
    };
    setCopyDragPos(dragStartPos.current);
  };

  // 弹窗事件
  useImperativeHandle(ref, () => ({
    open(params: any = {}) {
      leftRuleMapRef.current = {};
      rightRuleMapRef.current = {};
      setLeftQueryVal("");
      setRightQueryVal("");
      setOpen(true);
      getMenuItems();
      setSortType("0");
      setDragActiveItem(null);
      setBing([]);
    },
    close() {
      setOpen(false);
    },
  }));

  // 排序触发列表更新
  useEffect(() => {
    renderLeftTreeFn(_.cloneDeep(leftDishs));
    renderRightTreeFn(_.cloneDeep(rightDishs));
  }, [sortType]);

  // 更新左侧树
  const renderLeftTreeFn = (data: any) => {
    data.sort((a: any, b: any) => {
      // 使用 localeCompare 方法比较两个字符串
      switch (sortType) {
        case "0": // 字符集正序
          return a.itemName.localeCompare(b.itemName);
          break;
        case "1": // 字符集倒序
          return b.itemName.localeCompare(a.itemName);
          break;
        case "2": // 价格从小到大
          return a.price - b.price;
          break;
        case "3": // 价格从大到小
          return b.price - a.price;
          break;
        default:
          break;
      }
    });
    setLeftDishs(data);
  };

  // 更新右侧树
  const renderRightTreeFn = (data: any) => {
    data.sort((a: any, b: any) => {
      switch (sortType) {
        case "0": // 字符集正序
          return a.trdItemName.localeCompare(b.trdItemName);
          break;
        case "1": // 字符集倒序
          return b.trdItemName.localeCompare(a.trdItemName);
          break;
        case "2": // 价格从小到大
          return a.trdPrice - b.trdPrice;
          break;
        case "3": // 价格从大到小
          return b.trdPrice - a.trdPrice;
          break;
        default:
          break;
      }
    });
    setRightDishs(data);
  };

  // 拖拽中
  const handleDragMove = (event: any) => {
    const rect = {
      x: dragStartPos.current.x + mouseRef.current.delta.x,
      y: dragStartPos.current.y + mouseRef.current.delta.y,
      width: dragStartPos.current.width,
    };
    setCopyDragPos(rect);
  };

  // 将拖拽后的元素放入左侧对应元素中
  const assemblData = (dragId: string, dropId: string, isClick?: boolean) => {
    const delIndex = _.cloneDeep(rightDishs).findIndex((o) => o.nid === dragId);
    const newLeft = _.cloneDeep(leftDishs);
    const dropItemIndex: any = newLeft.findIndex((o) => o.leftnid === dropId);
    const newRight = _.cloneDeep(rightDishs);

    if (delIndex > -1) {
      const dragItem = rightDishs[delIndex];
      // 判断拖拽过来的三方菜价格与我方菜价格上涨还是下跌
      const dropItem = newLeft[dropItemIndex];
      const trdItems = dropItem["trdItems"] || [];

      newRight.splice(delIndex, 1);
      renderRightTreeFn(newRight);
      if (dropItem && dragItem) {
        dragItem.filterValue = dropItem.filterValue + dragItem.filterValue;
        trdItems.push(dragItem);
        newLeft[dropItemIndex] = {
          trdItems,
          ...dropItem,
          isActive: false,
        };
      }

      setDragActiveItem(null);
      renderLeftTreeFn(newLeft);
    }
  };

  // 拖拽结束
  const handleDragEnd = (event: any) => {
    const { over, active } = event;
    mouseRef.current.destory();
    dragStartPos.current = { x: 0, y: 0, width: 0 };
    setCopyDragPos(dragStartPos.current);
    setCopyDrag("");
    if (over && active) {
      const dragId = active.id; // 拖动块的id
      const dropId = over.id; // 左侧拖入区域的id
      assemblData(dragId, dropId);
    }
  };

  // 自动匹配 相同“菜品名称+相同规格”的自动关联
  const autoBatchBind = () => {
    const leftData = _.cloneDeep(leftDishs);
    let rightData = _.cloneDeep(rightDishs);
    console.log("leftData", leftData);
    const rigthObj: any = {};
    const rigthObj2: any = {};
    rightData.forEach((child: any, index: number) => {
      let bingKey = `${child.trdItemName}`;
      if (rightRuleMapRef.current[child.trdItemId]) {
        bingKey = `${child.trdItemName}${child.trdUnitName}`;
      }
      const bingKey2 = `${child.trdItemName}${child.trdUnitName}`;

      rigthObj[bingKey] = {
        ...child,
        childIndex: index,
      };

      rigthObj2[bingKey2] = {
        ...child,
        childIndex: index,
      };
    });
    console.log("gggggg", rigthObj, rigthObj2);
    leftData.forEach((leftItem: any, leftIndex: number) => {
      let bindKey = `${leftItem.itemName}`;
      if (leftRuleMapRef.current[leftItem.itemId]) {
        bindKey = `${leftItem.itemName}${leftItem.unitName}`;
      }
      const bindKey2 = `${leftItem.itemName}${leftItem.unitName}`;
      console.log("ttttt", bindKey, bindKey2);
      const changedata = (key: string, obj: any) => {
        const trdItems = leftData[leftIndex].trdItems || [];

        trdItems.push(obj[key]);
        leftData[leftIndex].trdItems = trdItems;
        leftData[leftIndex].filterValue =
          leftData[leftIndex].filterValue + obj[key].filterValue;
        rightData = rightData.filter((item: any) => item.nid !== obj[key].nid);
        delete obj[key];
      };

      if (rigthObj[bindKey]) {
        console.log("222222", rigthObj[bindKey]);
        changedata(bindKey, rigthObj);
      } else if (rigthObj2[bindKey2]) {
        console.log("33333", rigthObj2[bindKey2]);
        changedata(bindKey2, rigthObj2);
      }
    });
    renderLeftTreeFn(leftData);
    renderRightTreeFn(rightData);
    message.success(t("Takeaway.Automaticmatchcompletion", { ns: "Takeaway" }));
  };

  // 1、为了同步左侧三方商品名称分类，根据trdSkuId从右侧分类中进行匹配
  // 2、为了同步左侧绑定的三方菜品是否已经被删除，如果从右侧没有匹配到就是删除了
  useEffect(() => {
    let newleftDishs: any = _.cloneDeep(leftDishs);
    const newsaveRightData = _.cloneDeep(saveRightData);
    if (
      newleftDishs &&
      newleftDishs.length > 0 &&
      newsaveRightData &&
      newsaveRightData.length > 0
    ) {
      newleftDishs = newleftDishs.map((el: any) => {
        if (el.leftnid && el.trdItems && el.trdItems.length > 0) {
          el.trdItems = el.trdItems.map((item: any) => {
            if (
              newsaveRightData.find(
                (data: any) => data.trdItemId + data.trdUnitId === item.nid
              )
            ) {
              item.style = {};
              item.isDelete = true;
            } else {
              item.isDelete = false;
              item.style = {
                color: "#F00",
                "text-decoration-line": "line-through",
              };
            }
            return item;
          });
        }
        if (el.trdItems) {
          el.trdItems = el.trdItems.map((item: any) => {
            const trdPrice = Number(item.trdPrice);
            const price = Number(el.price);
            item.upPrice = "";
            item.downPrice = "";
            if (trdPrice > price) {
              item.upPrice = (trdPrice * 1000 - price * 1000) / (price * 1000);
            } else if (trdPrice < price) {
              item.downPrice =
                (price * 1000 - trdPrice * 1000) / (price * 1000);
            }
            return item;
          });
        }
        return el;
      });

      renderLeftTreeFn(newleftDishs);
    }
  }, [saveLeftData, rightDishs]);

  // 查询绑定和未绑定数据
  const getMenuItems = () => {
    // 从我方商品里取的三方商品id
    const trdIds: string[] = [];
    const bings: any = [];
    let rightData: any = [];
    let allLoadNum = 0;
    const allLoad = () => {
      allLoadNum++;
      if (allLoadNum == 2) {
        renderRightTreeFn(
          rightData.filter((el: any) => {
            return !trdIds.includes(el.nid);
          })
        );
      }
    };
    // 查询我方菜品
    setLeftLoading(true);
    renderLeftTreeFn([]);
    // 组成搜索字段的字段组
    const queryData: any = {
      shopId: query?.shopId,
      menuId: menuInfo.menuId,
      itemFilter: {},
      trd: {
        needInfo: true,
        channelShopId: menuInfo.id,
      },
    };
    getMapdata(
      queryData,
      (res: any) => {
        const { code, list, page, notBindCount } = res;
        setLeftLoading(false);
        const leftdata = list?.map((item: any) => {
          try {
            item.filterValue = FilterKeys.map(
              (key: string) => item[key] || "-"
            ).join("/");
          } catch (e) {
            //
          }
          if (item?.trdItems) {
            item.trdItems = item.trdItems.map((el: any) => {
              trdIds.push(el.nid);
              const data = {
                trdItemId: el.trdItemId,
                trdUnitId: el.trdUnitId,
                itemId: item.itemId,
                itemName: item.itemName,
                unitId: item.unitId,
                unitName: item.unitName,
                bingId: el.trdItemId + el.trdUnitId + item.itemId + item.unitId,
                bing: true,
              };
              bings.push(data);
              el.filterValue = Object.values(el).join("");
              return el;
            });
          }

          if (
            leftRuleMapRef.current[item.itemId] ||
            leftRuleMapRef.current[item.itemId] == 0
          ) {
            leftRuleMapRef.current[item.itemId] =
              leftRuleMapRef.current[item.itemId] + 1;
          } else {
            leftRuleMapRef.current[item.itemId] = 0;
          }

          // groupName
          return {
            ...item,
            isActive: false,
          };
        });
        setBing(bings);
        allLoad();
        renderLeftTreeFn(leftdata);
        setSaveLeftData(leftdata);
      },
      () => {
        setLeftLoading(false);
      }
    );
    setRightLoading(true);
    renderRightTreeFn([]);
    trdItemQuery({
      channelShopId: menuInfo.id,
    })
      .then((res: any) => {
        setRightLoading(false);
        const { code, data } = res;
        if (code === "000") {
          const allitemlist: any = data.list.map((el: any) => {
            el.filterValue = Object.values(el).join("");
            el.nid = el.trdItemId + el.trdUnitId;
            if (
              rightRuleMapRef.current[el.trdItemId] ||
              rightRuleMapRef.current[el.trdItemId] == 0
            ) {
              rightRuleMapRef.current[el.trdItemId] =
                rightRuleMapRef.current[el.trdItemId] + 1;
            } else {
              rightRuleMapRef.current[el.trdItemId] = 0;
            }
            return el;
          });
          setSaveRightData(allitemlist);
          // renderRightTreeFn(allitemlist);
          rightData = allitemlist;
          allLoad();
        }
      })
      .catch((e) => {
        setRightLoading(false);
      });
  };

  const handleOk = () => {
    const _bind = _.cloneDeep(bing);
    const _leftDishs = _.cloneDeep(leftDishs);

    const leftBind: any = [];
    _leftDishs.forEach((item) => {
      item.trdItems.forEach((el: any) => {
        const data = {
          trdItemId: el.trdItemId,
          trdUnitId: el.trdUnitId,
          itemId: item.itemId,
          itemName: item.itemName,
          unitId: item.unitId,
          unitName: item.unitName,
          bingId: el.trdItemId + el.trdUnitId + item.itemId + item.unitId,
        };
        leftBind.push(data);
      });
    });
    const unBindItems: any = [];
    const relationItem: any = [];
    // 创建一个映射，用于存储b数组中所有元素的bingId
    const bMap = new Map(leftBind.map((item: any) => [item.bingId, item]));
    // 判断 初始化的绑定内容与结果比较，如果初始化的数组中少了哪个，哪个就是被解绑的；
    _bind.forEach((itemA: any) => {
      if (!bMap.has(itemA.bingId)) {
        itemA.itemId = null;
        unBindItems.push(itemA);
      }
    });

    // 结果数组中比初始化中多个哪个，哪个就是要绑定的
    leftBind.forEach((itemB: any) => {
      if (!_bind.some((itemA: any) => itemA.bingId === itemB.bingId)) {
        relationItem.push(itemB);
      }
    });

    setSaveLoading(true);
    bindAndUnbind(
      menuInfo.id,
      menuInfo.menuId,
      [...unBindItems, ...leftBind],
      true,
      (res: any) => {
        setSaveLoading(false);
        if (res.code == "000") {
          message.success(
            t("receipt_template.opera_success", { ns: "Restaurant" })
          );
          onChange();
          handleCancel();
        }
      }
    );
  };

  const handleCancel = () => {
    setOpen(false);
  };

  // 一键解绑
  const unbindAll = () => {
    let _leftDishs: any = _.cloneDeep(leftDishs);
    const _rightDishs = _.cloneDeep(rightDishs);
    _leftDishs = _leftDishs.map((item: any) => {
      (item.trdItems || []).forEach((el: any) => {
        el.isActive = false;
        _rightDishs.push(el);
      });
      item.trdItems = [];
      return item;
    });
    renderLeftTreeFn(_leftDishs);
    renderRightTreeFn(_rightDishs);
    message.success(t("Takeaway.Onekeytounbindcomplete", { ns: "Takeaway" }));
  };

  // 解绑
  const onUnlink = (el: any, item?: any) => {
    const _leftDishs = _.cloneDeep(leftDishs);
    const index = _leftDishs.findIndex((o) => o.leftnid == item.leftnid);
    if (_leftDishs[index]) {
      _leftDishs[index].trdItems = _leftDishs[index].trdItems.filter(
        (o: any) => o.nid != el.nid
      );
      renderLeftTreeFn(_leftDishs);
      const _rightDishs = _.cloneDeep(rightDishs);
      el.isActive = false;
      _rightDishs.push(el);
      renderRightTreeFn(_rightDishs);
    }
  };

  // drag元素的点击事件
  const dradonMouseDownFn = (item: any, e?: any) => {
    setDragActiveItem(item);
    let _rightDishs: any = _.cloneDeep(rightDishs);
    _rightDishs = _rightDishs.map((el: any) => {
      el.isActive = false;
      if (el.nid == item.nid) {
        el.isActive = true;
      }
      return el;
    });
    let _leftDishs: any = _.cloneDeep(leftDishs);
    _leftDishs = _leftDishs.map((el: any) => {
      el.isActive = false;
      if (el.nid == item.nid) {
        el.isActive = true;
      }
      return el;
    });
    renderLeftTreeFn(
      _leftDishs.map((el: any) => {
        return { ...el, isActive: false };
      })
    );
    renderRightTreeFn(_rightDishs);
  };

  // drop 元素点击事件
  const droponMouseDownFn = (item: any, e?: any) => {
    if (e.target.attributes["data-type"]) {
      setDragActiveItem(null);
    }
    if (dragActiveItem && !e.target.attributes["data-type"]) {
      assemblData(dragActiveItem.nid, item.leftnid, true);
    }
  };

  // 左边两列
  // 第一列是我们的，第二列是三方的
  // 右边一列 是三方的
  // 是右侧的三方菜往左侧拖动
  // 左侧第二列，点击解绑 从左侧第二列 回到 右侧
  return (
    <>
      <Modal
        centered={true}
        title={
          <div className="flex justify-between items-center">
            <div>{title}</div>
            <div className="pr-[41px]">
              <Space>
                <Button onClick={unbindAll}>
                  {t("takeaway.btnUnbindAll", { ns: "Takeaway" })}
                </Button>
                <Button
                  type="primary"
                  onClick={() => {
                    autoBatchBind();
                  }}
                >
                  {t("takeaway.btnAutoBindName", { ns: "Takeaway" })}
                </Button>
              </Space>
            </div>
          </div>
        }
        className={`${stylesModel.customModal} ${stylesModel.customModalBind}`}
        open={open}
        destroyOnClose={true}
        footer={
          <div
            className={styles.footerClass}
            style={{ padding: "0 8px 0 16px" }}
          >
            <Space>
              <Button key="back" loading={saveLoading} onClick={handleCancel}>
                {t(CommonEnum.CANCEL, { ns: "Common" })}
              </Button>

              <Button
                key="submit"
                loading={saveLoading}
                type="primary"
                onClick={handleOk}
              >
                {t(CommonEnum.SAVE, { ns: "Common" })}
              </Button>
            </Space>
          </div>
        }
        width={"90%"}
        onCancel={handleCancel}
      >
        <DndContext
          onDragEnd={handleDragEnd}
          onDragMove={handleDragMove}
          onDragStart={handleDragStart}
        >
          <div
            className={`${styles.bindModal}`}
            style={{ padding: "10px 20px" }}
          >
            <div className="title_box">
              <div>
                <h1>
                  {t("takeaway.txtCurStore", { ns: "Takeaway" })}：
                  {query?.treeRow?.name}（ID：
                  {query?.shopId}）
                </h1>
                <h1>
                  {t("takeaway.txtCurTakeMenu", { ns: "Takeaway" })}：
                  {menuInfo.menuName}（ID：
                  {menuInfo.menuId}）
                </h1>
              </div>
              <div>
                <div className="title_select">
                  <Select
                    defaultValue="0"
                    style={{ width: 145, height: 32 }}
                    // options={[
                    //   { value: "0", label: "按商品名称正序" },
                    //   { value: "1", label: "按商品名称倒序" },
                    //   { value: "2", label: "按价格正序" },
                    //   { value: "3", label: "按价格倒序" },
                    // ]}
                    options={[
                      {
                        value: "0",
                        label: t("instant.sortProductNameAsc", {
                          ns: "Takeaway",
                        }),
                      },
                      {
                        value: "1",
                        label: t("instant.sortProductNameDesc", {
                          ns: "Takeaway",
                        }),
                      },
                      {
                        value: "2",
                        label: t("instant.sortPriceAsc", { ns: "Takeaway" }),
                      },
                      {
                        value: "3",
                        label: t("instant.sortPriceDesc", { ns: "Takeaway" }),
                      },
                    ]}
                    onChange={(e: any) => {
                      setSortType(e);
                    }}
                  />
                </div>
                <h1 className="col-desc">
                  {t("instant.bindUnboundProducts", { ns: "Takeaway" })}
                  {/* 选择未绑定的三方平台商品，拖拽或直接点击左侧目标菜品，与当前门店商品进行绑定 */}
                </h1>
              </div>
            </div>
            <div className="left-cont">
              <div className="list-box">
                <div className="col-desc flex justify-between pb-[15px]">
                  <div>
                    {t("takeaway.txtCurStoreMenu", { ns: "Takeaway" })}
                    <LinkOutlined className="ml-[10px] mr-[10px]" />
                    {t("takeaway.txtTrdMenu", { ns: "Takeaway" })}
                  </div>
                  <div>
                    {/* 未绑定 */}
                    {t("instant.unbound", { ns: "Takeaway" })}
                    {
                      leftDishs.filter(
                        (o: any) => !o.trdItems || o.trdItems.length == 0
                      ).length
                    }
                    份/
                    {t("takeaway.txtTotalShares", {
                      ns: "Takeaway",
                      n: leftDishs.length,
                    })}
                  </div>
                </div>

                <div className="mb-[15px]">
                  <Search
                    placeholder={t("common.search", { ns: "Common" })}
                    onChange={(evt: any) => {
                      setLeftQueryVal(evt.target.value);
                    }}
                  />
                </div>
                <div className="col-desc font-bold">
                  {/* 格式说明：<span className={styles.tagbox}>菜单组</span>
                  商品名称 / 规格名称 [售价] */}
                  {t("instant.formatDescription", { ns: "Takeaway" })}：
                  <span className={styles.tagbox}>
                    {t("instant.menuGroup", { ns: "Takeaway" })}
                  </span>
                  {t("instant.productName", { ns: "Takeaway" })} /{" "}
                  {t("instant.specName", { ns: "Takeaway" })} [
                  {t("instant.viewDetails_deDE", { ns: "Takeaway" })}]
                </div>

                {leftLoading && (
                  <div className="flex justify-center pb-[15px]">
                    <Spin />
                  </div>
                )}

                {leftDishs.length > 0 && (
                  <div className="scroll-y">
                    {leftDishs
                      .filter(
                        (o) => (o.filterValue || []).indexOf(leftQueryVal) > -1
                      )
                      .map((item: any) => (
                        <div
                          style={{ cursor: "pointer" }}
                          onMouseDown={(e: any) => droponMouseDownFn(item, e)}
                          className={item.isActive ? "drop-active" : ""}
                        >
                          <Droppable key={item.leftnid} id={item.leftnid}>
                            <div className="dish-item dishflex">
                              <div className="thirdlef">
                                <span className={styles.tagbox}>
                                  {item.menuGroupName || "-"}
                                </span>
                                {item.itemName} / {item.unitName || "-"} {""}
                                <span>
                                  [ {getCurrencySymbol()}
                                  {item.price} ]
                                </span>
                              </div>
                              <div className="thirdlink">
                                <LinkOutlined />
                              </div>
                              <div
                                className="thirdrig"
                                style={{ padding: "0.6em 1em" }}
                              >
                                {item.trdItems &&
                                  item.trdItems.map(
                                    (el: any, index: number) => (
                                      <div
                                        key={index}
                                        className="thirdli"
                                        style={
                                          item.trdItems.length == index + 1
                                            ? { marginBottom: "0" }
                                            : {}
                                        }
                                      >
                                        {el?.nid && (
                                          <div style={el.style}>
                                            <span className={styles.tagbox}>
                                              {el.trdCategoryName || "-"}
                                            </span>
                                            {el?.trdItemName} /{" "}
                                            {el?.trdUnitName || "-"} {""}
                                            <span>
                                              [ {getCurrencySymbol()}
                                              {el?.trdPrice} ]
                                            </span>
                                            {""} {""}
                                            {el.upPrice ? (
                                              <span
                                                style={{
                                                  color:
                                                    "var(--Error, #FF2F2F)",
                                                }}
                                              >
                                                {el.upPrice != Infinity ? (
                                                  <span>
                                                    ↑
                                                    {parseInt(
                                                      String(el.upPrice * 100)
                                                    )}
                                                    %
                                                  </span>
                                                ) : (
                                                  "↑"
                                                )}
                                              </span>
                                            ) : (
                                              ""
                                            )}
                                            {el.downPrice ? (
                                              <span
                                                style={{ color: "#22B497" }}
                                              >
                                                {el.downPrice != Infinity ? (
                                                  <span>
                                                    ↓
                                                    {parseInt(
                                                      String(el.downPrice * 100)
                                                    )}
                                                    %
                                                  </span>
                                                ) : (
                                                  "↓"
                                                )}
                                              </span>
                                            ) : (
                                              ""
                                            )}
                                            {el?.nid && (
                                              <div
                                                className="thirdunlink"
                                                data-type={false}
                                                onClick={() => {
                                                  onUnlink(el, item);
                                                }}
                                              >
                                                {t("takeaway.btnUnbind", {
                                                  ns: "Takeaway",
                                                })}
                                              </div>
                                            )}
                                          </div>
                                        )}
                                      </div>
                                    )
                                  )}
                              </div>
                              {/* <div className="link">
                                <LinkOutlined />
                              </div> */}
                              {/* {item?.trdSkuId && (
                                <div className="col" style={item.style}>
                                  <span className={styles.tagbox}>{item.groupName || "-"}</span>
                                  {item?.trdItemName} / {item?.trdItemSizeName || "-"} {""}
                                  <span>
                                    [ {getCurrencySymbol()}
                                    {item?.trdPrice} ]
                                  </span>
                                  {""} {""}
                                  {item.upPrice ? (
                                    <span style={{ color: "var(--Error, #FF2F2F)" }}>
                                      ↑{parseInt(String(item.upPrice * 100))}%
                                    </span>
                                  ) : (
                                    ""
                                  )}
                                  {item.downPrice ? (
                                    <span style={{ color: "#22B497" }}>
                                      ↓{parseInt(String(item.downPrice * 100))}%
                                    </span>
                                  ) : (
                                    ""
                                  )}
                                </div>
                              )} */}

                              {/* {item?.trdSkuId && (
                                <div
                                  className="unlink"
                                  onClick={() => {
                                    onUnlink(item?.trdSkuId);
                                  }}
                                >
                                  {t("takeaway.btnUnbind", { ns: "Takeaway" })}
                                </div>
                              )} */}
                            </div>
                          </Droppable>
                        </div>
                      ))}
                  </div>
                )}
              </div>
            </div>
            <div className="c-tips">
              <LeftOutlined />
            </div>
            <div className="right-cont">
              <div className="list-box">
                <div className="col-desc flex justify-between pb-[15px]">
                  <div className="flex justify-center align-center">
                    <span>{t("product.btnNoPro", { ns: "Takeaway" })}</span>
                    <ThirdItemsLoad
                      type="2"
                      channelShopId={menuInfo.id}
                      onChange={() => {
                        leftRuleMapRef.current = {};
                        rightRuleMapRef.current = {};
                        getMenuItems();
                      }}
                    />
                  </div>
                  <div>
                    {rightDishs.length}
                    {t("marketing.copies", { ns: "Marketing" })}
                  </div>
                </div>

                <div className="mb-[15px]">
                  <Search
                    placeholder={t("common.search", { ns: "Common" })}
                    onChange={(evt: any) => {
                      setRightQueryVal(evt.target.value);
                    }}
                  />
                </div>

                <div className="col-desc font-bold">
                  {/* 格式说明：<span className={styles.tagbox}>商品分类</span>
                  商品名称 / 规格 [售价] */}
                  {t("instant.formatDescription", { ns: "Takeaway" })}：
                  <span className={styles.tagbox}>
                    {t("instant.productCategory", { ns: "Takeaway" })}
                  </span>
                  {t("instant.productName", { ns: "Takeaway" })} /{" "}
                  {t("instant.spec", { ns: "Takeaway" })} [
                  {t("instant.viewDetails_deDE", { ns: "Takeaway" })}]
                </div>

                {rightLoading && (
                  <div className="flex justify-center pb-[15px]">
                    <Spin />
                  </div>
                )}

                {rightDishs.length > 0 ? (
                  <div
                    className={`scroll-y ${isDraging ? "is-drag" : null}`}
                    onScroll={(evt: any) => {
                      rightBoxScrollTop.current = evt?.target?.scrollTop || 0;
                    }}
                  >
                    <div>
                      {rightDishs
                        .filter(
                          (o) =>
                            (o.filterValue || []).indexOf(rightQueryVal) > -1
                        )
                        .map((item: any, index: number) => (
                          <div
                            onMouseDown={(e: any) => dradonMouseDownFn(item, e)}
                            className={item.isActive ? "drop-active" : ""}
                          >
                            <Draggable id={item.nid} key={index}>
                              <div className="dish-item">
                                <div
                                  className="col"
                                  style={{ padding: "0.6em 1em" }}
                                >
                                  <span className={styles.tagbox}>
                                    {item.trdCategoryName || "-"}
                                  </span>
                                  {item.trdItemName || "-"} / {""}
                                  {item.trdUnitName || "-"}
                                  {""} {""}
                                  <span>
                                    [{""} {getCurrencySymbol()}
                                    {item.trdPrice || "-"} {""}]
                                  </span>
                                </div>
                              </div>
                            </Draggable>
                          </div>
                        ))}
                    </div>
                  </div>
                ) : (
                  <div style={{ marginTop: "150px" }}>
                    <ThirdItemsLoad
                      type="1"
                      channelShopId={menuInfo.id}
                      onChange={() => {
                        leftRuleMapRef.current = {};
                        rightRuleMapRef.current = {};
                        getMenuItems();
                      }}
                    />
                  </div>
                )}
              </div>
            </div>
            {copyDrag && (
              <div
                className="copy-drag"
                style={{
                  left: copyDragPos.x + "px",
                  top: copyDragPos.y + "px",
                  width: copyDragPos.width + "px",
                }}
                dangerouslySetInnerHTML={{ __html: copyDrag }}
              ></div>
            )}
          </div>
        </DndContext>
      </Modal>
    </>
  );
});

export default View;
