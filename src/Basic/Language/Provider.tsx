import { useState, createContext } from "react";
import i18n from './i18n'

interface ILanguageContext {
  language: string,
  setLanguage: (lang: string) => void
}

interface Props {
  defaultCode: string,
  children: React.ReactNode
}

export const LanguageContext = createContext<ILanguageContext>({
  language: "zh-CN",
  // eslint-disable-next-line @typescript-eslint/no-empty-function
  setLanguage: () => {}
});

export const LanguageContextProvider = ({defaultCode, children} : Props) => {
  const [language, setLanguage] = useState(defaultCode);
  const setLanguageFunc = (str: string) => {
    // eslint-disable-next-line @typescript-eslint/no-empty-function
    i18n.changeLanguage(str).catch(() => {})
    setLanguage(str)
  }
  const languageValue = { language, setLanguage: setLanguageFunc };
  return <LanguageContext.Provider value={languageValue}>
    { children }
  </LanguageContext.Provider>
}