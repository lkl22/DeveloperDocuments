import path from 'path';
import { HvigorLogger, LocalFileWriter, parseJsonFile } from '@ohos/hvigor';
import * as FileUtil from '../script/ts/FileUtil';
import * as TimeUtil from '../script/ts/TimeUtil';

const KEY_ENV: string = 'env';
const KEY_BUILD_TYPE: string = 'buildType';
const KEY_FLAVOR_DIMENSIONS: string = 'flavorDimensions';

const DEFAULT_ENV: string = 'product';
const DEFAULT_BUILD_TYPE: string = 'release';

const APP_CONFIG_FILE_NAME: string = 'appConfig.json';

export class PreEvnTask {
  private env: string;
  private buildType: string;
  private flavorDimensions: {};

  constructor(private projectDir: string, private moduleDir: string, private extraConfig: Map<string, string>,
              private logger: HvigorLogger) {
  }

  execute(): void {
    this.parseBuildParams();

    this.changeAppEnvConfig();

    this.generatePropertyConfig();
  }

  // 处理property config
  private generatePropertyConfig(): void {
    this.logger.info('generatePropertyConfig start.');
    let dstFp: string = path.join(this.moduleDir, 'src/main/ets/propertyConfig/PropertyConfig.ets');
    let envConfig = this.getPropertyConfigFileContent(this.env);
    let buildTypeConfig = this.getPropertyConfigFileContent(this.buildType);
    let envBuildTypeConfig = this.getPropertyConfigFileContent(this.getEnvBuildTypeFlavor());
    this.logger.info(`envConfig ${JSON.stringify(envConfig)} buildTypeConfig ${JSON.stringify(buildTypeConfig)} ` +
    `envBuildTypeConfig  ${JSON.stringify(envBuildTypeConfig)}`);
    let envBuildSameKeys = this.getSameKeys(envConfig, buildTypeConfig);
    if (envBuildSameKeys.length > 0) {
      this.logger.errorMessageExit(`generatePropertyConfig env and buildType config has same keys: ${envBuildSameKeys}`);
      return;
    }
    let mergeConfig = { ...envConfig, ...buildTypeConfig };
    let sameKeys = this.getSameKeys(mergeConfig, envBuildTypeConfig);
    mergeConfig = { ...mergeConfig, ...envBuildTypeConfig };
    this.logger.info(`generatePropertyConfig final config: ${JSON.stringify(mergeConfig)} replaceKeys: ${sameKeys}.`);
    this.writeToFile(dstFp, mergeConfig);
    this.logger.info('generatePropertyConfig end.');
  }

  private writeToFile(dstFp: string, mergeConfig: object) {
    let fileContent = 'export class PropertyConfig {\n';
    Object.keys(mergeConfig).forEach(key => {
      fileContent += `  static readonly ${this.getCodeDefine(key, mergeConfig[key])};\n`
    });
    fileContent += `  static readonly BUILD_TIME: string = '${TimeUtil.nowTime()}'\n`;
    fileContent += '}';
    LocalFileWriter.getInstance().writeStr(dstFp, fileContent);
  }

  private getCodeDefine(key: string, value: any) {
    if (typeof value === 'number') {
      return `${key}: number = ${value}`;
    } else if (typeof value === 'boolean') {
      return `${key}: boolean = ${value}`;
    } else {
      return `${key}: string = '${value}'`;
    }
  }

  private getSameKeys(obj1, obj2): string[] {
    let sameKeys = [];
    Object.keys(obj1).forEach(key => {
      if (obj2.hasOwnProperty(key)) {
        sameKeys.push(key);
      }
    });
    return sameKeys;
  }

  private getEnvBuildTypeFlavor() {
    return `${this.env}${this.buildType.slice(0, 1).toUpperCase()}${this.buildType.slice(1)}`;
  }

  private getPropertyConfigFileContent(flavor: string): object {
    try {
      return parseJsonFile(path.join(this.moduleDir, 'src/flavor', flavor, 'propertyConfig.json'));
    } catch (err) {
      this.logger.error(`getPropertyConfigFileContent failed: ${err.message}`);
      return {};
    }
  }

  // AppScope下的rawfile配置，区分环境，根据环境移动文件
  private changeAppEnvConfig(): void {
    let srcDir = path.join(this.projectDir, 'appFlavorConfig', this.env);
    let dstDir = path.join(this.projectDir, 'AppScope');
    FileUtil.copyDirs(srcDir, dstDir);
    this.logger.info(`changeAppEnvConfig copy ${srcDir} to ${dstDir}`);
  }

  // 解析编译构建参数
  private parseBuildParams(): void {
    this.env = this.extraConfig.get(KEY_ENV);
    this.buildType = this.extraConfig.get(KEY_BUILD_TYPE);
    this.logger.info(`preEnv: params from command env ${this.env} buildType ${this.buildType}`);

    let appConfig = parseJsonFile(path.join(this.projectDir, APP_CONFIG_FILE_NAME));
    this.flavorDimensions = appConfig[KEY_FLAVOR_DIMENSIONS];
    if (!this.env || !this.buildType) {
      this.logger.info(`preEnv: appConfig env ${appConfig.appBuild[KEY_ENV]} buildType ${appConfig.appBuild[KEY_BUILD_TYPE]}`);
      this.env = this.env ?? appConfig.appBuild[KEY_ENV];
      this.buildType = this.buildType ?? appConfig.appBuild[KEY_BUILD_TYPE];
      this.logger.info(`preEnv: params from appConfig env ${this.env} buildType ${this.buildType}`);
    }

    this.env = (this.env ?? DEFAULT_ENV).toLowerCase();
    this.buildType = (this.buildType ?? DEFAULT_BUILD_TYPE).toLowerCase();
    if (!this.flavorDimensions[KEY_ENV].includes(this.env)) {
      this.logger.errorMessageExit(`preEnv: cur env error, not in ${JSON.stringify(this.flavorDimensions[KEY_ENV])}`);
      return
    }
    if (!this.flavorDimensions[KEY_BUILD_TYPE].includes(this.buildType)) {
      this.logger.errorMessageExit(`preEnv: cur buildType error, not in ${JSON.stringify(this.flavorDimensions[KEY_BUILD_TYPE])}`);
      return
    }
    this.logger.info(`preEnv: final build params env ${this.env} buildType ${this.buildType}`);
  }
}



