import { DecisionTree } from './DecisionTreeCore';
import { AddChildNode } from './TreeNode';
import { TreeNode } from './TreeNode';
import { ActionFunc } from './TreeNode';

export class DecisionTreeBuilder<Task, Ctx> {
  private rootNode?: TreeNode<Task, Ctx>;

  private treeMap: Map<Task, TreeNode<Task, Ctx>> = new Map<Task, TreeNode<Task, Ctx>>();

  private curNode?: TreeNode<Task, Ctx>;

  constructor() {
  }

  /**
   * 添加根节点
   *
   * @param task 节点task
   * @param action 节点action，处理函数
   */
  root(task: Task, action: ActionFunc<Task, Ctx>): AddChildNode<Task, Ctx> {
    this.rootNode = new TreeNode(task, action);
    this.treeMap.set(task, this.rootNode);
    this.curNode = this.rootNode;
    return this.rootNode;
  }

  /**
   * 找到对应的子节点，以便向节点添加子节点
   *
   * @param task 节点task
   */
  node(task: Task) {
    this.fillTree();
    let node = this.treeMap.get(task);
    if (!node) {
      throw new Error(`[node] ${task} not in tree.`);
    }
    this.curNode = node;
    return node;
  }

  /**
   * 补充树节点
   */
  private fillTree() {
    this.curNode?.childNode.forEach((value: TreeNode<Task, Ctx>, key: Task) => {
      this.treeMap.set(key, value);
    });
  }

  build(): DecisionTree<Task, Ctx> {
    if (!this.rootNode) {
      throw new Error(`[build] DecisionTree no root node.`);
    }
    this.fillTree();
    return new DecisionTree(this.rootNode, this.treeMap);
  }
}