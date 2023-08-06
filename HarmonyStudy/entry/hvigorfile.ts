// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.

import path from 'path';
import { hvigor, getHvigorNode } from '@ohos/hvigor';
import fs from 'fs';

const KEY_ENV = 'env';
const KEY_BUILD_TYPE = 'buildType';
const DEFAULT_ENV = 'product';
const DEFAULT_BUILD_TYPE = 'release';

let hvigorNode = getHvigorNode(__filename);
let extraConfig: Map<string, string> = hvigor.getExtraConfig();
printMap(extraConfig);
console.log(`script: path ${__filename} ${typeof hvigorNode}`);

let env = extraConfig.get(KEY_ENV);
let buildType = extraConfig.get(KEY_BUILD_TYPE);
console.log(`script: params from command env ${env} buildType ${buildType}`);

let project = hvigorNode.getProject();
let projectDir = project.getNodeDir();
console.log(`script: projectName ${project.getName()} dir: ${projectDir}`);

if (!env || !buildType) {
  let appConfigStr = fs.readFileSync(path.join(projectDir, 'appConfig.json'), 'utf8');
  console.log(`script: appConfig file content:\n ${appConfigStr}`);
  let appConfig = JSON.parse(appConfigStr);
  console.log(`script: appConfig: ${appConfig.appBuild[KEY_ENV]} ${appConfig.appBuild[KEY_BUILD_TYPE]}`);
  env = env ?? appConfig.appBuild[KEY_ENV];
  buildType = buildType ?? appConfig.appBuild[KEY_BUILD_TYPE];
  console.log(`script: params from appConfig env ${env} buildType ${buildType}`);
}

env = env ?? DEFAULT_ENV;
buildType = buildType ?? DEFAULT_BUILD_TYPE;
console.log(`script: final build params env ${env} buildType ${buildType}`);

hvigorNode.task(() => {
  console.log('This is a preEnv task');
}, 'preEnv');

function printMap(data: Map<K, V>): void {
  console.log('script: printMap start.');
  console.log(JSON.stringify(Object.fromEntries(data)));
  console.log('script: printMap end.');
}

export { hapTasks } from '@ohos/hvigor-ohos-plugin';
