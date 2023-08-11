import path from 'path';
import fs from 'fs';
import { HvigorLogger, LocalFileWriter, parseJsonFile } from '@ohos/hvigor';
import * as FileUtil from './FileUtil';
import * as TimeUtil from './TimeUtil';

const KEY_ENV: string = 'env';
const KEY_BUILD_TYPE: string = 'buildType';
const KEY_FLAVOR_DIMENSIONS: string = 'flavorDimensions';

const DEFAULT_ENV: string = 'product';
const DEFAULT_BUILD_TYPE: string = 'release';

const APP_CONFIG_FILE_NAME: string = 'appConfig.json';

export class PreEvnTask {
  private env: string;
  private buildType: string;
  private flavorDimensions = {
    env: [
      "product",
      "mirror",
      "develop"
    ],
    buildType: [
      "release",
      "debug"
    ]
  };

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
    mergeConfig = {
      ...mergeConfig,
      "ENV": this.env,
      "BUILD_TYPE": this.buildType,
      "BUILD_TIME": `${TimeUtil.nowTime()}`
    }
    this.writeToFile(dstFp, mergeConfig);
    this.logger.info('generatePropertyConfig end.');
  }

  private writeToFile(dstFp: string, mergeConfig: object) {
    let fileContent = 'export class PropertyConfig {\n';
    Object.keys(mergeConfig).forEach(key => {
      fileContent += `  static readonly ${this.getCodeDefine(key, mergeConfig[key])};\n`
    });
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
      this.logger.warn(`getPropertyConfigFileContent failed: ${err.message}`);
      return {};
    }
  }

  // AppScope下的rawfile配置，区分环境，根据环境移动文件
  private changeAppEnvConfig(): void {
    let srcDir = path.join(this.projectDir, 'appFlavorConfig', this.env);
    let dstDir = path.join(this.projectDir, 'AppScope');
    FileUtil.mkDirsSync(dstDir);
    FileUtil.copyFolderSync(srcDir, dstDir);
    this.logger.info(`changeAppEnvConfig copy ${srcDir} to ${dstDir}`);
  }

  // 解析编译构建参数
  private parseBuildParams(): void {
    this.env = this.extraConfig.get(KEY_ENV);
    this.buildType = this.extraConfig.get(KEY_BUILD_TYPE);
    this.logger.info(`preEnv: params from command env ${this.env} buildType ${this.buildType}`);

    let appConfigFp = path.join(this.projectDir, APP_CONFIG_FILE_NAME);
    let existsAppConfig = fs.existsSync(appConfigFp);
    if (existsAppConfig) {
      let appConfig = parseJsonFile();
      if (!this.env || !this.buildType) {
        this.logger.info(`preEnv: appConfig env ${appConfig.appBuild[KEY_ENV]} buildType ${appConfig.appBuild[KEY_BUILD_TYPE]}`);
        this.env = this.env ?? appConfig.appBuild[KEY_ENV];
        this.buildType = this.buildType ?? appConfig.appBuild[KEY_BUILD_TYPE];
        this.logger.info(`preEnv: params from appConfig env ${this.env} buildType ${this.buildType}`);
      }
    }
    this.env = (this.env ?? DEFAULT_ENV).toLowerCase();
    this.buildType = (this.buildType ?? DEFAULT_BUILD_TYPE).toLowerCase();
    this.logger.info(`preEnv: final build params env ${this.env} buildType ${this.buildType}`);
    if (!this.flavorDimensions[KEY_ENV].includes(this.env)) {
      this.logger.errorMessageExit(`preEnv: cur env error, not in ${JSON.stringify(this.flavorDimensions[KEY_ENV])}`);
      return
    }
    if (!this.flavorDimensions[KEY_BUILD_TYPE].includes(this.buildType)) {
      this.logger.errorMessageExit(`preEnv: cur buildType error, not in ${JSON.stringify(this.flavorDimensions[KEY_BUILD_TYPE])}`);
      return
    }
    if (!existsAppConfig) {
      this.logger.info(`preEnv: start write config`);
      let appConfig = {
        appBuild: {
          buildType: this.buildType,
          env: this.env
        },
        flavorDimensions: this.flavorDimensions
      };
      this.logger.info(`preEnv: write config ${JSON.stringify(appConfig)}`);
      LocalFileWriter.getInstance().write(appConfigFp, appConfig);
    }
    this.logger.info(`preEnv: parseBuildParams finish env ${this.env} buildType ${this.buildType}`);
  }
}



