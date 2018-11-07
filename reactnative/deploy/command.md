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



