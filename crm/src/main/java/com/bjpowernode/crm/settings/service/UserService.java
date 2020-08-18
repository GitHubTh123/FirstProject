package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.http.HttpServletRequest;

public interface UserService {
   User login(HttpServletRequest request, String account , String password) throws Exception;

}
