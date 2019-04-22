package com.lijian.springsecuritygettingstarted.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true) // 开启全局方法安全，方法上可添加`@PreAuthorize`进行权限控制
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    @Override
    protected UserDetailsService userDetailsService() {
        return new JpaUserDetailsService();
    }

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
                .csrf().disable(); // 本示例关闭了跨站请求伪造攻击的保护，生产环境应开启

    }

    @Bean
    public AuthenticationProvider authenticationProvider(){
        return new CustomerAuthenticationProvider();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
//        auth.userDetailsService(userDetailsService());
        auth.authenticationProvider(authenticationProvider());
    }

}
