package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/settings/user")
public class UserController {
    @Resource
    private UserService service;


    @RequestMapping("/toLogin.do")
    public String toLogin(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 1) {
            String account = null;
            String password = null;
            for (Cookie cookie : cookies
            ) {
                if (cookie.getName().equals("account")) {
                    account = cookie.getValue();
                    continue;
                }
                 if (cookie.getName().equals("password")) {
                    password = cookie.getValue();
                }

            }
            try {
                User user = service.login(request, account, password);
                request.getSession().setAttribute("user",user);
                return "redirect:/settings/user/success.do";
            } catch (Exception e) {
                e.printStackTrace();
                return "login";
            }
        } else {
            return "login";
        }

    }

    @ResponseBody
    @RequestMapping("/login.do")
    public Map<String, Object> login(HttpServletRequest request, String account, String password, String flag, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        password = MD5Util.getMD5(password);
        try {
            service.login(request, account, password);
            map.put("success", true);
            if ("a".equals(flag)) {
                Cookie cookie1 = new Cookie("account", account);
                Cookie cookie2 = new Cookie("password", password);
                cookie1.setMaxAge(60 * 60 * 24 * 10);
                cookie2.setMaxAge(60 * 60 * 24 * 10);
                response.addCookie(cookie1);
                response.addCookie(cookie2);

            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("msg", e.getMessage());
        }
        return map;
    }

    @RequestMapping("/success.do")
    public String success() {
        return "workbench/index";
    }


    @RequestMapping("/edit.do")
    public ModelAndView edit(HttpServletRequest request,HttpServletResponse response){
        ModelAndView mv = new ModelAndView();
        request.getSession().invalidate();
        Cookie cookie1= new Cookie("account","");
        Cookie cookie2= new Cookie("password","");
        cookie1.setMaxAge(0);
        cookie2.setMaxAge(0);
        response.addCookie(cookie1);
        response.addCookie(cookie2);
        mv.setViewName("login");
        return mv;
    }


}
