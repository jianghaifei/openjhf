// import the original type declarations
import "i18next";
import { resources } from "./i18n";

declare module "i18next" {
  interface CustomTypeOptions {
    defaultNS: "default";
    resources: {
      basic: (typeof resources)["en_US"]["basic"];
      default: (typeof resources)["en_US"]["default"];
    };
  }
}
