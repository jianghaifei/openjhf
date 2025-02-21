import { ISchemaEditProps } from '@/Model/ISchemaEditProps.ts'
import { useEffect, useState } from 'react'
import { ICommonConfig } from '@/Model/ICommonModel.ts'
import { Select } from '@douyinfe/semi-ui'
import { SelectProps } from '@douyinfe/semi-ui/lib/es/select'

const { Option } = Select

const Selection = (props: ISchemaEditProps) => {
  const [value, setValue] = useState<SelectProps['value']>(props.value || '')
  const { onChange, schema } = props
  useEffect(() => {
    setValue(props.value || '')
  }, [props.value])

  const dataSource: ICommonConfig = schema.setter.config?.dataSource || []

  return (
    <div className="w-full">
      <Select
        style={{ width: '100%' }}
        disabled={!props.editable}
        value={value}
        onChange={(value: SelectProps['value']) => {
          setValue(value)
          onChange && onChange(value)
        }}>
        {dataSource.map((item: { label: string; value: string }) => {
          return (
            <Option value={item.value} key={item.value}>
              {item.label}
            </Option>
          )
        })}
      </Select>
    </div>
  )
}
export default Selection
