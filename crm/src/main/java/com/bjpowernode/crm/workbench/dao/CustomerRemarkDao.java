package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {
    int insertCustomerRemark(List<CustomerRemark> list);

    List<CustomerRemark> customerRemark(String customerId);

    int saveCustomerRemark(CustomerRemark customerRemark);

    int deleteCustomerRemark(String id);
}
