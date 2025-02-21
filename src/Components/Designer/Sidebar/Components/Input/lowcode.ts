import { IComponentSchema } from '@/Model/IScema.ts'
import ComponentType from '@/Constants/ComponentType.ts'

const schema: IComponentSchema = {
  basic: {
    name: '输入框',
    description: '我是输入框',
    type: ComponentType.Input,
    version: '1.0.0',
    icon: 'icon-danhangshurukuang'
  },
  layout: {
    width: 5,
    height: 8,
    resizable: false
  },
  properties: [
    {
      key: 'value',
      title: '文字',
      description: '我是用来设置文字的',
      setter: {
        type: ComponentType.Input,
        config: {},
        defaultValue: '',
        editable: true
      },
      extensions: {
        placeholder: '请输入内容'
      },
      valueType: 'string'
    }
  ]
}
export default schema
