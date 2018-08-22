官网：[https://www.sonatype.com/](https://www.sonatype.com/)

---

### Install

[https://help.sonatype.com/repomanager3/installation](https://help.sonatype.com/repomanager3/installation)

Download:[https://help.sonatype.com/repomanager3/download/download-archives---repository-manager-3](https://help.sonatype.com/repomanager3/download/download-archives---repository-manager-3)

```markdown
tar -xvzf nexus-3.13.0-01-unix.tar.gz
vim ./nexus-3.13.0-01-unix/etc/nexus-default.properties
#修改port
    application-port=8081 //默认8081
#启动
./nexus-3.13.0-01-unix/bin/nexus run
```

---

### Issue

[System Requirement: max file descriptors \[4096\] likely too low, increase to at least \[65536\].](https://help.sonatype.com/repomanager3/system-requirements#filehandles)

```
vim /etc/security/limits.conf
    #add the following line
    nexus - nofile 65536
```

This change will only take effect the next time the **nexus **process user opens a new session. Which essentially means that you will need to restart NXRM.

