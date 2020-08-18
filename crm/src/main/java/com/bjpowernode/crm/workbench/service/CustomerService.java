package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    VoForPage pageList(Map<String, Object> map);

    List<User> allUser();

    Map<String, Object> saveCustomer(Customer customer);

   Map<String,Object> getById(String id);

    Map<String, Object> updateCustomer(Customer customer);
    Map<String, Object> deleteCustomer(String [] arr);

    Customer toDetail(String id);

    List<CustomerRemark> customerRemark(String customerId);

    Map<String, Object> saveCustomerRemark(CustomerRemark customerRemark);

    Map<String, Object> deleteCustomerRemark(String id);
}
