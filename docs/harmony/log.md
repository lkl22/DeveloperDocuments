# 解除日志限流命令:
```shell
hdc shell param set hilog.flowctrl.proc.on false
hdc shell hilog -Q pidoff
hdc shell hilog -p off
hdc shell hilog -b D
```

