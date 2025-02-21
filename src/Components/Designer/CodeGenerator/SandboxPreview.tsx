import { useEffect, useState } from "react"
import AxiosRequest from "@/Utils/axios"
export type FlattenResult = ResultFile[]
interface ResultFile {
  pathName: string
  content: string
}

interface Files {
  [k: string]: {
    content: string
    isBinary: boolean
  }
}

interface SandBoxFiles {
  template: string
  files: Files
}

interface Prop {
  result?: FlattenResult
}

export const SandboxPreview = (prop: Prop) => {
  const [sandboxID, setSandboxID] = useState('')
  const getSandboxID = (result?: FlattenResult) => {
    if (!result) {
      setSandboxID('')
      return
    }
    const sbf:SandBoxFiles = {
      template: 'create-react-app',
      files: Object.fromEntries(result.map((f: ResultFile) => {
        return [f.pathName, {
          content: f.content,
          isBinary: false
        }] as [string, {content: string, isBinary: boolean}]
      }))
    }
    const CODE_SAND_BOX_API_URL = 'https://codesandbox.io/api/v1/sandboxes/define?json=1'
    AxiosRequest.post(CODE_SAND_BOX_API_URL, sbf, {
      withCredentials: false
    }).then(res => {
      console.log('Res: ', res)
      // eslint-disable-next-line @typescript-eslint/unbound-method
      setSandboxID(res.sandbox_id as unknown as string)
    }, err => {
      console.error('Error:', err)
    })
  }
  useEffect(()=> {
    getSandboxID(prop.result)
  }, [prop.result])
  return <div>
    { sandboxID ? <iframe style={{width: "100%", height: 600, border: 0, zIndex: 100}}
      src={`https://codesandbox.io/embed/${sandboxID}?autoresize=1&fontsize=14&theme=light&view=preview`}
    ></iframe> : <div className="w-full h-[600px] bg-blue-50 text-center items-center flex text-3xl justify-center border-2 border-blue-200 text-blue-400">
      请稍候...
    </div>}
  </div>
}