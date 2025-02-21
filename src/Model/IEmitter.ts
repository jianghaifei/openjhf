/* eslint-disable @typescript-eslint/no-explicit-any */

export type AnyFunc = (...arg: any[]) => any | void;

export interface IEmitter {
  on: (
    event: string,
    listener: AnyFunc,
    thisObj?: any,
    ...extraArgs: any[]
  ) => string;
  once: (
    event: string,
    listener: AnyFunc,
    thisObj?: any,
    ...extraArgs: any[]
  ) => string;
  off: (event: string, listenerOrId: AnyFunc | string) => void;
  offAll: (event: string) => void;
  emit: (event: string, ...args: any[]) => void;
}
