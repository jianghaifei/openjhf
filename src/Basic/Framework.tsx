import './Framework.css'
import { ReactNode } from "react"
import { LanguageContextProvider } from "./Language/Provider"
import '@/assets/iconfont/iconfont.css'
const Framework = ({ children }: { children: ReactNode}) => {

  return <>
    <LanguageContextProvider defaultCode="en-US">
      <div className="framework">
        { children }
      </div>
    </LanguageContextProvider>
  </>
}

export default Framework