import { LogUtil } from '@study/common-func/src/main/ets/utils/LogUtil';
import { LayoutConst } from '@study/common-ui/src/main/ets/const/LayoutConst';
import { DecisionTreeBuilder } from '../../decisionTree/DecisionTreeBuilder';
import { DecisionTree } from '../../decisionTree/DecisionTreeCore';

export enum Tasks {
  A = 'A',
  B = 'B',
  C = 'C',
  D = 'D',
  E = 'E',
  FAILED = 'FAILED',
}

class TreeContext {
  data?: string;
}

const TASK_MAP: Map<number, Tasks> = new Map([[0, Tasks.A], [1, Tasks.B], [2, Tasks.C], [3, Tasks.D]]);

const TAG = 'DecisionTreePage';

@Entry
@Component
export struct DecisionTreePage {
  private tree?: DecisionTree<Tasks, TreeContext>;

  build(): void {
    Column({ space: 16 }) {
      Button('build').onClick(() => {
        this.buildTree();
      })
      Button('root start').onClick(() => {
        this.tree?.start();
      })
      Button('random task start').onClick(() => {
        this.tree?.start(TASK_MAP.get(Math.floor(Math.random() * 4)));
      })
      Button('no root node').onClick(() => {
        this.buildNoRootTree();
      })
      Button('leaf node add node').onClick(() => {
        this.buildLeafAddNode();
      })
      Button('add node to non node').onClick(() => {
        this.buildAddNodeToNonNode();
      })
      Button('node no child').onClick(() => {
        this.buildNodeNoChild();
      })
    }
    .alignItems(HorizontalAlign.Center)
    .width(LayoutConst.MATCH_PARENT)
    .margin(16)
  }

  private buildTree() {
    let builder = new DecisionTreeBuilder<Tasks, TreeContext>();
    builder.root(Tasks.A, async () => {
      LogUtil.i(TAG, 'A action');
      return Math.random() > 0.5 ? Tasks.B : Tasks.FAILED;
    }).nonLeaf(Tasks.B, (ctx?: TreeContext) => {
      LogUtil.i(TAG, 'B action');
      return Math.random() > 0.5 ? Tasks.C : Tasks.FAILED;
    }).leaf(Tasks.FAILED, async (ctx?: TreeContext) => {
      LogUtil.i(TAG, 'A FAILED action');
    });
    builder.node(Tasks.B)
      .nonLeaf(Tasks.C, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'C action');
        return Math.random() > 0.5 ? Tasks.D : Tasks.FAILED;
      })
      .leaf(Tasks.FAILED, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'B FAILED action');
      })
    builder.node(Tasks.C)
      .nonLeaf(Tasks.D, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'D action');
        return Math.random() > 0.5 ? Tasks.E : Tasks.FAILED;
      })
      .leaf(Tasks.FAILED, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'C FAILED action');
      })
    builder.node(Tasks.D)
      .leaf(Tasks.E, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'E action');
      })
      .leaf(Tasks.FAILED, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'D FAILED action');
      })
    this.tree = builder.build();
  }

  private buildNoRootTree() {
    try {
      let builder = new DecisionTreeBuilder<Tasks, TreeContext>();
      let tree = builder.build();
    } catch (err) {
      LogUtil.e(TAG, `[buildNoRootTree] err ${err}.`);
    }
  }

  private buildLeafAddNode() {
    try {
      let builder = new DecisionTreeBuilder<Tasks, TreeContext>();
      builder.root(Tasks.A, () => {
        LogUtil.i(TAG, 'A action');
        return Math.random() > 0.5 ? Tasks.B : Tasks.FAILED;
      }).leaf(Tasks.FAILED, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'A FAILED action');
      });
      builder.node(Tasks.FAILED)
        .leaf(Tasks.FAILED, (ctx?: TreeContext) => {
          LogUtil.i(TAG, 'FAILED action');
        })
      this.tree = builder.build();
    } catch (err) {
      LogUtil.e(TAG, `[buildLeafAddNode] err ${err}.`);
    }
  }

  private buildAddNodeToNonNode() {
    try {
      let builder = new DecisionTreeBuilder<Tasks, TreeContext>();
      builder.root(Tasks.A, () => {
        LogUtil.i(TAG, 'A action');
        return Math.random() > 0.5 ? Tasks.B : Tasks.FAILED;
      }).leaf(Tasks.FAILED, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'A FAILED action');
      });
      builder.node(Tasks.B)
        .leaf(Tasks.FAILED, (ctx?: TreeContext) => {
          LogUtil.i(TAG, 'B FAILED action');
        })
      this.tree = builder.build();
    } catch (err) {
      LogUtil.e(TAG, `[buildAddNodeToNonNode] err ${err}.`);
    }
  }

  private buildNodeNoChild() {
    try {
      let builder = new DecisionTreeBuilder<Tasks, TreeContext>();
      builder.root(Tasks.A, () => {
        LogUtil.i(TAG, 'A action');
        return Math.random() > 0.5 ? Tasks.B : Tasks.FAILED;
      }).nonLeaf(Tasks.B, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'B action');
        return Math.random() > 0.5 ? Tasks.C : Tasks.FAILED;
      });
      this.tree = builder.build();
    } catch (err) {
      LogUtil.e(TAG, `[buildNodeNoChild] err ${err}.`);
    }
  }
}