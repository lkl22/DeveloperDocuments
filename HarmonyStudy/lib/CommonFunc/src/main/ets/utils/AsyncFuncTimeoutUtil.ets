export function asyncFuncExec<T>(func: Promise<T>, timeout: number = 3000) {
  return Promise.race([func,
    new Promise((resolve, reject) => {
      setTimeout(() => reject(new Error('exec func timeout.')), timeout);
    })
  ]);
}