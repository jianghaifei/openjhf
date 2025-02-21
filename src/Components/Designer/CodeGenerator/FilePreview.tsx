import { FileTree, IFileTree, File } from "@/Components/Designer/CodeGenerator/FileTree"
import { FileContent } from "@/Components/Designer/CodeGenerator/FileContent"
import { useState } from "react"

interface Prop {
  fileTree?: IFileTree
}

export const FilePreview = (prop: Prop) => {
  const [currentFile, setCurrentFile] = useState<File| undefined>(undefined)
  return <div className="flex w-full flex-grow">
    <FileTree onSelect={(file) => {
      setCurrentFile(file)
    }} fileTree={prop.fileTree}></FileTree>
    <FileContent file={currentFile}></FileContent>
  </div>
}