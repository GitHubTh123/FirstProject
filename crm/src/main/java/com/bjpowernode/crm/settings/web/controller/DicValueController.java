package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.utils.UUIDUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dicv")
public class DicValueController {
    @Resource
    private DicValueService service;

    @RequestMapping("/allValue.do")
    @ResponseBody
    public List<DicValue> allValue() {
        return service.allValue();
    }

    @ResponseBody
    @RequestMapping("/add.do")
    public Map<String, Object> add(DicValue dicValue) {
        Map<String, Object> map = new HashMap<>();
        dicValue.setId(UUIDUtil.getUUID());
        service.add(dicValue);
        map.put("success", true);
        return map;
    }

    @RequestMapping("/del.do")
    public String del(String[] arr) {
        service.del(arr);
        return "redirect:/file/toValue.do";
    }


    @RequestMapping("/toEdit.do")
    public ModelAndView toEdit(String id) {
        ModelAndView mv = new ModelAndView();
        DicValue dicValue = service.byId(id);
        if (dicValue != null) {
            mv.addObject("dicv", dicValue);
            mv.setViewName("settings/dictionary/value/edit");
        }
        return mv;
    }

    @RequestMapping("/update.do")
    @ResponseBody
    public Map<String, Object> update(DicValue dicValue) {
        Map<String, Object> map = new HashMap<>();

        try {
            service.update(dicValue);
            map.put("success", true);
        } catch (Exception e) {
            map.put("success", false);

        }
        return map;
    }
}
