import common from '@ohos.app.ability.common';

export async function getString(context: common.Context, resource: Resource): Promise<string> {
  return context.resourceManager.getStringValue(resource);
}