import { IComponentSchema } from '@/Model/IScema.ts'
import ComponentType from '@/Constants/ComponentType.ts'

const schema: IComponentSchema = {
  basic: {
    name: '标签',
    description: '我是标签',
    type: ComponentType.Tag,
    version: '1.0.0',
    icon: 'icon-biaoqian'
  },
  layout: {
    width: 3,
    height: 6,
    resizable: false
  },
  properties: [
    {
      key: 'value',
      title: '文字',
      description: '我是文字',
      setter: {
        type: ComponentType.Input,
        config: {},
        defaultValue: '我是标签',
        editable: true
      },
      extensions: {
        placeholder: '请输入内容'
      },
      valueType: 'string'
    },
    {
      key: 'color',
      title: '颜色',
      description: '我是颜色',
      setter: {
        type: ComponentType.ColorPicker,
        config: {},
        defaultValue: 'skyblue',
        editable: true
      },
      extensions: {},
      valueType: 'string'
    }
  ]
}
export default schema
