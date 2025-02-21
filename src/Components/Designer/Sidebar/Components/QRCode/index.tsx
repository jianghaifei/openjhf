import { QRCode as AntdQRCode } from 'antd'

/**
 * @description 二维码组件
 * */
const QrCode = (prop: any) => {
  return (
    <div className="w-full h-full">
      <AntdQRCode className="w-full h-full" {...prop} />
    </div>
  )
}
export default QrCode
