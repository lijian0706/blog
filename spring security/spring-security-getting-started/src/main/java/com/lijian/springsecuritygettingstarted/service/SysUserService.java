package com.lijian.springsecuritygettingstarted.service;

import com.lijian.springsecuritygettingstarted.domain.SysUser;
import org.springframework.security.access.prepost.PreAuthorize;

public interface SysUserService {
    SysUser createAdminUser();
    SysUser queryUser(String username);
}
