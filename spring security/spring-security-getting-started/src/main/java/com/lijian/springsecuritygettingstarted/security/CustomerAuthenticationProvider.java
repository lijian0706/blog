package com.lijian.springsecuritygettingstarted.security;

import com.lijian.springsecuritygettingstarted.domain.SysUser;
import com.lijian.springsecuritygettingstarted.repository.SysUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;

public class CustomerAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    private SysUserRepository sysUserRepository;

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
}
