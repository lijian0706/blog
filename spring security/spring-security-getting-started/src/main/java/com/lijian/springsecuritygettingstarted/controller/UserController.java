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

    @PostMapping("/admin")
    public SysUser createAdminUser(){
        return sysUserService.createAdminUser();
    }

    @GetMapping("/{username}")
    @PreAuthorize("hasAuthority('QUERY_USER_INFO')")
    public SysUser queryUser(@PathVariable String username){
        return sysUserService.queryUser(username);
    }

    @GetMapping("/self")
    public SysUser queryMySelf(Principal principal){
        return sysUserService.queryUser(principal.getName());
//        return (SysUser) ((UsernamePasswordAuthenticationToken) principal).getPrincipal();
    }
}
