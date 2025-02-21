import { Modal, Button, Divider } from '@douyinfe/semi-ui'
import { useContext, useState } from 'react'
import { IconCodeStroked } from '@douyinfe/semi-icons'
import StoreContext from '@/Store/storeContext'

export const SchemaView = () => {
  const [visible, setVisble] = useState(false)

  const { designerStore } = useContext(StoreContext)

  const [schema, setSchema] = useState('')

  const toggleVisible = () => {
    const newVal = !visible
    setVisble(newVal)
    if (newVal) {
      const _schema = designerStore.getPageData()
      const _schemaString = JSON.stringify(_schema, null, 4)
      setSchema(_schemaString)
    }
  }

  return (
    <>
      <Button icon={<IconCodeStroked />} onClick={toggleVisible}>
        Schema
      </Button>
      <Divider margin={'12px'} className="!h-auto" layout="vertical" />
      <Modal
        title="View Schema"
        visible={visible}
        width={'1200px'}
        onOk={toggleVisible}
        onCancel={toggleVisible}
        closeOnEsc={true}>
        <div className="pre font-mono w-full h-full overflow-auto  whitespace-pre-wrap bg-gray-900 text-white p-2">
          {schema}
        </div>
      </Modal>
    </>
  )
}

export default SchemaView
