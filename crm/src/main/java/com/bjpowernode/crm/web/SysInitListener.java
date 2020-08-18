package com.bjpowernode.crm.web;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext servletContext = sce.getServletContext();
        DicTypeService typeService = WebApplicationContextUtils.getWebApplicationContext(servletContext).getBean(DicTypeService.class);
        DicValueService dicValueService = WebApplicationContextUtils.getWebApplicationContext(servletContext).getBean(DicValueService.class);
        List<DicType> dicTypes = typeService.allType();
        for (DicType type : dicTypes) {
            String code = type.getCode();
            List<DicValue> dicValue = dicValueService.cache(code);
            servletContext.setAttribute(code, dicValue);

        }


        ResourceBundle bundle =ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys = bundle.getKeys();
        Map<String,String> map=new HashMap<>();
        while(keys.hasMoreElements()){
            String key = keys.nextElement();
            String value = bundle.getString(key);
            map.put(key,value);

        }

        servletContext.setAttribute("map",map);


    }
}
