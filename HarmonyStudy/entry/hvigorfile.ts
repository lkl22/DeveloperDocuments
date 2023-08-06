// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.

import path from 'path';
import { hvigor, getHvigorNode, parseJsonFile, HvigorLogger, LocalFileWriter } from '@ohos/hvigor';
import fs from 'fs';

const KEY_ENV: string = 'env';
const KEY_BUILD_TYPE: string = 'buildType';

const DEFAULT_ENV: string = 'product';
const DEFAULT_BUILD_TYPE: string = 'release';

const APP_CONFIG_FILE_NAME: string = 'appConfig.json';

let hvigorNode = getHvigorNode(__filename);
let extraConfig: Map<string, string> = hvigor.getExtraConfig();
printMap(extraConfig);
console.log(`script: path ${__filename} ${hvigorNode.getName()}`);

let env: string = extraConfig.get(KEY_ENV);
let buildType: string = extraConfig.get(KEY_BUILD_TYPE);
console.log(`script: params from command env ${env} buildType ${buildType}`);

let project = hvigorNode.getProject();
let projectDir = project.getNodeDir();
console.log(`script: projectName ${project.getName()} dir: ${projectDir}`);

if (!env || !buildType) {
  let appConfig = parseJsonFile(path.join(projectDir, APP_CONFIG_FILE_NAME));
  console.log(`script: appConfig env ${appConfig.appBuild[KEY_ENV]} buildType ${appConfig.appBuild[KEY_BUILD_TYPE]}`);
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

hvigorNode.afterEvaluate(() => {
  hvigorNode.getTaskByName('default@PreBuild').dependsOn('preEnv');
})

function printMap(data: Map<K, V>): void {
  console.log('script: printMap start.');
  console.log(JSON.stringify(Object.fromEntries(data)));
  console.log('script: printMap end.');
}

export { hapTasks } from '@ohos/hvigor-ohos-plugin';
