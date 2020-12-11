## react支持箭头函数

```
npm install –save-dev babel-preset-env 
npm install –save-dev babel-preset-react 
npm install –save-dev babel-preset-stage-0 
npm install –save-dev babel-plugin-transform-class-properties
```

并在webpack.config.js中做以下配置

```
{
  "presets": [
    "react",
    "env",
    "stage-0"
  ],
  "plugins": [
    [
      "transform-class-properties"
    ]
  ]
}
```



