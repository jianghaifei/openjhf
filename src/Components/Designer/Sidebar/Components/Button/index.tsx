import { Button as AntdButton } from 'antd'

/**
 * @description 按钮组件
 * */
const Button = ({ value: value, ...prop }: any) => {
  return (
    <div className="w-full h-full">
      <AntdButton className="w-full h-full p-0" {...prop}>
        {value}
      </AntdButton>
    </div>
  )
}
export default Button
