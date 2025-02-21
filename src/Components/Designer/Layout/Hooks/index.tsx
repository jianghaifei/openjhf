import { useEditor } from '@/Components/Designer/Layout/core'
import StoreContext from '@/Store/storeContext'
import { useContext } from 'react'

export const useActions = () => {
  const { enabled, actions } = useEditor((state) => {
    return {
      enabled: state.options.enabled
    }
  })

  const { designerStore } = useContext(StoreContext)

  const togglePreview = () => {
    actions.setOptions((options) => {
      options.enabled = !enabled
    })
    window.setTimeout(() => {
      window.dispatchEvent(new Event('resize'))
    }, 10)
  }
  return {
    togglePreview,
    designerStore
  }
}
