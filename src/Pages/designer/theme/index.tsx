import { Button, Layout } from "@douyinfe/semi-ui";
import { observer } from "mobx-react-lite";
import Color from "./Color";
import Size from "./Size";
import MainMenu from "./MainMenu";

const Theme = observer(() => {
  const { Header, Content } = Layout;

  return (
    <Layout className="h-full w-full flex flex-col overflow-hidden">
      <Header className="h-[48px] px-[12px] shrink-0 flex justify-between items-center bg-[#ffffff]">
        <div>选择主题</div>
        <Button theme="solid">保存</Button>
      </Header>
      <Content className="flex-1 overflow-auto">
        <div
          className="m-[16px] mb-0 p-[16px] bg-[#ffffff] box-border"
          style={{ minHeight: "calc(100% - 16px)" }}
        >
          <Color />
          <Size />
          <MainMenu />
        </div>
      </Content>
    </Layout>
  );
});

export default Theme;
