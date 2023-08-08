// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.

import path from 'path';
import { getHvigorNode, hvigor, HvigorLogger } from '@ohos/hvigor';
import { PreEvnTask } from '../script/ts/preEnv';

let logger = HvigorLogger.getLogger('preEnv');
let hvigorNode = getHvigorNode(__filename);
let extraConfig: Map<string, string> = hvigor.getExtraConfig();
printMap(extraConfig);
let moduleDir = hvigorNode.getNodeDir();
logger.info(`moduleName: ${hvigorNode.getName()} moduleDir ${hvigorNode.getNodeDir(moduleDir)}`);

let project = hvigorNode.getProject();
let projectDir = project.getNodeDir();
logger.info(`projectName ${project.getName()} dir: ${projectDir}`);

hvigorNode.task(() => {
  logger.info('preEnv task start.');
  printMap(extraConfig);
  let preEvnTask = new PreEvnTask(projectDir, moduleDir, extraConfig, logger);
  preEvnTask.execute();
  logger.info('preEnv task end.');
}, 'preEnv');

hvigorNode.afterEvaluate(() => {
  hvigorNode.getTaskByName('default@PreBuild').dependsOn('preEnv');
})

function printMap(data: Map<K, V>): void {
  logger.info('printMap start.');
  logger.info(JSON.stringify(Object.fromEntries(data)));
  logger.info('printMap end.');
}

export { hapTasks } from '@ohos/hvigor-ohos-plugin';
