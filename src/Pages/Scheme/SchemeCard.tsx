import { IScheme } from "@/@types/scheme";
import Version from "@/Components/Version";
import { IconChevronDown } from "@douyinfe/semi-icons";
import { Button, Card } from "@douyinfe/semi-ui";
import { observer } from "mobx-react-lite";
import { useNavigate } from "react-router-dom";

interface IProps {
  scheme: IScheme;
}
const SchemeCard = observer<IProps>(({ scheme }) => {
  const navigate = useNavigate();
  const data = [
    { key: "市场", value: scheme.area },
    { key: "业态", value: scheme.businessType },
    { key: "模式", value: scheme.mode },
    { key: "发布商户", value: scheme.shopCount },
  ];
  return (
    <Card
      className="w-[400px] shrink-0"
      style={{ margin: "0 12px 20px" }}
      shadows="hover"
    >
      <div className="mb-[12px] flex justify-between items-center">
        <div className="font-[600] text-[16px]">{scheme.title}</div>
        <Version version={scheme.version} status={scheme.status} />
      </div>
      <div className="flex">
        <div className="h-[24px] mb-[12px] pl-[12px] pr-[12px] leading-[24px] text-[12px] text-center rounded-[12px] text-[#2F54EB] bg-[#F0F5FF]">
          {scheme.category}
        </div>
      </div>
      <div className="flex flex-wrap text-[10px]">
        {data.map((item) => {
          return (
            <div key={item.key} className="w-[50%] flex shrink-0 mb-[12px]">
              <div className="mr-[12px] shrink-0 text-[#949494]">
                {item.key}
              </div>
              <div className="flex-1">{item.value}</div>
            </div>
          );
        })}
      </div>
      <div className="flex">
        <Button className="mr-[8px]">查看版本</Button>
        <Button
          className="mr-[8px]"
          icon={<IconChevronDown />}
          iconPosition="right"
        >
          更多
        </Button>
        <Button
          className="ml-[auto]"
          theme="solid"
          onClick={() => navigate(`/designer?schemeId=${scheme.id}`)}
        >
          创建新版本
        </Button>
      </div>
    </Card>
  );
});

export default SchemeCard;
