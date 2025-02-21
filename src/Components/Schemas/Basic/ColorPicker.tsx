import { useEffect, useState } from 'react'
import { ColorResult, SketchPicker } from 'react-color'
import { ISchemaEditProps } from '@/Model/ISchemaEditProps.ts'
import { Input, Popover } from '@douyinfe/semi-ui'

const ColorPicker = (props: ISchemaEditProps) => {
  const [value, setValue] = useState<string | undefined>(props.value)
  const [visible, setVisible] = useState(false)
  const handlerChange = (value?: ColorResult) => {
    setValue(value ? value.hex : undefined)
    props.onChange && props.onChange(value ? value.hex : undefined)
  }
  useEffect(() => {
    console.log('value: ', props.value)
    setValue(props.value || undefined)
  }, [props.value])

  return (
    <Popover
      visible={visible}
      trigger="custom"
      position="top"
      onClickOutSide={() => setVisible(false)}
      content={
        <SketchPicker
          color={value || undefined}
          onChange={(value: ColorResult) => handlerChange(value)}
        />
      }>
      <Input
        onFocus={() => {
          setVisible(true)
        }}
        value={value}
        onClear={() => {
          handlerChange()
        }}
        showClear
        prefix={
          <div
            className="w-[20px] h-[20px] ml-[6px] mr-[6px] border border-gray-400"
            style={{ backgroundColor: value }}></div>
        }
      />
    </Popover>
  )
}
export default ColorPicker
