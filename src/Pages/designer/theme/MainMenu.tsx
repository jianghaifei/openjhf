import { IconMenu } from "@douyinfe/semi-icons";
import { Radio } from "@douyinfe/semi-ui";
import { observer } from "mobx-react-lite";

const list = [
  {
    key: 1,
    label: "可展开的Home键",
  },
  {
    key: 2,
    label: "常驻功能键",
  },
];

const MainMenu = observer(() => {
  return (
    <div>
      <div className="h-[38px] px-[12px] mb-[16px] flex items-center bg-[#FBFBFB] rounded-[5px]">
        <IconMenu className="text-[#4078FD]" style={{ fontSize: 20 }} />
        <span className="mx-[16px] font-bold">主菜单</span>
        <span className="text-[10px]">
          常驻功能栏用于应用主要页面间的快捷导航，一旦设定，系统将为主功能栏
        </span>
      </div>
      <div className="flex items-center">
        {list.map((item, index) => {
          return (
            <div
              key={item.key}
              className="w-[240px] h-[200px] mx-[10px] mb-[20px] p-[25px] box-border flex flex-col justify-center items-center rounded-[8px] shadow-[0px_0px_5px_0px_#00000026] cursor-pointer"
              style={{
                ...(!index ? { boxShadow: `0px 0px 5px 0px #4078FD` } : null),
              }}
            >
              <div>
                <Radio
                  value={item.key}
                  checked={!index}
                  className="mb-[16px] self-start"
                >
                  {item.label}
                </Radio>
                <div className="w-[192px] h-[108px] rounded-[2px] bg-[#E7ECFF] border-[#C9C9C9] border-solid" />
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
});

export default MainMenu;
