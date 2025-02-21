import Version from "@/Components/Version";
import { IconCrossStroked } from "@douyinfe/semi-icons";
import { Layout } from "@douyinfe/semi-ui";
import { observer } from "mobx-react-lite";
import Menu from "./Menu";
import { Outlet } from "react-router-dom";
import StoreContext from "@/Store/storeContext";
import { useContext } from "react";

const Preset = observer(() => {
  const { designerStore } = useContext(StoreContext);

  return (
    <>
    { designerStore.inEditorView ? <Outlet></Outlet> : <Layout className="h-full w-full overflow-hidden">
      <Layout.Header className="h-[48px] flex px-[16px] justify-between items-center shadow-md z-[100]">
        <div className="flex items-center">
          <div className="mr-[10px] h-[32px] w-[32px] flex justify-center items-center rounded-[5px] bg-[#CED9FF]">
            <IconCrossStroked
              className="text-[#4078FD]"
              style={{ fontSize: "20px" }}
            />
          </div>
          应用设计器-茶饮POS方案
        </div>
        <Version version={1} status={1} />
      </Layout.Header>
      <Layout className="flex flex-1 overflow-hidden">
        <Layout.Sider className="w-[200px] h-full overflow-hidden border-r-gray-200 border-solid border-0 border-r">
          <Menu />
        </Layout.Sider>
        <Layout.Content className="h-full flex-1 overflow-hidden">
          <Layout className="h-full w-full flex flex-col">
            <Layout.Content className="flex-1 h-full bg-gray-100 overflow-hidden">
              <Outlet />
            </Layout.Content>
          </Layout>
        </Layout.Content>
      </Layout>
    </Layout>
    }</>
  );
});

export default Preset;
