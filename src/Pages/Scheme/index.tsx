import {
  IconBellStroked,
  IconChevronDown,
  IconChevronDownStroked,
  IconHelpCircleStroked,
  IconSearchStroked,
} from "@douyinfe/semi-icons";
import { Dropdown, Layout, Select } from "@douyinfe/semi-ui";
import { TriggerRenderProps } from "@douyinfe/semi-ui/lib/es/select";
import SchemeCard from "./SchemeCard";
import { observer } from "mobx-react-lite";
import { useContext } from "react";
import StoreContext from "@/Store/storeContext";

const Scheme = observer(() => {
  const rootStore = useContext(StoreContext);
  const { schemeStore } = rootStore;
  const triggerRender = (props: TriggerRenderProps | undefined) => {
    if (!props) return null;
    const { value } = props;
    return (
      <div
        style={{
          minWidth: "112",
          height: 32,
          display: "flex",
          alignItems: "center",
          paddingLeft: 8,
          borderRadius: 3,
        }}
      >
        <div
          style={{
            margin: 4,
            whiteSpace: "nowrap",
            textOverflow: "ellipsis",
            flexGrow: 1,
            overflow: "hidden",
            display: "flex",
            alignItems: "center",
          }}
        >
          {value.map((item) => item.label).join(" , ")}
          <IconChevronDown style={{ margin: "0 8px", flexShrink: 0 }} />
        </div>
      </div>
    );
  };

  return (
    <Layout className="h-full w-full overflow-hidden">
      <Layout.Header className="w-full h-[48px] flex items-center bg-[rgba(0,0,0,0.8)] text-[#ffffff]">
        <div className="w-[240px] flex justify-center shrink-0 text-[20px]">
          RestoSuite
        </div>
        <div className="flex-1">
          <Select
            style={{ outline: 0 }}
            borderless={true}
            triggerRender={triggerRender}
            placeholder="请选择业务线"
          >
            <Select.Option value="abc">抖音</Select.Option>
            <Select.Option value="ulikecam">轻颜相机</Select.Option>
            <Select.Option value="jianying" disabled>
              剪映
            </Select.Option>
            <Select.Option value="xigua">西瓜视频</Select.Option>
          </Select>
        </div>
        <div className="flex items-center shrink-0 pl-[10px] pr-[20px]">
          <IconSearchStroked className="mr-[20px]" />
          <IconBellStroked className="mr-[20px]" />
          <IconHelpCircleStroked className="mr-[20px]" />
          <Dropdown
            trigger="click"
            render={
              <Dropdown.Menu>
                <Dropdown.Item>退 出</Dropdown.Item>
              </Dropdown.Menu>
            }
          >
            <div className="flex items-center">
              Jordan Jr
              <IconChevronDownStroked className="ml-[5px]" />
            </div>
          </Dropdown>
        </div>
      </Layout.Header>
      <Layout.Content className="flex flex-col flex-1 overflow-hidden">
        <Layout.Header className="h-[48px] flex items-center pl-[20px] text-[16px]">
          选择或编辑方案
        </Layout.Header>
        <Layout.Content className="flex flex-1 flex-wrap overflow-auto p-[20px] bg-[#F0F0F0]">
          {schemeStore.schemeList.map((item) => {
            return <SchemeCard key={item.id} scheme={item} />;
          })}
        </Layout.Content>
      </Layout.Content>
    </Layout>
  );
});

export default Scheme;
