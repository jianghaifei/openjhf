import { IComponentSchema } from '../../../../../Model/IScema'
import ComponentType from '../../../../../Constants/ComponentType.ts'

const schema: IComponentSchema = {
  basic: {
    name: '按钮',
    description: '我是按钮',
    type: ComponentType.Button,
    version: '1.0.0',
    icon: 'icon-anniu'
  },
  layout: {
    width: 4,
    height: 9,
    resizable: false
  },
  properties: [
    {
      key: 'value',
      title: '按钮文字',
      description: 'key1',
      setter: {
        type: ComponentType.Input,
        config: {},
        defaultValue: '我是按钮文字',
        editable: true
      },
      extensions: {
        placeholder: '请输入按钮文字'
      },
      valueType: 'string'
    }
  ]
}
export default schema
