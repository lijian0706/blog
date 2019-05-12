## CentOS7下将jar包注册成service
### 准备工作
- `wget`安装: `yum install wget`
- `JDK`安装及配置:
    - 下载`jdk`安装包: `wget http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-i586.rpm?AuthParam=1520234485_3d07d60224bb534eec62b4055d57ac72`
    - 安装`jdk`: `yum localinstall jdk-8u161-linux-i586.rpm`, 安装目录为:`/usr/java/jdk1.8.0_161`
    - `JAVA`环境变量配置:
        - `vi /root/.bash_profile`
        - 新增`export JAVA_HOME=/usr/java/jdk1.8.0_161`
        - 使`.bash_profile`生效: `source .bash_profile`
        
### 注册service
- 上传`jar`包
- 进入`/etc/systemd/system`文件夹，新增`auth-server.service`文件:

```
[Unit]
Description=auth-server
After=syslog.target

[Service]
ExecStart=/usr/bin/java -jar /root/auth-server-201801230812.jar
Restart=always
RestartSec=1

[Install]
WantedBy=multi-user.target
```
- `systemctl enable auth-server.service`
- `systemctl start auth-server`
- `systemctl stop auth-server`, `systemctl status auth-server`





