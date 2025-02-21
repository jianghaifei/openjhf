import { Tag as AntdTag } from 'antd'
import BasicComponentModel from '@/ViewModel/BasicComponentModel'
import { toJS } from 'mobx'

/**
 * @description 标签组件
 * */
const Tag = (prop: any) => {
  return (
    <div className="w-full h-full">
      <AntdTag className="w-full h-full" {...prop}>
        {prop.value}
      </AntdTag>
    </div>
  )
}
export default Tag
