import { Layout } from '@douyinfe/semi-ui'
import { Observer } from 'mobx-react-lite'
import Canvas from '../../../Components/Designer/Layout'
import Sidebar from '../../../Components/Designer/Sidebar'
import PropertyPanel from '../../../Components/Designer/PropertyPanel'
import { EditorProvider } from '../../../Components/Designer/Layout'
import { useContext, useEffect } from 'react'
import StoreContext from '@/Store/storeContext'
import { Header as DesignerHeader } from '@/Components/Designer/components/Header'
import { ComponentHelper } from '@/Library'

import { componentWrapper } from '@/Utils/componentWrapper'
import { RegisterFlame } from '@/Components/Designer/Layout/Basic/RegisterFlame'
import { Container, ContainerCraft } from '@/Components/Designer/Layout/Basic/Container'
import { ContainerSchema } from '@/Components/Designer/Layout/Basic/Base'
import { AbsoluteElement, AbsoluteElementSchema } from '@/Pages/Example/AbsoluteElement'

const Designer = () => {
  const { Header } = Layout
  const { designerStore } = useContext(StoreContext)

  useEffect(() => {
    ComponentHelper.setComponentWrapper(componentWrapper)
    ComponentHelper.register(Container, ContainerSchema, ContainerCraft)
    ComponentHelper.register(AbsoluteElement, AbsoluteElementSchema)
    ComponentHelper.register(
      Container,
      Object.assign({}, { ...ContainerSchema }, { basic: { type: 'Page' } }),
      ContainerCraft
    )
    RegisterFlame(ComponentHelper)
    designerStore.updateInView(true)
    return () => {
      designerStore.updateInView(false)
    }
  }, [designerStore])
  return (
    <EditorProvider>
      <Observer>
        {() => {
          return (
            <div className="w-full h-full text-gray-900">
              <Layout className="h-full">
                <Header className="flex items-center shadow-sm bg-white border-b">
                  <DesignerHeader></DesignerHeader>
                </Header>
                <Layout className="flex-grow overflow-hidden">
                  <Sidebar />
                  <Canvas></Canvas>
                  <PropertyPanel />
                </Layout>
              </Layout>
            </div>
          )
        }}
      </Observer>
    </EditorProvider>
  )
}

export default Designer
