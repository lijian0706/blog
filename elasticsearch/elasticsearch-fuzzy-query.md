# ElasticSearch相似度查询
ElasticSearch的相似度查询主要使用`Fuzzy Query`来实现，下面按照`Person`的`phoneNum`进行相似度查询进行举例说明。
## 1.前期准备工作
- `Entity`:

```
public class Person {
    private String phoneNum;
    private String name;
    private String gender;
    private Integer age;
}
```
- `Repository`:

```
public interface PersonRepository extends ElasticsearchRepository<Person, Long> {

}
```
## 2.构造`Fuzzy Query`查询条件

```
QueryBuilder queryCondition = QueryBuilders.fuzzyQuery("phoneNum", fuzzyPhoneNum).fuzziness(Fuzziness.AUTO);
personRepository.search(queryCondition);
```
说明:
- `QueryBuilders.fuzzyQuery('字段名', 字段值)`
- `fuzziness()`方法以`编辑距离`为入参，取值有四种：0，1，2，'AUTO'

源码地址：https://github.com/a479159321/elasticsearch-fuzzy-query

