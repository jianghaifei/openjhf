export interface IApiResult<T> {
    sandbox_id(sandbox_id: any): unknown;
    code: string,
    data: T | null,
    message: string
}