package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;

@RequestMapping("/workbench/contacts")
@Controller
public class ContactsController {
    @Autowired
    private ContactsService service;

    @RequestMapping("/pageList.do")
    @ResponseBody
    public List<Contacts> pageList() {
        return service.allContacts();
    }
    @ResponseBody
    @RequestMapping("/toDetail.do")
    public ModelAndView toDetail(String id ){
        ModelAndView mv = new ModelAndView();
        Contacts contacts=service.getById(id);
        mv.addObject("c",contacts);
        mv.setViewName("workbench/contacts/detail");
        return  mv;
    }
    @RequestMapping("/allRealtion.do")
    @ResponseBody
    public List<Activity> allRealtion(String contactsId){
        return service.allRealtion(contactsId);
    }
    @ResponseBody
    @RequestMapping("/searchActivity.do")
    public List<Activity> searchActivity(String name,String contactsId){
        return  service.searchActivity(name,contactsId);
    }
    @RequestMapping("/correlation.do")
    @ResponseBody
    public Map<String,Object> correlation(ContactsActivityRelation contactsActivityRelation){
        contactsActivityRelation.setId(UUIDUtil.getUUID());
        System.out.println(contactsActivityRelation);
        return service.correlation(contactsActivityRelation);
    }
    @ResponseBody
    @RequestMapping("/del.do")
    public Map<String,Object> del(String id){
        return service.del(id);
    }
}
