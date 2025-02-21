/* eslint-disable @typescript-eslint/no-explicit-any */
import Emitter from "./Emitter";

let emitterInstance: any = null;

export const getEmitterInstance = (): Emitter => {
  if (emitterInstance != null) {
    return emitterInstance;
  }
  emitterInstance = new Emitter();
  return emitterInstance;
};
