### 1. `Kettle`的简单介绍
> `Kettle`(现名`Data Integration`)是一款使用`Java`编写的功能强大的`ETL`(`Extract Transform and Load`)工具，支持关系型数据库(`PostgreSQL`、`MySQL`、`Oracle`等)、非关系型数据库(`MongoDB`、`ElasticSearch`等)以及文件之间的大规模数据迁移。


### 2. 常用组件
> `Kettle`提供了极为丰富的组件库，下面列举的是它的一些常用组件,以及对组件的常用参数进行简单介绍，详细的参数说明可参考`Kettle`的帮助文档。

#### 2.1 `Table input`
> 指定数据库表作为输入。

- `Step name`: 步骤名称,`Kettle`的每一个组件即一个步骤，可为该步骤取一个别名
- `Connection`: 指定数据库连接
- `SQL`: 编写`SQL`，从该数据库表中筛选出符合条件的数据

![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2008.47.47.png)

#### 2.2 `Table output`
> 指定数据库表作为输出

- `Step name`: 步骤名称
- `Connection`: 指定数据库连接
- `Target schema`: 输出的数据库表模式
- `Target table`: 指定输出的数据库表
- `Use batch update for inserts`: 是否使用批处理进行插入
- `Database fields`: 配置字段映射关系
    - `Table field`: 输出的数据库表字段
    - `Stream field`: 流字段(流入该组件的数据字段)
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2009.28.49.png)

#### 2.3 `Sort rows`
> 按照某字段进行排序

- `Step name`: 步骤名称
- `Fields`:
    - `Fieldname`: 排序的字段名
    - `Ascending`: 排序方式
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.35.58.png)

#### 2.4 `Merge join`
> 将不同来源数据进行融合，类似于`SQL`中的`join`

- `Step name`: 步骤名称
- `First Step`: 需要融合的一组数据
- `Second Step`: 需要融合的另一组数据
- `Join Type`: 融合的类型
- `Keys for 1st step`: `First Step`中进行融合的字段
- `Keys for 2nd step`: `Second Step`中进行融合的字段
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.36.21.png)

#### 2.5 `Add sequence`
> 读取指定的序列值

- `Step name`: 步骤名称
- `Name of value`: 序列值别名
- `Use DB to get sequence`: 是否使用数据库序列
- `Connnection`: 数据库连接
- `Schema name`: 数据库模式名称
- `Sequence name`: 序列名
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.37.13.png)

#### 2.6 `Modified Java Script Value`
> 支持编写`JavaScript`脚本，用于实现必要的业务逻辑

- `Step name`: 步骤名称
- `Java script functions`: 提供了一些`JavaScript`函数
- `Java script`: 脚本编辑窗口
- `Fields`: 可将脚本中的定义的变量映射出去
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2016.37.41.png)

### 3. 在实际场景中的应用
> 在软件开发中，经常会遇到这样的场景: 新开发的系统即将替换老系统，而老系统庞大的数据需迁移到新系统中，但数据结构与新系统不完全兼容，下面通过一个简单的例子来介绍`Kettle`是如何处理这些老数据，完成数据迁移任务的。
#### 3.1 老数据结构
- `company`公司表: 
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.38.14.png)
- `district`区域表:
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.39.23.png)
> 该表存储了省市区，通过parent_id进行关联

- `company_district`公司区域表:
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.39.38.png)
- `employee`员工表:
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.39.51.png)
- `employee_company`员工公司表:
![](https://code.aliyun.com/lijian001/blog/raw/master/kettle/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-02-24%2010.40.03.png)
