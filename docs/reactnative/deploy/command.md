## app管理

```
Usage: code-push app <command>

Commands:
  add     Add a new app to your account
  remove  Remove an app from your account
  rm      Remove an app from your account
  rename  Rename an existing app
  list    Lists the apps associated with your account
  ls      Lists the apps associated with your account

Options:
  -v, --version  Show version number  [boolean]
```

## 部署指令

```
Usage: code-push deployment <command>

Commands:
  add      Add a new deployment to an app
  clear    Clear the release history associated with a deployment
  remove   Remove a deployment from an app
  rm       Remove a deployment from an app
  rename   Rename an existing deployment
  list     List the deployments associated with an app
  ls       List the deployments associated with an app
  history  Display the release history for a deployment
  h        Display the release history for a deployment

Options:
  -v, --version  Show version number  [boolean]
```

```
1、Usage: code-push deployment ls <appName> [options]

Options:
  --format           Output format to display your deployments with ("json" or "table")  [string] [default: "table"]
  --displayKeys, -k  Specifies whether to display the deployment keys  [boolean] [default: false]
  -v, --version      Show version number  [boolean]

2、Usage: code-push deployment clear <appName> <deploymentName>

3、Usage: code-push deployment h <appName> <deploymentName> [options]

Options:
  --format             Output format to display the release history with ("json" or "table")  [string] [default: "table"]
  --displayAuthor, -a  Specifies whether to display the release author  [boolean] [default: false]
  -v, --version        Show version number  [boolean]
```

## 发布更新

```
Usage: code-push release-react <appName> <platform> [options]

Options:
  --bundleName, -b           Name of the generated JS bundle file. If unspecified, the standard bundle name will be used, depending on the specified platform: "main.jsbundle" (iOS), "index.android.bundle" (Android) or "index.windows.bundle" (Windows)  [string] [default: null]
  --deploymentName, -d       Deployment to release the update to  [string] [default: "Staging"]
  --description, --des       Description of the changes made to the app with this release  [string] [default: null]
  --development, --dev       Specifies whether to generate a dev or release build  [boolean] [default: false]
  --disabled, -x             Specifies whether this release should be immediately downloadable  [boolean] [default: false]
  --entryFile, -e            Path to the app's entry Javascript file. If omitted, "index.<platform>.js" and then "index.js" will be used (if they exist)  [string] [default: null]
  --gradleFile, -g           Path to the gradle file which specifies the binary version you want to target this release at (android only).  [default: null]
  --mandatory, -m            Specifies whether this release should be considered mandatory  [boolean] [default: false]
  --noDuplicateReleaseError  When this flag is set, releasing a package that is identical to the latest release will produce a warning instead of an error  [boolean] [default: false]
  --plistFile, -p            Path to the plist file which specifies the binary version you want to target this release at (iOS only).  [default: null]
  --plistFilePrefix, --pre   Prefix to append to the file name when attempting to find your app's Info.plist file (iOS only).  [default: null]
  --rollout, -r              Percentage of users this release should be immediately available to  [string] [default: "100%"]
  --privateKeyPath, -k       Specifies the location of a RSA private key to sign the release with  [string] [default: false]
  --sourcemapOutput, -s      Path to where the sourcemap for the resulting bundle should be written. If omitted, a sourcemap will not be generated.  [string] [default: null]
  --targetBinaryVersion, -t  Semver expression that specifies the binary app version(s) this release is targeting (e.g. 1.1.0, ~1.2.3). If omitted, the release will target the exact version specified in the "Info.plist" (iOS), "build.gradle" (Android) or "Package.appxmanifest" (Windows) files.  [string] [def
ault: null]
  --outputDir, -o            Path to where the bundle and sourcemap should be written. If omitted, a bundle and sourcemap will not be written.  [string] [default: null]
  --config, -c               Path to the React Native CLI configuration file  [string] [default: null]
  -v, --version              Show version number  [boolean]

Examples:
  release-react MyApp ios                                           Releases the React Native iOS project in the current working directory to the "MyApp" app's "Staging" deployment
  release-react MyApp android -d Production -k ~/.ssh/codepush_rsa  Releases the React Native Android project in the current working directory to the "MyApp" app's "Production" deployment, signed with the "codepush_rsa" private key
  release-react MyApp windows --dev                                 Releases the development bundle of the React Native Windows project in the current working directory to the "MyApp" app's "Staging" deployment
```



