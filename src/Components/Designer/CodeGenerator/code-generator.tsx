import { Modal, Button, Spin } from '@douyinfe/semi-ui'
import * as Generator from '@cyrilis/code-generator/standalone-loader'
import { useContext, useEffect, useState } from 'react'
import { IFileTree } from './FileTree'
import { FilePreview } from '@/Components/Designer/CodeGenerator/FilePreview'
import { FlattenResult, SandboxPreview } from '@/Components/Designer/CodeGenerator/SandboxPreview'
import DesignerStore from '@/Store/designer'
import ComponentHelper from '@/Utils/ComponentHelper'
import { IconCodeStroked } from '@douyinfe/semi-icons'
import StoreContext from '@/Store/storeContext'
import { IComponent } from '@/Model/IComponent'
import { merge } from 'lodash'
interface Prop {
  schema?: string
  store?: DesignerStore
}

const workerJsUrl = 'https://unpkg.com/@cyrilis/code-generator@0.0.19/dist/standalone-worker.min.js'

export const CodeGenerator = (prop: Prop) => {
  const [visible, setVisble] = useState(false)
  const [result, setResult] = useState<IFileTree | null>(null)
  const [flattenResult, setFlattenResult] = useState<FlattenResult>()

  const { designerStore } = useContext(StoreContext)

  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (visible && loading) {
      Generator.init({ workerJsUrl }).then(
        () => {
          setLoading(false)
        },
        (error: Error) => {
          console.log('Error: ', error)
        }
      )
    }
  }, [visible, loading])

  const stepOver = (tree: IComponent[] | null): IComponent[] => {
    if (!tree) return []
    return tree.map((comp: IComponent) => {
      let component = { ...comp, children: stepOver(comp.children) }
      if (!['Container', 'Page', 'Block'].includes(component.type)) {
        component = {
          id: component.id + '-parent',
          type: 'Container',
          name: 'Container',
          children: [component],
          props: merge({}, component.layout),
          layout: component.layout,
          style: component.style
        }
      }
      return component
    })
  }

  async function generateCode() {
    let schema = prop.schema
    if (!schema) {
      const _schema = designerStore?.getPageData()
      console.log('_schema:', _schema)
      const __schema = {
        basic: {
          title: 'Example Project',
          type: 'Project',
          id: '/',
          config: {}
        },
        style: {
          backgroundColor: '#ffffff',
          fontSize: '16px'
        },
        componentsTree: stepOver(_schema?.componentsTree || []),
        componentsMap: ComponentHelper.getComponentMap()
      }
      schema = JSON.stringify(__schema, null, 4)
      console.log('Schema: ', schema)
    }
    const flattenResult = (await Generator.generateCode({
      solution: 'resto',
      flattenResult: true,
      workerJsUrl,
      schema: schema
    })) as FlattenResult
    const result = await Generator.generateCode({
      solution: 'resto',
      workerJsUrl,
      schema: schema
    })
    setResult(result)
    setFlattenResult(flattenResult)
    console.log('RESULT: \n', result, flattenResult)
    return result
  }

  const toggleVisible = () => {
    const newVal = !visible
    setVisble(newVal)
    if (newVal) {
      generateCode().then(
        (res) => {
          console.log('Result: ', res)
        },
        (err) => {
          console.error('Err', err)
        }
      )
    }
  }

  return (
    <>
      <Button icon={<IconCodeStroked />} onClick={toggleVisible}>
        出码
      </Button>
      <Modal
        title="出码预览"
        visible={visible}
        width={'1200px'}
        onOk={toggleVisible}
        onCancel={toggleVisible}
        closeOnEsc={true}>
        {loading ? (
          <Spin
            tip="Initialzing Code Generator...."
            size="large"
            wrapperClassName="!flex w-full !h-[100px]">
            {' '}
          </Spin>
        ) : (
          <>
            <FilePreview fileTree={result as IFileTree}></FilePreview>
            <SandboxPreview result={flattenResult}></SandboxPreview>
          </>
        )}
      </Modal>
    </>
  )
}
