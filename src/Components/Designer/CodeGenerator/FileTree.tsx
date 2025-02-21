import { Tree } from '@douyinfe/semi-ui';
import { TreeNodeData } from '@douyinfe/semi-ui/lib/es/tree';

export interface File {
  name: string
  ext: string
  content: string
}

export interface Dir {
  dirs: Dir[]
  files: File[]
  name: string
}

export interface IFileTree {
  files: File[]
  dirs: Dir[]
  name: string
}


interface Prop {
  fileTree?: IFileTree,
  onSelect: (file?:File) => void
}

export const FileTree = (prop: Prop) => {
  const treeData = prop.fileTree
  const getChildren = (dir: IFileTree | undefined, prefix = '') => {
    if (!dir) return []
    const list: TreeNodeData[] = []
    Array.prototype.forEach.call(dir.dirs, (d: Dir) => {
      list.push({
        isLeaf: false,
        label: d.name,
        key: `${prefix}/${d.name}`,
        children: getChildren(d, `${prefix}/${d.name}`)
      })
    })
    Array.prototype.forEach.call(dir.files, (f: File) => {
      list.push({
        isLeaf: true,
        label: `${f.name}.${f.ext}`,
        key: `${prefix}/${f.name}.${f.ext}`,
        content: f.content,
        ext: f.ext
      })
    })
    return list
  }
  const treeNodeData = getChildren(treeData)
  return <div className='w-[220px] flex-shrink-0'>
    { treeData && <Tree style={{height: '500px'}} className='border' onSelect={(key, selected, node) => {
      if (node.isLeaf) {
        prop.onSelect( {
          name: node.label,
          content: node.content,
          ext: node.ext
        }as File)
      } else {
        prop.onSelect(undefined)
      }
    }} filterTreeNode={true} showFilteredOnly={true} treeData={treeNodeData} directory/> }
  </div>
}