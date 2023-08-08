import fs from 'fs';
import path from 'path';

/**
 * 复制指定目录所有文件到目标目录
 *
 * @param originDirPath 源目录
 * @param copyDirPath 目标目录
 */
export function copyFolderSync(sourceDirPath: string, targetDirPath: string): void {
  if (!fs.existsSync(sourceDirPath)) {
    return;
  }
  if (!fs.existsSync(targetDirPath)) {
    fs.mkdirSync(targetDirPath);
  }
  // 读取文件夹下的文件
  let files = fs.readdirSync(sourceDirPath, { withFileTypes: true });
  for (let file of files) {
    const sourcePath = path.resolve(sourceDirPath, file.name);
    const targetPath = path.resolve(targetDirPath, file.name);
    // 判断是否是文件夹
    if (file.isDirectory()) {
      copyFolderSync(sourcePath, targetPath);
    } else {
      if (fs.existsSync(targetPath)) {
        fs.unlinkSync(targetPath);
      }
      // 将文件从旧文件夹复制到新文件夹中
      fs.copyFileSync(sourcePath, targetPath);
    }
  }
}

// 递归创建目录 同步方法
export function mkDirsSync(dirName: string) {
  if (fs.existsSync(dirName)) {
    return true;
  } else {
    if (mkDirsSync(path.dirname(dirName))) {
      fs.mkdirSync(dirName);
      return true;
    }
  }
}