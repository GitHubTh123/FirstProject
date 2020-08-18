package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

Customer getCustomerByName(String name);

    int insertCustomer(Customer customer);
    List<String> getCustomerName(String name);

    int total(Map<String, Object> map);

    List<Customer> pageList(Map<String, Object> map);

    int saveCustomer(Customer customer);

    Customer getById(String id);

    int updateCustomer(Customer customer);
    int deleteCustomer(String [] arr);

    Customer toDetail(String id);
}
