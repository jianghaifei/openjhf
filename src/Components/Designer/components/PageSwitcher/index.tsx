import { Select, Button } from "@douyinfe/semi-ui"
import { useState } from "react"

const NewPage = () => {
  return <div className="w-full border-t -mb-[3px] p-[4px]">
    <Button theme="borderless" className="w-full">添加新自定义页面</Button>
  </div>
}

interface Prop {
  value: string
  onChange?: (val?: string | number | any[] | Record<string, any>) => void
}

export const PageSwitcher = (prop: Prop) => {
  const [page, setPage] = useState('order')

  const onChange = (value?: string | number | any[] | Record<string, any>) => {
    prop.onChange?.(value)
    setPage(page)
  }

  return <div>
    <Select
      value={page}
      style={{ minWidth: 200 }}
      dropdownStyle={{ width: 180 }}
      maxHeight={150}
      outerBottomSlot={<NewPage></NewPage>}
      placeholder="请选择页面"
      autoAdjustOverflow={false}
      position="bottom"
      onChange={onChange}
    >
      <Select.Option value="order">点餐页面</Select.Option>
      <Select.Option value="ulikecam">登录页面</Select.Option>
      <Select.Option value="jianying">支付页面</Select.Option>
      <Select.Option value="duoshan">订单列表</Select.Option>
      <Select.Option value="xigua">会员管理</Select.Option>
    </Select>
  </div>
}

export default PageSwitcher