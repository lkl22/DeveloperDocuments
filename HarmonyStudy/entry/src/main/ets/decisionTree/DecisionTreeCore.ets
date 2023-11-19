import { LogUtil } from '@study/common-func/src/main/ets/utils/LogUtil';
import { TreeNode } from './TreeNode';

const TAG = 'DecisionTree';

export class DecisionTree<Task, Ctx> {
  rootNode: TreeNode<Task, Ctx>;

  treeMap: Map<Task, TreeNode<Task, Ctx>>;

  constructor(rootNode: TreeNode<Task, Ctx>, treeMap: Map<Task, TreeNode<Task, Ctx>>) {
    this.rootNode = rootNode;
    this.treeMap = treeMap;
  }

  async start(task?: Task, context?: Ctx): Promise<void> {
    let execNode = this.rootNode;
    if (task) {
      let node = this.treeMap.get(task);
      if (!node) {
        throw new Error(`[start] ${task} not in tree.`);
      }
      execNode = node;
    }

    this.execFlow(execNode, context);
  }

  private async execFlow(node?: TreeNode<Task, Ctx>, context?: Ctx): Promise<void> {
    let nextTask = await node.action(context);
    if (node.isLeafNode || !nextTask) {
      // Finished
      LogUtil.i(TAG, '[execFlow] All task finished.');
      return;
    }
    let nextNode = node.childNode.get(nextTask);
    if (!nextNode) {
      // Finished
      LogUtil.i(TAG, '[execFlow] All task finished.');
      return;
    }
    this.execFlow(nextNode, context);
  }
}