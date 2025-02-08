import { Modal, InputNumber } from "antd";
import { useState, useEffect } from "react";
import { SortListDndKit, SortItemDndKit } from "./DndDragList";
import "./index.less"
import _ from "lodash";


const SortSimpleDataDialog = (props) => {
  const { open, onOK, onCancel, title, tableData, fieldNames } = props;
  const [data, setData] = useState([]);

  useEffect(() => {
    const list = tableData.map((dataItem, dataIndex) => {
      return {
        ...dataItem,
        index: dataIndex + 1,
      };
    });
    sortList(list);
  }, [fieldNames, tableData]);

  const sortList = (list) => {
    setData(
      list.map((item, index) => {
        return { ...item, index: index + 1 };
      })
    );
  };

  const onDragEnd = (list) => {
    sortList(list);
  };

  const onInputChange = (newIndex, originIndex) => {
    const item = _.cloneDeep(data[originIndex]);
    const list = _.cloneDeep(data);
    list.splice(originIndex, 1);
    list.splice(newIndex - 1, 0, item);
    sortList(list);
  };
  // 字母排序
  const ascSort = () => {
    const list = _.cloneDeep(data);
    list.sort((a, b) => {
      const x1 = a[fieldNames.label].toUpperCase();
      const x2 = b[fieldNames.label].toUpperCase();
      if (x1 < x2) {
        return -1;
      }
      if (x1 > x2) {
        return 1;
      }
      return 0;
    });
    sortList(list);
  };
  return (
    <Modal
      title={title}
      open={open}
      width={700}
      okText={"保存"}
      cancelText={"取消"}
      onOk={() => {
        onOK(data);
      }}
      onCancel={onCancel}
    >
      <div className="text-gray-400 mb-5" style={{marginBottom:"5px"}}>
        拖动行/输入序号进行排序，显示顺序将在下次发布后生效。
        {/* <Trans
          // t={t as unknown as TFunction<['Tips'], undefined>}
          // ns={'Tips'}
          // i18nKey={TipsEnum.sortTips}
          // values={{
          //   text: t(CommonEnum.Alphabetize, { ns: 'Common' })
          // }}
          components={{
            button: <span className="text-sky-400 cursor-pointer" onClick={ascSort} />
          }}
        /> */}
      </div>

      <SortListDndKit idKey={fieldNames.value} list={data} onDragEnd={onDragEnd}>
        <div className={`sortCont mb-5`}>
          {data.map((item, index) => (
            <SortItemDndKit key={item[fieldNames.value]} id={item[fieldNames.value]}>
              <div className={`sort-item`}>
                <div className="name">{item[fieldNames.label]}</div>
                <InputNumber
                  className="input-item"
                  min={1}
                  onChange={(value) => {
                    value && onInputChange(value, index);
                  }}
                  value={index + 1}
                />
              </div>
            </SortItemDndKit>
          ))}
        </div>
      </SortListDndKit>
    </Modal>
  );
};

export default SortSimpleDataDialog;
