import { v4 as uuid } from 'uuid'
import { IPageMetadata } from '@/Model/IPageMetadata.ts'

export const pageData: IPageMetadata = {
  id: uuid(),
  type: 'page',
  props: {
    title: '页面标题'
  },
  style: {
    backgroundColor: '#fff',
    fontSize: '16px',
    fontFamily: 'default'
  },
  componentsTree: []
}
