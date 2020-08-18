package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.omg.CORBA.MARSHAL;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dict")
public class DicTypeController {
    @Resource
    private DicTypeService service;
    @Resource
    private DicValueService service1;

    @ResponseBody
    @RequestMapping("/allType.do")
    public List<DicType> allType() {
        return service.allType();
    }

    @RequestMapping("/toEdit.do")
    public ModelAndView toEdit(String code) {
        ModelAndView mv = new ModelAndView();
        DicType dicType = service.byId(code);
        if (dicType != null) {
            mv.addObject("dic", dicType);
            mv.setViewName("settings/dictionary/type/edit");
        }
        return mv;
    }

    @RequestMapping("/add.do")
    @ResponseBody
    public Map<String, Object> add(DicType dicType) {
        Map<String, Object> map = new HashMap<>();
        map.put("success",false);
        if (service.add(dicType) > 0) {
            map.put("success", true);
        }

        return map;
    }

    @RequestMapping("/update.do")
    @ResponseBody
    public Map<String, Object> update(DicType dicType) {
        Map<String, Object> map = new HashMap<>();

        try {
            service.update(dicType);
            map.put("success", true);
        } catch (Exception e) {
            map.put("success", false);

        }
        return map;
    }

    @RequestMapping("/del.do")
    public String del(String[] arr) {
     service1.delSome(arr);
        int i = service.del(arr);
        return "redirect:/file/toType.do";
    }
}
