//InputNumber
import { InputNumber as SemiInputNumber } from '@douyinfe/semi-ui'
import { ISchemaEditProps } from '@/Model/ISchemaEditProps.ts'
import { useEffect, useState } from 'react'

const InputNumber = (props: ISchemaEditProps) => {
  const [value, setValue] = useState(props.value || 0)
  const { schema } = props

  useEffect(() => {
    setValue(props.value)
  }, [props.value])

  const onChange = (val: string | number) => {
    setValue(val)
    props.onChange?.(val)
  }

  return (
    <div className="flex-1">
      <SemiInputNumber
        disabled={!props.editable}
        value={typeof value === 'number' ? value : ''}
        onChange={onChange}
        {...schema.extensions}
      />
    </div>
  )
}
export default InputNumber
