import { IconRealSizeStroked } from "@douyinfe/semi-icons";
import { Radio } from "@douyinfe/semi-ui";
import { observer } from "mobx-react-lite";

const sizes = [
  {
    w: 16,
    h: 9,
  },
  {
    w: 4,
    h: 3,
  },
];

const Size = observer(() => {
  return (
    <div>
      <div className="h-[38px] px-[12px] mb-[16px] flex items-center bg-[#FBFBFB] rounded-[5px]">
        <IconRealSizeStroked
          className="text-[#4078FD]"
          style={{ fontSize: 20 }}
        />
        <span className="mx-[16px] font-bold">页面长宽比</span>
        <span className="text-[10px]">
          设置基础长宽比，可指定页面区域自动缩放，以适应不同的屏幕比例
        </span>
      </div>
      <div className="flex items-center">
        {sizes.map((size, index) => {
          const key = `${size.w}:${size.h}`;
          return (
            <div
              key={key}
              className="w-[240px] h-[200px] mx-[10px] mb-[20px] box-border flex flex-col justify-center items-center rounded-[8px] shadow-[0px_0px_5px_0px_#00000026] cursor-pointer"
              style={{
                ...(!index ? { boxShadow: `0px 0px 5px 0px #4078FD` } : null),
              }}
            >
              <div>
                <Radio
                  value={key}
                  checked={!index}
                  className="mb-[16px] self-start"
                >
                  {key}
                </Radio>
                <div
                  className="w-[108px] h-[108px] rounded-[2px] bg-[#E7ECFF] border-[#C9C9C9] border-solid"
                  style={{ width: Math.ceil((108 / size.h) * size.w) }}
                />
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
});

export default Size;
