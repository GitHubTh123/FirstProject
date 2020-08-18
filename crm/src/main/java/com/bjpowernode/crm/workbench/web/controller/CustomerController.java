package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.PropertiesUtil;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.awt.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/customer")
public class CustomerController {
    @Autowired
    private CustomerService service;

    @RequestMapping("/pageList.do")
    @ResponseBody
    public VoForPage pageList(String name, String website, String phone, String owner, Integer pageSize, Integer pageNo) {
        Map<String, Object> map = new HashMap<>();
        Integer skipCount = (pageNo - 1) * pageSize;
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        map.put("name", name);
        map.put("owner", owner);
        map.put("website", website);
        map.put("phone", phone);
        return service.pageList(map);
    }

    @ResponseBody
    @RequestMapping("/allUser.do")
    public List<User> allUser() {
        return service.allUser();
    }

    @RequestMapping("/saveCustomer.do")
    @ResponseBody
    public Map<String, Object> saveCustomer(Customer customer, HttpSession session) throws Exception {
        PropertiesUtil.sets(customer, session);
        return service.saveCustomer(customer);
    }

    @ResponseBody
    @RequestMapping("/edit.do")
    public Map<String, Object> edit(String id) {
        return service.getById(id);
    }

    @RequestMapping("/updateCustomer.do")
    @ResponseBody
    public Map<String, Object> updateCustomer(Customer customer) {
        return service.updateCustomer(customer);
    }

    @ResponseBody
    @RequestMapping("/deleteCustomer.do")
    public Map<String, Object> deleteCustomer(String[] arr) {
        return service.deleteCustomer(arr);
    }

    @RequestMapping("/toDetail.do")
    @ResponseBody
    public ModelAndView toDetail(String id) {
        ModelAndView mv = new ModelAndView();
        Customer c = service.toDetail(id);
        mv.addObject("c", c);
        mv.setViewName("workbench/customer/detail");
        return mv;
    }

    @ResponseBody
    @RequestMapping("/customerRemark.do")
    public List<CustomerRemark> customerRemark(String customerId) {
        return service.customerRemark(customerId);
    }

    @RequestMapping("/saveCustomerRemark.do")
    @ResponseBody
    public Map<String, Object> saveCustomerRemark(CustomerRemark customerRemark, HttpSession session) throws Exception {
        PropertiesUtil.sets(customerRemark, session);
        customerRemark.setEditFlag("0");
        Map<String, Object> map = service.saveCustomerRemark(customerRemark);
        map.put("c", customerRemark);
        return map;

    }
    @ResponseBody
    @RequestMapping("/deleteCustomerRemark.do")
    public Map<String,Object> deleteCustomerRemark(String id ){
        return service.deleteCustomerRemark(id);
    }

}
