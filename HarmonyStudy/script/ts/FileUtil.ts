import fs from 'fs';
import path from 'path';

/**
 * 复制指定目录所有文件到目标目录
 *
 * @param originDirPath 源目录
 * @param copyDirPath 目标目录
 */
export function copyDirs(originDirPath: string, copyDirPath: string): void {
  if (!fs.existsSync(originDirPath)) {
    return;
  }
  // 读取文件夹下的文件
  let files = fs.readdirSync(originDirPath, { withFileTypes: true });
  for (let file of files) {
    // 判断是否是文件夹
    if (file.isDirectory()) {
      // 如果是文件夹就递归变量把最新的文件夹路径传过去
      const originDir = path.resolve(originDirPath, file.name);
      const copyDir = path.resolve(copyDirPath, file.name);
      if (!fs.existsSync(copyDir)) {
        fs.mkdirSync(copyDir);
      }
      copyDirs(originDir, copyDir);
    } else {
      // 获取旧文件夹中要复制的文件
      const originFile = path.resolve(originDirPath, file.name);
      // 获取新文件夹中复制的地方
      const copyFile = path.resolve(copyDirPath, file.name);
      if (fs.existsSync(copyFile)) {
        fs.unlinkSync(copyFile);
      }
      // 将文件从旧文件夹复制到新文件夹中
      fs.copyFileSync(originFile, copyFile);
    }
  }
}