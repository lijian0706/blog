> Spring Security是一个强大的、支持深度定制的安全控制框架，他为Java应用提供了认证(Authentication)和授权(Authorization)功能，使得开发者更加关注于业务本身，而无需花大力气操心整个应用的安全和权限控制问题。下面将会介绍Spring Security的简单集成与使用。
本次快速入门分成两个部分：自定义`UserDetailsService`和自定义`AuthenticationProvider`，这两个部分分别对应了集成`Spring Security`的两种方法、两种灵活性。对于一般开发者来说，使用自定义`UserDetailsService`方式已足够日常使用。

## 一、集成前的准备工作
#### 环境
本次示例使用`Spring Boot 2.1.4.RELEASE`+`PostgreSQL 9.6`，开发工具为`Intellij IDEA 2019.1`
#### 权限控制的设计
本次示例使用了常用的权限控制设计，即用户(`SysUser`)-角色(`Role`)-权限(`Authority`)，他们之间的对应关系是：用户-角色多对多，角色-权限多对多，关于实体类的设计请参考源代码，此处不再赘述。
#### 新建`Spring Boot`工程
- 浏览器访问`https://start.spring.io/`
- 设置`Group`、`Artifact`，添加`Web`、`JPA`、`PostgreSQL`、`Security`、`Lombok`依赖，点击`Generate Project`下载工程
- 使用`IDEA`工具打开工程

## 二、自定义`UserDetailsService`
> `UserDetailsService`接口中只有一个方法`loadUserByUsername`，他定义了按照用户名(`username`)获取用户(`SysUser`)的方式，由于真实场景中，系统的用户可能存放在数据库、缓存、内存、甚至文件系统中，`Spring Security`将获取用户这个步骤开放给开发者，他不管用户存放在哪里，只需要开发者查询到用户后返回给`Spring Security`即可，本次示例模拟用户存放在数据库的场景。

#### 用户、角色、权限数据的准备
开始前需提前准备好用户、角色、权限数据，为方便起见，本次示例中定义了一个创建admin用户的接口，只需调用接口即可初始化admin用户。

#### 自定义`UserDetailsService`
- 新建`JpaUserDetailsService`，实现`UserDetailsService`
- 覆盖`loadUserByUsername()`
```
@Override
public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    return sysUserRepository.findByUsername(username);
}
```

#### `SecurityConfiguration`配置类
- 新建`SecurityConfiguration`，继承`WebSecurityConfigurerAdapter`，添加`@EnableGlobalMethodSecurity(prePostEnabled = true)`开启全局方法安全。
- 本次示例密码使用`BCrypt`加密存储
```
@Bean
public PasswordEncoder passwordEncoder(){
    return new BCryptPasswordEncoder();
}
```
- 将`JpaUserDetailsService`申明成Bean
```
@Bean
@Override
protected UserDetailsService userDetailsService() {
    return new JpaUserDetailsService();
}
```
- 实现`configure(WebSecurity web)`

```
@Override
public void configure(WebSecurity web) throws Exception {
    web.ignoring()
            .antMatchers("/login.html")
            .antMatchers("/webjars/**"); // 忽略静态资源，即无需登录即可访问
}

@Override
protected void configure(HttpSecurity http) throws Exception {
    http
            .authorizeRequests()
                .antMatchers("/login/**").permitAll()
                .antMatchers(HttpMethod.POST, "/users/admin").permitAll()
                .antMatchers("/**").authenticated()
            .and()
            .formLogin()
                .loginPage("/login.html") // 自定义登录页面
                .loginProcessingUrl("/login") // 登录表单提交的地址
            .and()
            .logout()
                .logoutUrl("/logout") // 注销地址，默认即为"/logout"
                .logoutSuccessUrl("/login.html") // 注销成功后的跳转地址
            .and()
            .csrf().disable();

}

@Override
protected void configure(AuthenticationManagerBuilder auth) throws Exception {
    auth.userDetailsService(userDetailsService());
}
```
- 新建登录页和首页，详见源码
- 启动服务，访问`http://localhost:9999`，会自动重定向到登录页，输入用户名admin，密码admin点击登录，自动跳转到首页表示登录成功，我们在接口中添加`@PreAuthorize("hasAuthority('QUERY_USER_INFO')")`，访问该接口的用户必须具有`QUERY_USER_INFO`权限，否则会返回`403`错误，至此便完成了`Authenticatioin`和`Authority`。

## 三、自定义`AuthenticationProvider`
> 自定义`AuthenticationProvider`可实现自定义认证的功能，具有极大的灵活性。

- 新建`CustomerAuthenticationProvider`实现`AuthenticationProvider`，`AuthenticationProvider`接口有两个方法：`authenticate()`和`supports()`
    - `authenticate()`: 认证过程的实现
    - `supports()`：该`AuthenticationProvider`是否支持用户提交的登录凭证，若支持，则进行认证，自动调用`authenticate()`，否则，交由其他provider进行认证。

```
@Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        if(authentication.getName().equals("admin")){ // 只需要username是admin即通过认证，此处可替换成真实场景的认证规则
            return buildValidAuthentication(authentication); // 重新构造已认证过的凭证
        }
        throw new BadCredentialsException("用户名密码错误");
    }

    private UsernamePasswordAuthenticationToken buildValidAuthentication(Authentication authentication){
        SysUser sysUser = sysUserRepository.findByUsername(authentication.getName());
        UsernamePasswordAuthenticationToken validAuthentication = new UsernamePasswordAuthenticationToken(sysUser.getUsername(), sysUser.getPassword(), sysUser.getAuthorities());
        validAuthentication.setDetails(authentication.getDetails());
        return validAuthentication;
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return (UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication)); // 判断用户提交的凭证类型provider是否支持，若支持则会调用authenticate()，否则交由支持此类型凭证的其他provider进行认证
    }
```
- 将`CustomerAuthenticationProvider`申明成Bean，并加入认证流程中，支持自定义多个provider

```
@Bean
public AuthenticationProvider authenticationProvider(){
    return new CustomerAuthenticationProvider();
}

@Override
protected void configure(AuthenticationManagerBuilder auth) throws Exception {
//        auth.userDetailsService(userDetailsService());
    auth.authenticationProvider(authenticationProvider());
//        auth.authenticationProvider(authenticationProviderB());
}
```

## 四、总结
- 自定义`AuthenticationProvider`对比自定义`UserDetailsService`灵活度更高，同时也增加了代码的复杂性，需要自己实现认证的过程，对于大部分场景，使用自定义`UserDetailsService`就可以满足使用。
- `Spring Security`是通过`filter`机制实现的，他并不依赖任何第三方框架，只依赖于`Servlet`容器。
- 初次接触`Spring Security`框架，会被其中的各种类所困扰，下面是关于`Spring Security`常见类的简单说明
    - `Authentication`：凭证，传递于整个认证流程中。根据他的认证状态可分成未认证凭证和已认证过的凭证
        - 未认证凭证：指的是用户输入username、password后后台组装的凭证
        - 已认证凭证：通过认证，系统重新构造的凭证，其中包含了用户名、密码、权限等信息。
    - `AuthenticationManager`：`AuthenticationManager`有一个关键实现类`ProviderManager`，他本身不进行`Authentication`的认证，而是调用不同的`AuthenticationProvider`进行认证
    - `AuthenticationProvider`：负责对`Authentication`进行认证
    - `UserDetailsService`：负责用户信息的加载
- `Spring Security`认证流程：
    - 用户输入用户名密码，发起登录请求
    - `filter`(如`UsernamePasswordAuthenticationFilter`、`BasicAuthenticationFilter`)拦截请求后，将用户名密码封装成`Authentication`交由`AuthenticationManager`进行处理
    - `AuthenticationManager`调用`AuthenticationProvider`进行认证
    - `AuthenticationProvider`进行认证，并检查账号是否有异常(是否被锁、是否禁用、是否过期)，认证通过且账号没有异常的情况下，重新构造已认证的`Authentication`，结束认证流程



---
> 源码地址：[github](https://github.com/a479159321/blog/tree/master/spring%20security/spring-security-getting-started)