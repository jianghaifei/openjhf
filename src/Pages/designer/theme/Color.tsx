import { IconFillStroked, IconTick } from "@douyinfe/semi-icons";
import { observer } from "mobx-react-lite";

const colors = [
  "#4078FD",
  "#E13C39",
  "#E76033",
  "#EFB041",
  "#5ABFC1",
  "#72C240",
  "#3853E2",
  "#6A32C9",
];

const Color = observer(() => {
  return (
    <div>
      <div className="h-[38px] px-[12px] mb-[16px] flex items-center bg-[#FBFBFB] rounded-[5px]">
        <IconFillStroked className="text-[#4078FD]" style={{ fontSize: 20 }} />
        <span className="mx-[16px] font-bold">色彩方案</span>
        <span className="text-[10px]">设置页面的基础主要颜色</span>
      </div>
      <div className="flex items-center">
        {colors.map((color, index) => {
          return (
            <div
              key={color}
              className="h-[92px] w-[92px] mx-[10px] mb-[20px] flex justify-center items-center rounded-[8px] shadow-[0px_0px_5px_0px_#00000026] cursor-pointer"
              style={{
                ...(!index ? { boxShadow: `0px 0px 5px 0px ${color}` } : null),
              }}
            >
              <div
                className="h-[60px] w-[60px] flex justify-center items-center rounded-[8px]"
                style={{ backgroundColor: color }}
              >
                {!index ? (
                  <IconTick
                    style={{
                      fontSize: 40,
                      fontWeight: 700,
                      color: "#ffffff",
                    }}
                  />
                ) : null}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
});

export default Color;
