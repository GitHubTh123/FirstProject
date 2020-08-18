package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.CustomerRemarkDao;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private UserDao userDao;
    @Autowired
    private CustomerRemarkDao customerRemarkDao;

    @Override
    public VoForPage pageList(Map<String, Object> map) {
        VoForPage vo = new VoForPage();
        List<Customer> list = customerDao.pageList(map);
        int total = customerDao.total(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;
    }

    @Override
    public List<User> allUser() {
        return userDao.allUser();
    }

    @Override
    public Map<String, Object> saveCustomer(Customer customer) {
        Map<String, Object> map = new HashMap<>();
        if (customerDao.saveCustomer(customer) > 0) {
            map.put("success", true);
        }
        return map;

    }

    @Override
    public Map<String,Object> getById(String id) {
        Map<String, Object> map = new HashMap<>();
        Customer byId = customerDao.getById(id);
        if (byId != null) {
            map.put("success",true);
            map.put("c",byId);
        }
        return map;

    }

    @Override
    public Map<String, Object> updateCustomer(Customer customer) {
       customer.setEditTime(DateTimeUtil.getSysTime());
        Map<String, Object> map = new HashMap<>();
        if (customerDao.updateCustomer(customer) > 0) {
            map.put("success", true);
        }
        return map;

    }

    @Override
    public Map<String, Object> deleteCustomer(String[] arr) {
        Map<String, Object> map = new HashMap<>();
        if (customerDao.deleteCustomer(arr)> 0) {
            map.put("success", true);
        }
        return map;

    }

    @Override
    public Customer toDetail(String id) {
        return customerDao.toDetail(id);
    }

    @Override
    public List<CustomerRemark> customerRemark(String customerId) {
        return customerRemarkDao.customerRemark(customerId);
    }

    @Override
    public Map<String, Object> saveCustomerRemark(CustomerRemark customerRemark) {
        Map<String,Object> map = new HashMap<>();
        if(customerRemarkDao.saveCustomerRemark(customerRemark)>0){
            map.put("success",true);
        }
        return map;
    }

    @Override
    public Map<String, Object> deleteCustomerRemark(String id) {
        Map<String,Object> map = new HashMap<>();
        if(customerRemarkDao.deleteCustomerRemark(id)>0){
            map.put("success",true);
        }
        return map;
    }
}
