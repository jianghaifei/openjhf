import { Button, Layout } from "@douyinfe/semi-ui";
import { observer } from "mobx-react-lite";
import Whole from "./Whole";
import Commodity from "./Commodity";
import Custom from "./Custom";

const Theme = observer(() => {
  const { Header, Content } = Layout;

  return (
    <Layout className="h-full w-full flex flex-col overflow-hidden">
      <Header className="h-[48px] px-[12px] shrink-0 flex justify-between items-center bg-[#ffffff]">
        <div>选择主题</div>
        <Button theme="solid">保存</Button>
      </Header>
      <Content className="flex-1 overflow-auto">
        <div className="m-[16px] mb-0 p-[16px] bg-[#ffffff]">
          <Whole />
          <Commodity />
          <Custom />
        </div>
      </Content>
    </Layout>
  );
});

export default Theme;
