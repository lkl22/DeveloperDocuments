import { LogUtil } from '@study/common-func/src/main/ets/utils/LogUtil';
import { DecisionTree } from './DecisionTreeCore';
import { AddChildNode } from './TreeNode';
import { TreeNode } from './TreeNode';
import { ActionFunc } from './TreeNode';

const TAG = 'DecisionTreeBuilder';

export class DecisionTreeBuilder<Task, Ctx> {
  private rootNode?: TreeNode<Task, Ctx>;

  // 存储所有的非叶子节点集合
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
  node(task: Task): AddChildNode<Task, Ctx> {
    this.fillTree();
    let node = this.treeMap.get(task);
    if (!node) {
      throw new Error(`[node] ${task} not in tree or is leaf node.`);
    }
    this.curNode = node;
    return node;
  }

  build(): DecisionTree<Task, Ctx> {
    if (!this.rootNode) {
      throw new Error(`[build] DecisionTree no root node.`);
    }
    this.fillTree();
    this.checkNode();
    let nodeUml = this.genNoteUml();
    LogUtil.i(TAG, `nodeUml: ${nodeUml}`);
    return new DecisionTree(this.rootNode, this.treeMap, nodeUml);
  }

  private genNoteUml(): string {
    return `[*] --> ${this.rootNode.task}\n${this.traversalTree(this.rootNode!)}`;
  }


  private traversalTree(node: TreeNode<Task, Ctx>): string {
    if (node.isLeafNode) {
      return '';
    }
    let result = '';
    node.childNode.forEach((value: TreeNode<Task, Ctx>, task: Task) => {
      result += `${node.task} --> ${task}\n${this.traversalTree(value)}`;
    })
    return result;
  }

  /**
   * 补充树节点
   */
  private fillTree() {
    this.curNode?.childNode.forEach((value: TreeNode<Task, Ctx>, key: Task) => {
      if (!value.isLeafNode) {
        this.treeMap.set(key, value);
      }
    });
  }

  private checkNode() {
    let noChildNodes: Task[] = []
    this.treeMap.forEach((value: TreeNode<Task, Ctx>, key: Task) => {
      if (value.childNode.size < 1) {
        noChildNodes.push(key);
      }
    });
    if (noChildNodes.length > 0) {
      let msg = '';
      noChildNodes.forEach((task: Task) => {
        msg += `${task} `;
      });
      throw new Error(`[checkNode] ${msg}no child node.`);
    }
  }
}