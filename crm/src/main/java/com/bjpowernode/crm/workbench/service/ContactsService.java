package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> allContacts();

    Contacts getById(String id);

    List<Activity> allRealtion(String contactsId);

    List<Activity> searchActivity(String name,String contactsId);

    Map<String, Object> correlation(ContactsActivityRelation contactsActivityRelation);

    Map<String, Object> del(String id);
}
