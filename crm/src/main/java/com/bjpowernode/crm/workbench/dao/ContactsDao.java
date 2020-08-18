package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsDao {

    int insertContacts(Contacts contacts);
    List<Contacts> getByName(String name);

    List<Contacts> allContacts();

    Contacts getById(String id);

    List<Activity> allRealtion(String contactsId);

    List<Activity> searchActivity(@Param("name") String activityName, @Param("contactsId") String id);

    int correlation(ContactsActivityRelation contactsActivityRelation);

    int del(String id);
}

