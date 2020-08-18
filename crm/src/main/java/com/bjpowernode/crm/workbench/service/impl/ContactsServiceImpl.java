package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.ContactsDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsDao contactsDao;

    @Override
    public List<Contacts> allContacts() {
        return contactsDao.allContacts();
    }

    @Override
    public Contacts getById(String id) {
        return contactsDao.getById(id);
    }

    @Override
    public List<Activity> allRealtion(String contactsId) {
        return contactsDao.allRealtion(contactsId);
    }

    @Override
    public List<Activity> searchActivity(String name,String contactsId) {
        return contactsDao.searchActivity(name,contactsId);
    }

    @Override
    public Map<String, Object> correlation(ContactsActivityRelation contactsActivityRelation) {

        Map<String, Object> map = new HashMap<>();
        if (contactsDao.correlation(contactsActivityRelation) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Map<String, Object> del(String id) {

        Map<String, Object> map = new HashMap<>();
        if (contactsDao.del(id) > 0) {
            map.put("success", true);
        }
        return map;
    }
}
