import { Divider, Button } from '@douyinfe/semi-ui'
import { CodeGenerator } from '@/Components/Designer/CodeGenerator'
import { ReactComponent as DesignerSVG } from '@/assets/designer.svg'
import { IconArrowLeft } from '@douyinfe/semi-icons'
import PageSwitcher from '@/Components/Designer/components/PageSwitcher'
import { UndoRedo } from '@/Components/Designer/components/UndoRedo'
import { ReactComponent as PreviewIcon } from '@/assets/Toolbar/eye-line.svg'
import { ReactComponent as EditIcon } from '@/assets/Toolbar/edit.svg'
import { ReactComponent as SaveIcon } from '@/assets/Toolbar/save-line.svg'
import SchemaView from '@/Components/Designer/components/SchemaView'
import { LoadExample } from '@/Components/Designer/components/LoadExample'
import { useNavigate } from 'react-router-dom'
import { useEditor } from '@/Components/Designer/Layout/core'

export const Header = () => {
  const saveMetadata = () => {
    // getDesignerStoreInstance().saveMetadata();
  }
  const { enabled, actions } = useEditor((state) => {
    return {
      enabled: state.options.enabled
    }
  })

  // const { designerStore } = useContext(StoreContext)

  const togglePreview = (visible: boolean) => {
    return () => {
      actions.setOptions((options) => {
        options.enabled = visible
      })
      window.setTimeout(() => {
        window.dispatchEvent(new Event('resize'))
      }, 10)
    }
  }

  const navigate = useNavigate()
  return (
    <>
      <div className="flex items-center justify-center px-2 w-[240px] py-2 border-r">
        <div
          className="h-[32px] w-[32px] flex justify-center items-center rounded-[5px] text-blue-500 transition bg-blue-100 hover:bg-blue-200 cursor-pointer"
          onClick={() => navigate(-1)}>
          <IconArrowLeft style={{ fontSize: '20px' }} />
        </div>
        <div className="flex-grow flex items-center justify-center">
          <DesignerSVG width={'26px'}></DesignerSVG>
          <div className="ml-2 font-semibold text-xl">Designer</div>
        </div>
      </div>
      <div className="flex items-center">
        <div className="ml-2  text-medium text-gray-900">
          <PageSwitcher value=""></PageSwitcher>
        </div>
      </div>
      <div className="flex-grow px-2 flex justify-end">
        {enabled ? <LoadExample></LoadExample> : <></>}
        {enabled ? <UndoRedo></UndoRedo> : <></>}
        <SchemaView></SchemaView>
        <CodeGenerator></CodeGenerator>
        {enabled ? (
          <>
            <Button
              onClick={togglePreview(false)}
              icon={<PreviewIcon width={'16px'} fill="currentColor" />}
              className="ml-2"
              type="warning">
              预览
            </Button>
          </>
        ) : (
          <>
            <Button
              onClick={togglePreview(true)}
              theme="solid"
              type="warning"
              icon={<EditIcon width={'16px'} fill="currentColor" />}
              className="ml-2">
              编辑
            </Button>
          </>
        )}
        <Divider margin={'12px'} className="!h-auto" layout="vertical" />
        <Button
          theme="solid"
          icon={<SaveIcon width={'16px'} fill="currentColor" />}
          type="primary"
          onClick={saveMetadata}>
          保存
        </Button>
      </div>
    </>
  )
}
