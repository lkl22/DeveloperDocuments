export function isObjectEmpty(data: object): boolean {
  return data === undefined || data == null;
}

export function isArrayEmpty<T>(data: Array<T>): boolean {
  return data === undefined || data == null || data.length === 0;
}

export function isStringEmpty(data: string): boolean {
  return data === undefined || data == null || data === '';
}

export function isStringBlank(data: string): boolean {
  return data === undefined || data == null || data.trim() === '';
}