### 1.安装
#### 1.1 安装docker并加速
- `yum update && yum install docker`
- `sudo mkdir -p /etc/docker`
- `sudo tee /etc/docker/daemon.json <<-'EOF'
  {
  "registry-mirrors": ["https://y7u9p3i0.mirror.aliyuncs.com"]
  }
  EOF`
- `sudo systemctl daemon-reload`
- `sudo systemctl restart docker`
  
#### 1.2 安装docker-compose

- `yum install epel-release && yum install python-pip && pip install docker-compose`

#### 1.3 安装nexus

- 准备nexus文件夹: `mkdir -p /opt/docker/nexus-data && chown -R 200 /opt/docker/nexus-data`

- 新建描述文件`docker-compose.yml`,并编辑内容:

```yml
version: '2'
services:
  feitian-nexus: 
    image: sonatype/nexus3
    volumes:
    - /opt/docker/nexus-data:/nexus-data
    ports:
    - "10000:8081"
```

- 安装: `docker-compose up -d`

### 2.打包
#### 2.1 将项目发布到`Nexus`仓库中
- 修改`Maven`安装目录下的`settings.xml`，添加`Nexus`仓库的用户名、密码

```xml
<server>
  <id>hfcb</id>
  <username>admin</username>
  <password>admin123</password>
</server>
```

- 在项目`pom.xml`文件中指定仓库地址:

```xml
<distributionManagement>
    <snapshotRepository>
        <id>hfcb</id>
        <url>http://192.168.1.223:10000/repository/hfcb/</url>
    </snapshotRepository>
</distributionManagement>
```
- 进入项目根目录下执行`mvn deploy`即可将项目发布到`Nexus`

#### 2.2 本地jar包发布到nexus:
- 在jar包目录下执行如下命令:
```
mvn deploy:deploy-file -DgroupId=com.alipay -DartifactId=alipay-trade-sdk -Dversion=1.0.0.RELEASE -Dpackaging=jar -Dfile=alipay-trade-sdk-20161215.jar -Durl=http://192.168.1.223:10000/artifactory/libs-release-local -DrepositoryId=hfcb
```

### 3.使用私服库
- 在项目`pom.xml`文件中指定仓库地址:

```xml
<repositories>
    <repository>
        <id>hfcb</id>
        <url>http://192.168.1.223:10000/repository/hfcb/</url>
    </repository>
</repositories>
```