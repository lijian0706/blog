package com.lijian.springsecuritygettingstarted.service.impl;

import com.lijian.springsecuritygettingstarted.domain.SysUser;
import com.lijian.springsecuritygettingstarted.repository.SysUserRepository;
import com.lijian.springsecuritygettingstarted.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class SysUserServiceImpl implements SysUserService {

    @Autowired
    private SysUserRepository sysUserRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public SysUser createAdminUser() {
        SysUser adminUser = SysUser.initAdminUser(passwordEncoder.encode(SysUser.ADMIN_PASSWORD));
        return sysUserRepository.save(adminUser);
    }

    @Override
    public SysUser queryUser(String username) {
        return sysUserRepository.findByUsername(username);
    }
}
