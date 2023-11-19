import { LogUtil } from '@study/common-func/src/main/ets/utils/LogUtil';
import { DecisionTreeBuilder } from '../../decisionTree/DecisionTreeBuilder';
import { DecisionTree } from '../../decisionTree/DecisionTreeCore';

enum Tasks {
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
      Button('start').onClick(() => {
        this.tree.start();
      })
    }
  }

  private buildTree() {
    let builder = new DecisionTreeBuilder<Tasks, TreeContext>();
    builder.root(Tasks.A, () => {
      LogUtil.i(TAG, 'A action');
      return Tasks.B;
    }).nonLeaf(Tasks.B, (ctx?: TreeContext) => {
      LogUtil.i(TAG, 'B action');
      return Tasks.C;
    }).leaf(Tasks.FAILED, (ctx?: TreeContext) => {
      LogUtil.i(TAG, 'A FAILED action');
    });
    builder.node(Tasks.B)
      .leaf(Tasks.FAILED, (ctx?: TreeContext) => {
        LogUtil.i(TAG, 'B FAILED action');
      })
    this.tree = builder.build();
  }
}