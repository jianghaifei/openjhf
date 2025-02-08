import { Tree, Dropdown, Button, Modal, message } from "antd";
import React, { useEffect, useRef, useState } from "react";
import { UserOutlined, MoreOutlined } from "@ant-design/icons";
import "./index.less";
import _ from "lodash";
import SortSimpleDataDialog from "./sort/SortSimpleDataDialog";
import MenuAdd from "./MenuAdd";
import { nodeSort } from "../../../services/operation/index";

const { TreeNode, DirectoryTree } = Tree;
const Treebox = props => {
  const { treeDtae, onTreeChange, onSelectChange } = props;
  const [gData, setGData] = useState(null);
  const [expandedKeys, setExpandedKeys] = useState([]);
  const [selectKeys, setSelectKeys] = useState([]);
  const [isShowSort, setIsShowSort] = useState(false);
  const [sortData, setSortData] = useState([]);
  const dataRef = useRef({});
  const addRef = useRef(null);

  const downItems = [
    {
      label: "排序",
      key: "1"
    },
    {
      label: "新增",
      key: "2"
    },
    {
      label: "编辑",
      key: "3"
    },
    {
      label: "删除",
      key: "4"
    }
  ];

  // 排序逻辑
  const sort = item => {
    console.log("paixu", item);
    setSortData(item.subNodes);
    setIsShowSort(true);
  };

  const handleSortData = data => {
    console.log("排序结束", data);
    nodeSort({
      nodeUidSortedList: data.map(el => el.code)
    }).then(res => {
      if (res.code != "000") {
        return message.warning(res.msg);
      }
      message.success("排序成功");
      setIsShowSort(false);
      onTreeChange && onTreeChange();
    });
  };

  // 新增
  const addFn = item => {
    console.log("新增", item);
    addRef.current.open({
      title: "新增分组",
      type: "add",
      data: item || null,
      defaultData: {}
    });
  };

  // 编辑
  const editFn = item => {
    console.log("编辑", item);
    addRef.current.open({
      title: "编辑分组",
      type: "edit",
      data: item || null,
      defaultData: {
        nodeName: item.name
      }
    });
  };

  // menuAddfn
  const menuAddfn = () => {
    onTreeChange && onTreeChange();
  };

  const formateData = () => {
    const _treeDtae = _.cloneDeep(treeDtae);
    const _data = {
      subNodes: _treeDtae,
      key: "1",
      value: "1"
    };
    let firstkey = "";
    let firstSelect = "";
    const deepData = data => {
      if (data.subNodes && data.subNodes.length > 0) {
        data.subNodes = data.subNodes.map(el => {
          deepData(el);
          if (!firstkey) {
            firstkey = el.code;
          }
          dataRef.current[el.code] = el;
          if (!firstSelect) {
            firstSelect = el.code;
            onSelect(el.code, { node: el });
          }
          return el;
        });
      }
      data.code = data.code;
      data.selectable = false;
      dataRef.current[data.code] = data;
      return data;
    };
    setGData(deepData(_data));
    setExpandedKeys([firstSelect]);
    setSelectKeys([firstSelect]);
  };

  useEffect(() => {
    formateData();
  }, [treeDtae]);

  // 自定义渲染每个树节点
  const renderTreeNodes = data =>
    data.map(item => {
      if (item.subNodes && item.subNodes.length > 0) {
        return (
          <TreeNode
            title={
              <span className="op_tr_title">
                <i>{item.name}</i>
                <Dropdown.Button
                  type="text"
                  menu={{
                    items: downItems,
                    onClick: e => {
                      switch (e.key) {
                        case "1":
                          sort(item);
                          break;
                        case "2":
                          addFn(item);
                          break;
                        case "3":
                          editFn(item);
                          break;

                        default:
                          break;
                      }
                    }
                  }}
                  icon={<MoreOutlined />}
                ></Dropdown.Button>
              </span>
            }
            key={item.code}
          >
            {renderTreeNodes(item.subNodes)}
          </TreeNode>
        );
      }
      return (
        <TreeNode
          key={item.code}
          title={
            <span className="op_tr_title">
              <i>{item.name}</i>
              <Dropdown.Button
                type="text"
                menu={{
                  items: downItems.filter(el => ["2", "3", "4"].includes(el.key)),
                  onClick: e => {
                    switch (e.key) {
                      case "1":
                        sort(item);
                        break;
                      case "2":
                        addFn(item);
                        break;
                      case "3":
                        editFn(item);
                        break;

                      default:
                        break;
                    }
                  }
                }}
                icon={<MoreOutlined />}
              ></Dropdown.Button>
            </span>
          }
        ></TreeNode>
      );
    });

  // 选中逻辑
  const onSelect = (selectedKeys, e) => {
    if (dataRef.current[selectedKeys]) {
      onSelectChange && onSelectChange(dataRef.current[selectedKeys]);
    }
  };

  return (
    <>
      <div className="op_tr_top">
        <Button
          onClick={() => {
            sort(gData);
          }}
        >
          排序
        </Button>
        <Button
          type="primary"
          onClick={() => {
            addFn();
          }}
        >
          新增
        </Button>
      </div>
      {gData ? (
        <Tree
          fieldNames={{
            name: "title",
            code: "key",
            subNodes: "children"
          }}
          defaultExpandedKeys={expandedKeys}
          defaultSelectedKeys={selectKeys}
          onSelect={onSelect}
          blockNode
          className="op_tr_box"
        >
          {renderTreeNodes(gData.subNodes)}
        </Tree>
      ) : (
        ""
      )}

      <SortSimpleDataDialog
        open={isShowSort}
        title={"目录排序"}
        fieldNames={{
          value: "code",
          label: "name"
        }}
        onOK={handleSortData}
        onCancel={() => {
          setIsShowSort(false);
        }}
        tableData={sortData || []}
      />

      <MenuAdd ref={addRef} onChange={menuAddfn} />
    </>
  );
};
export default Treebox;
