// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.

import path from 'path';
import { hvigor, getHvigorNode } from '@ohos/hvigor';

let hvigorNode = getHvigorNode(__filename);
let extraConfig: Map<string, string> = hvigor.getExtraConfig();
printMap(extraConfig);
console.log(`script: path ${__filename} ${typeof hvigorNode} ${extraConfig.size}`);
hvigorNode.task(() => {
  console.log('This is a clean1 task');
}, 'clean1');

function printMap(data: Map<K, V>): void {
  console.log('script: printMap start.');
  console.log(JSON.stringify(Object.fromEntries(data)));
  console.log('script: printMap end.');
}

export { hapTasks } from '@ohos/hvigor-ohos-plugin';
