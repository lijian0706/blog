package com.lijian.springsecuritygettingstarted.controller;

import com.lijian.springsecuritygettingstarted.domain.SysUser;
import com.lijian.springsecuritygettingstarted.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private SysUserService sysUserService;

    @PostMapping("/admin")
    public SysUser createAdminUser(){
        return sysUserService.createAdminUser();
    }
}
