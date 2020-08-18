package com.bjpowernode.crm.utils;

import com.bjpowernode.crm.settings.domain.User;
import org.apache.poi.ss.formula.functions.T;

import javax.servlet.http.HttpSession;
import java.lang.reflect.Field;

public class PropertiesUtil {
    private PropertiesUtil() {
    }

    public static void sets(Object obj, HttpSession session) throws Exception {
        //拿到class对象
        Class c = obj.getClass();

        //拿到字段名
        Field id = c.getDeclaredField("id");
        Field createBy = c.getDeclaredField("createBy");
        Field createTime = c.getDeclaredField("createTime");
        User user = (User) session.getAttribute("user");
        //打破封装
        id.setAccessible(true);
        createBy.setAccessible(true);
        createTime.setAccessible(true);
        //赋值
        id.set(obj, UUIDUtil.getUUID());
        createBy.set(obj, user.getName());
        createTime.set(obj, DateTimeUtil.getSysTime());


    }
}
