package com.lijian.springsecuritygettingstarted.controller;

import com.lijian.springsecuritygettingstarted.domain.SysUser;
import com.lijian.springsecuritygettingstarted.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private SysUserService sysUserService;

    /**
     * 用于快速初始化admin用户以及他的角色、权限，初始密码是admin
     * @return
     */
    @PostMapping("/admin")
    public SysUser createAdminUser(){
        return sysUserService.createAdminUser();
    }

    /**
     * 通过用户名查询用户信息
     * @param username
     * @return
     */
    @GetMapping("/{username}")
    @PreAuthorize("hasAuthority('QUERY_USER_INFO')")
    public SysUser queryUser(@PathVariable String username){
        return sysUserService.queryUser(username);
    }

    /**
     * 查询个人资料
     * @param principal
     * @return
     */
    @GetMapping("/self")
    public SysUser queryMySelf(Principal principal){
        return sysUserService.queryUser(principal.getName());
//        return (SysUser) ((UsernamePasswordAuthenticationToken) principal).getPrincipal(); // 也可以通过强制转换得到
    }
}
