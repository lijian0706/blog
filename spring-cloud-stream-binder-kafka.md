spring cloud stream 3.x较之前版本有很大的不同，废除了`@Input`、`@Output`、`@EnableBinding`、`@StreamListener`等注解，下面以kafka作为示例进行简单的使用说明。
### 引入gradle依赖
```
ext {
	set('springCloudVersion', "2020.0.0")
}

dependencies {
    implementation 'org.springframework.cloud:spring-cloud-stream-binder-kafka'
}

dependencyManagement {
	imports {
		mavenBom "org.springframework.cloud:spring-cloud-dependencies:${springCloudVersion}"
	}
}

```

### 配置文件
```
spring.cloud.stream.kafka.binder.brokers: ip:port
spring.cloud.stream.bindings.supplier-out-0.destination: topic名称 # 生产者topic配置
spring.cloud.stream.bindings.receiver-in-0.destination: topic名称 # 消费者topic配置，bindingName命名规范：bean名称-in-索引，索引值为参数个数
spring.cloud.stream.bindings.receiver-in-0.group: etcGroup # 消费者group配置
```

### 生产者和消费者代码示例
```

public interface KafkaBindingNames {
    String SUPPLIER = "supplier-out-0";
}


@RestController
@RequestMapping
@Configuration
@Slf4j
public class StreamTestController {

    private final StreamBridge streamBridge;

    public StreamTestController(StreamBridge streamBridge) {
        this.streamBridge = streamBridge;
    }

    @GetMapping("/streamTest")
    public void streamTest(){
        streamBridge.send(KafkaBindingNames.SUPPLIER, new User("张三", 30)); // 向kafka发送消息
    }

    @Setter
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class User{
        private String name;
        private Integer age;
    }

    // 消费者，bean名称必须与配置文件中的bindingName一致
    @Bean
    public Consumer<User> receiver() {
        return msg -> log.info("receive msg:{}", msg);
    }
}
```
