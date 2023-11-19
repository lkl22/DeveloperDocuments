import { LogUtil } from '@study/common-func/src/main/ets/utils/LogUtil';
import { TreeNode } from './TreeNode';

const TAG = 'DecisionTree';

export class DecisionTree<Task, Ctx> {
  private rootNode: TreeNode<Task, Ctx>;

  private treeMap: Map<Task, TreeNode<Task, Ctx>>;

  private hasExecTasks: Task[] = [];

  private nodeUml?: string;

  constructor(rootNode: TreeNode<Task, Ctx>, treeMap: Map<Task, TreeNode<Task, Ctx>>, nodeUml?: string) {
    this.rootNode = rootNode;
    this.treeMap = treeMap;
    this.nodeUml = nodeUml;
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
    this.hasExecTasks.push(node.task);
    if (node.isLeafNode || !nextTask) {
      // Finished
      LogUtil.i(TAG, `[execFlow] All task finished.\n${this.genRunningUml()}`);
      return;
    }
    let nextNode = node.childNode.get(nextTask);
    if (!nextNode) {
      // Finished
      LogUtil.w(TAG, `[execFlow] ${node.task} action exec result maybe error.\n${this.genRunningUml()}`);
      return;
    }
    this.execFlow(nextNode, context);
  }

  private genRunningUml(): string {
    let nodeUml = '';
    this.hasExecTasks.forEach((task: Task)=>{
      nodeUml += `state ${task} #green\n`;
    });
    return `@startuml\nhide empty description\n${nodeUml}${this.nodeUml}@enduml`;
  }
}