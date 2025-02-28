import { Avatar } from 'antd';
import { UserOutlined } from '@ant-design/icons';
import BoCommon from "@restosuite/bo-common";
const { BoPageContainer } = BoCommon;

const Page = () => {
  return <BoPageContainer title='hello'>
    <div className="text-center">
      <Avatar size={64} icon={<UserOutlined />} />
      <h1>Hello, 我是子应用</h1>
    </div>
  </BoPageContainer>
}

export default Page;