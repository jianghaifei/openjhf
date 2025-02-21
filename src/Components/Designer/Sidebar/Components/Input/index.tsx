import { Input as AntdInput } from 'antd'
import BasicComponentModel from '@/ViewModel/BasicComponentModel'
import { toJS } from 'mobx'

/**
 * @description 输入框组件
 * */
const Input = (prop: any) => {
  return (
    <div className="w-full h-full">
      <AntdInput className="w-full h-full" readOnly {...prop} />
    </div>
  )
}
export default Input
