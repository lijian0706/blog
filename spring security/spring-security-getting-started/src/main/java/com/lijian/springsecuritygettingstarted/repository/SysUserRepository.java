package com.lijian.springsecuritygettingstarted.repository;

import com.lijian.springsecuritygettingstarted.domain.SysUser;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SysUserRepository extends JpaRepository<SysUser, Long> {
    SysUser findByUsername(String username);
}
