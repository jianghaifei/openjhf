import i18n from "i18next";
import { initReactI18next } from "react-i18next";
import LanguageDetector from "i18next-browser-languagedetector";

// Import User Languages
import zhDefault from "../../Locales/zh_CN/default.json";
import zhBasic from "../../Locales/zh_CN/basic.json";
import enDefault from "../../Locales/en_US/default.json";
import enBasic from "../../Locales/en_US/basic.json";
import jpDefault from "../../Locales/ja_JP/default.json";
import jpBasic from "../../Locales/ja_JP/basic.json";

export const resources = {
  en_US: {
    basic: enBasic,
    default: enDefault,
  },
  zh_CN: {
    basic: zhBasic,
    default: zhDefault,
  },
  ja_JP: {
    basic: jpBasic,
    default: jpDefault,
  },
};

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    fallbackLng: "zh_CN",
    resources: resources,
    defaultNS: "default",
    interpolation: {
      escapeValue: false, // not needed for react as it escapes by default
    },
    // eslint-disable-next-line @typescript-eslint/no-empty-function
  })
  // eslint-disable-next-line @typescript-eslint/no-empty-function
  .catch(() => {});

export default i18n;
