import { Badge as AntdBadge, Avatar } from 'antd'

/**
 * @description 通知组件
 * */
const Badge = (prop: any) => {
  return (
    <div className="w-full h-full">
      <AntdBadge className="w-full h-full" {...prop}>
        <Avatar className="w-full h-full" shape="square" size="large" />
      </AntdBadge>
    </div>
  )
}
export default Badge
