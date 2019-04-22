package com.lijian.springsecuritygettingstarted.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
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
        web.ignoring().antMatchers("/login.html", "/webjars/**")
                .antMatchers(HttpMethod.POST, "/users/admin");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .userDetailsService(userDetailsService())
                .formLogin()
                    .loginPage("/login.html")
                    .loginProcessingUrl("/login")
                .and()
                .authorizeRequests()
//                    .antMatchers("/login.html", "/webjars/**").permitAll()
//                    .antMatchers(HttpMethod.POST, "/users/admin").permitAll()
                    .antMatchers("/**").authenticated();
    }
}
