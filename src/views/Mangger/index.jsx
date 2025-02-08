import { Tree, Button } from "antd";
import React, { useState } from "react";
import Treebox from "./components/Treebox";
import Table from "./components/Table";
import { queryTree } from "../../services/operation/index";
import { useEffect } from "react";
import "./index.less";

const App = () => {
  const [treeDtae, setTreeDtae] = useState(null);
  const [apiData, setApiData] = useState(null);
  const getTreeData = () => {
    queryTree({}).then(res => {
      // eslint-disable-next-line
      setTreeDtae(res.data.topNodes);
    });
  };
  useEffect(() => {
    getTreeData();
  }, []);

  const onSelectChange = item => {
    setApiData(item);
  };

  return (
    <div className="op_box">
      <div className="op_tree">
        {treeDtae ? <Treebox treeDtae={treeDtae} onTreeChange={getTreeData} onSelectChange={onSelectChange} /> : ""}
      </div>
      <div className="op_table">{apiData ? <Table apiData={apiData} onTableChange={getTreeData}></Table> : ""}</div>
    </div>
  );
};
export default App;
