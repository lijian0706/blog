spring redis使用zadd时，发现不支持xx、nx等指令，于是使用lua脚本进行了实现
```
    public void zaddWithXX(String key, Object value, double score){
        String script = "tonumber(ARGV[2]) redis.call('zadd',KEYS[1],'xx',ARGV[2],ARGV[1])";
        DefaultRedisScript<Object> redisScript = new DefaultRedisScript<Object>();
        redisScript.setScriptText(script);
        redisScript.setResultType(Object.class);
        redisTemplate.execute(redisScript, Collections.singletonList(key), value, new BigDecimal(score));
    }
```
