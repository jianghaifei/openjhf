import { useEffect, useState } from 'react'
import { ISchemaEditProps } from '@/Model/ISchemaEditProps.ts'
import { Input as SemiInput } from '@douyinfe/semi-ui'

const Input = (props: ISchemaEditProps) => {
  const { value, editable, schema, onChange } = props
  const [inputValue, setInputValue] = useState(value)
  useEffect(() => {
    setInputValue(props.value)
  }, [props.value])

  const onBlur = () => {
    // if (onChange) onChange(inputValue)
  }
  return (
    <SemiInput
      className="border"
      disabled={!editable}
      value={inputValue}
      {...schema.extensions}
      onChange={(value) => {
        setInputValue(value)
        onChange?.(value)
      }}
      onBlur={onBlur}
    />
  )
}
export default Input
