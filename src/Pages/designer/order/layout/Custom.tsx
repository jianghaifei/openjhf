import { IconGridStroked } from "@douyinfe/semi-icons";
import { Radio } from "@douyinfe/semi-ui";
import { observer } from "mobx-react-lite";

const layouts = [
  { title: "浮层方式", value: "1", desc: "以浮层方式进行定制商品" },
  { title: "常驻商品区", value: "2", desc: "以固定栏位展示商品定制区" },
  { title: "替换商品区", value: "3", desc: "替换菜单区内容" },
];

const Custom = observer(() => {
  return (
    <div>
      <div className="h-[38px] px-[12px] mb-[16px] flex items-center bg-[#FBFBFB] rounded-[5px]">
        <IconGridStroked className="text-[#4078FD]" style={{ fontSize: 20 }} />
        <span className="mx-[16px] font-bold">商品定制区</span>
        <span className="text-[10px]">
          设置商品定制区（尺寸、口味、做法、加料）常驻在点单页面，还是以浮层（弹层/弹窗/抽屉）方式进行展示
        </span>
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

export default Custom;
