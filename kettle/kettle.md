# Kettle
## 1. `Kettle`的简单介绍
> `Kettle`(现名`Data Integration`)是一款使用`Java`编写的功能强大的`ETL`(`Extract Transform and Load`)工具，支持关系型数据库(`PostgreSQL`、`MySQL`、`Oracle`等)、非关系型数据库(`MongoDB`、`ElasticSearch`等)以及文件之间的大规模数据迁移。


## 2. 常用组件
> `Kettle`提供了极为丰富的组件库，下面列举的是它的一些常用组件,以及对组件的常用参数进行简单介绍，详细的参数说明可参考`Kettle`的帮助文档。

### 2.1 `Table input`
> 指定数据库表作为输入。

- `Step name`: 步骤名称,`Kettle`的每一个组件即一个步骤，可为该步骤取一个别名
- `Connection`: 指定数据库连接
- `SQL`: 编写`SQL`，从该数据库表中筛选出符合条件的数据

![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2008.47.47.png)

### 2.2 `Table output`
> 指定数据库表作为输出

- `Step name`: 步骤名称
- `Connection`: 指定数据库连接
- `Target schema`: 输出的数据库表模式
- `Target table`: 指定输出的数据库表
- `Use batch update for inserts`: 是否使用批处理进行插入
- `Database fields`: 配置字段映射关系
    - `Table field`: 输出的数据库表字段
    - `Stream field`: 流字段(流入该组件的数据字段)
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2009.28.49.png)

### 2.3 `Sort rows`
> 按照某字段进行排序

- `Step name`: 步骤名称
- `Fields`:
    - `Fieldname`: 排序的字段名
    - `Ascending`: 排序方式
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.35.58.png)

### 2.4 `Merge join`
> 将不同来源数据进行融合，类似于`SQL`中的`join`，注意: 该组件接收的数据必须按照`join`字段按照相同规则进行排序，否则`join`后的数据会有丢失。

- `Step name`: 步骤名称
- `First Step`: 需要融合的一组数据
- `Second Step`: 需要融合的另一组数据
- `Join Type`: 融合的类型
- `Keys for 1st step`: `First Step`中进行融合的字段
- `Keys for 2nd step`: `Second Step`中进行融合的字段
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.36.21.png)

### 2.5 `Add sequence`
> 读取指定的序列值

- `Step name`: 步骤名称
- `Name of value`: 序列值别名
- `Use DB to get sequence`: 是否使用数据库序列
- `Connnection`: 数据库连接
- `Schema name`: 数据库模式名称
- `Sequence name`: 序列名
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.37.13.png)

### 2.6 `Modified Java Script Value`
> 支持编写`JavaScript`脚本，用于实现必要的业务逻辑

- `Step name`: 步骤名称
- `Java script functions`: 提供了一些`JavaScript`函数
- `Java script`: 脚本编辑窗口
- `Fields`: 可将脚本中的定义的变量映射出去
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.37.41.png)

## 3. 在实际场景中的应用
> 在软件开发中，经常会遇到这样的场景: 新开发的系统即将替换老系统，而老系统庞大的数据需迁移到新系统中，但数据结构与新系统不完全兼容，下面通过一个简单的例子来介绍`Kettle`是如何处理这些老数据，完成数据迁移任务的。

### 3.1 老数据结构
- `company`公司表: 
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.38.14.png)
- `district`区域表:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.39.23.png)
> 该表存储了省市区，通过parent_id进行关联

- `company_district`公司区域表:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.39.38.png)
- `employee`员工表:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.39.51.png)
- `employee_company`员工公司表:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.40.03.png)

### 3.2 新数据结构
- `company`公司表:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.49.41.png)
> 对比老数据`company`表，新的`company`表中新增了`district`、`city`、`province`字段，他们可以从老数据`company_district`表和`district`表中取得；`contact`字段对应`tel`字段；`addr`对应`address`。

- `employee`员工表:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.50.25.png)
> 对比老数据`employee`表，新的`employee`表中新增`company_id`字段且有外键约束;`sex`字段由原来的1、2变更为男、女

### 3.3 数据迁移
> 由于`employee`有外键关联`company`，因此先迁移`company`表数据，新的`company`表需新增`old_id`字段来保存老的`company`表的`id`，用于员工关联公司。

#### 3.3.1 `company`表
> 数据迁移前的分析：
> 
> 1. `company`表数据来源于三张表：`company`、`company_district`、`district`，因此需要三个`Table input`组件。
> 2. `company`和`company_district`需进行`join`，`join`的结果还需和`district`进行`join`，因此需要两个`Merge Join`组件。
> 3. 使用`Merge join`组件之前需进行排序，因此需要三个`Sort rows`组件
> 4. 新的`company`表的id来源于自增长序列，因此需要一个`Add sequence`组件。
> 5. 最后将结果导入新的`company`表，因此需要一个`Table output`组件。

- 打开`Kettle`，点击`File`->`new`->`Transformation`,新建一个转换流程
- 点击左侧`Design``Tab`页,将`Table input`组件拖拽至右侧转换流程窗口，在组件上右键点击`edit`,弹出该组件的编辑窗口，设置步骤名称、数据库连接和`SQL`语句，如下图所示:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2012.02.23.png)

![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2012.03.00.png)

![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2014.48.52.png)

- 将`company`和`company_district`数据进行`left join`，`join`之前需按照`join`字段排序，将`Sort rows`组件拖拽至右侧转换流程窗口，并进行编辑，如下图所示:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2012.03.21.png)
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.41.52.png)

- 将`Merge Join`组件拖拽至右侧，并进行编辑，如下图所示:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2012.03.53.png)

- 将`company`和`company_district``Merge Join`的结果和`district`数据分别进行排序，同上面步骤
- 将两者进行`join`，同上面步骤
- 添加`Add sequence`组件，并进行编辑，如下图所示:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2014.45.27.png)

- 添加`Table output`组件，并进行编辑，如下图所示:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2014.45.56.png)

- 整体流程如下图所示:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2011.49.07.png)

- 点击启动按钮执行整个流程，直至所有步骤右上角出现绿色的箭头，`company`表便完成了迁移。

#### 3.3.2 `employee`表
> 数据迁移前的分析:
> 
> 1. `employee`表数据来源三张表: 老的`employee`、老的`employee_company`和新的`company`，因此需要三个`Table input`组件
> 2. 老的`employee`和`employee_company`需进行`join`，`join`的结果还需和新的`company`进行`join`，因此需要两个`Merge join`组件和三个`Sort rows`组件。
> 3. 新的`employee`表的id来源于自增长序列，因此需要一个`Add sequence`组件。
> 4. 新的`employee`表的`sex`字段存储的是'男/女'，而不是'1/2'，因此需要一个`Modified Java Script Value`组件进行简单处理。
> 5. 最后将结果导入新的`employee`表，因此需要一个`Table output`组件。

- 与`company`的数据迁移类似，添加三个`Table input`组件，并进行编辑
- 分别将`employee`和`employee_company`按照`join`字段进行统一排序
- 将排序的结果进行`join`
- 分别将新的`company`和`join`之后的结果按照`join`字段进行统一排序
- 将排序的结果进行`join`
- 编写脚本，转换`sex`字段
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.48.21.png)
- 读取新的`employee`序列值
- 输出到新的`employee`表中
- 整体流程如下图所示:
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.46.38.png)

- 点击启动按钮执行整个流程，直至所有步骤右上角出现绿色的箭头，`employee`表便完成了迁移。

### 3.4 结果
- `company`表
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.53.56.png)

- `employee`表
![](https://raw.githubusercontent.com/a479159321/blog/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.54.03.png)

> 至此，便完成了老数据的迁移。

## 4. 遇到的问题
> 在`Kettle`使用过程中会发现，当需要进行迁移的数据量较为庞大时(千万级)，常常会出现`内存溢出`的问题，解决方法是将`Kettle`内存调高些: 打开`spoon.sh`文件，找到`PENTAHO_DI_JAVA_OPTIONS="-Xms1024m -Xmx2048m -XX:MaxPermSize=256m"`，将其修改为`PENTAHO_DI_JAVA_OPTIONS="-Xms16384m -Xmx32768m -XX:MaxPermSize=16384m"`，重启即可。


-------
源码地址: http://www.wisely.top/2018/02/26/etl-kettle/

