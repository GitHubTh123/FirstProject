package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.MD5Util;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao dao;


    @Override
    public User login(HttpServletRequest request, String account, String password) throws Exception {

        User user = dao.login(account, password);
        if (user == null) {
            throw new LoginException("账号或密码错误");
        }
        String ip = request.getRemoteAddr();
        if (!user.getAllowIps().contains(ip)) {
            throw new LoginException("没有权限的ip地址");
        }
        String sysTime = DateTimeUtil.getSysTime();
        if (sysTime.compareTo(user.getExpireTime()) > 0) {
            throw new LoginException("账号已过期");
        }
       if(!user.getLockState().equals("1")){
           throw new LoginException("账号被锁定");
       }
       request.getSession().setAttribute("user",user);

        return user;
    }
}
