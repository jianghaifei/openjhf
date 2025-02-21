import { IconGridStroked } from "@douyinfe/semi-icons";
import { Radio } from "@douyinfe/semi-ui";
import { observer } from "mobx-react-lite";

const layouts = [
  { title: "商品分组在顶部", value: "1", desc: "多级分组一并展示在商品区顶部" },
  { title: "商品分组在右侧", value: "2", desc: "顶级分组展示在右侧" },
  {
    title: "商品分组在左侧",
    value: "3",
    desc: "多级分组中的二级分组将展示在左侧",
  },
];

const Commodity = observer(() => {
  return (
    <div>
      <div className="h-[38px] px-[12px] mb-[16px] flex items-center bg-[#FBFBFB] rounded-[5px]">
        <IconGridStroked className="text-[#4078FD]" style={{ fontSize: 20 }} />
        <span className="mx-[16px] font-bold">商品区布局</span>
        <span className="text-[10px]">设置点单页的商品备选区布局</span>
      </div>
      <div className="flex flex-wrap items-center">
        {layouts.map((item, index) => {
          return (
            <div
              key={item.value}
              className="w-[360px] h-[280px] mx-[10px] mb-[20px]  box-border flex flex-col justify-center items-center rounded-[8px] shadow-[0px_0px_5px_0px_#00000026] cursor-pointer"
              style={{
                ...(!index ? { boxShadow: `0px 0px 5px 0px #4078FD` } : null),
              }}
            >
              <div>
                <Radio
                  value={item.value}
                  checked={!index}
                  className="mb-[16px] self-start"
                >
                  {item.title}
                </Radio>
                <div className="w-[300px] h-[170px] mb-[16px] bg-[#E7ECFF] border-[#C9C9C9] border-solid" />
                <div className="text-[10px] text-[#949494]">{item.desc}</div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
});

export default Commodity;
