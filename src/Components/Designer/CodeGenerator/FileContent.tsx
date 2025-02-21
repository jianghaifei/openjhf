import { File } from "@/Components/Designer/CodeGenerator/FileTree"
interface Prop {
  file?: File
}

export const FileContent = (prop: Prop) => {
  return <div className="flex flex-col flex-grow h-[500px] overflow-hidden">
    {
      prop.file?  <>
        <div className="file-header border px-3 py-2 bg-gray-50 rounded-tr border-l-0 font-bold font-mono">
          {prop.file.name} 
        </div>
        <div className="file-content font-mono text-sm whitespace-pre-wrap bg-gray-900 text-white flex-grow p-2 overflow-auto border-b">
          {prop.file.content} 
        </div>
      </> : <div className="text-gray-500 w-full h-full flex text-center items-center justify-center bg-gray-100 text-3xl flex-grow">
        Please select a file.
      </div>
    }
  </div>
}