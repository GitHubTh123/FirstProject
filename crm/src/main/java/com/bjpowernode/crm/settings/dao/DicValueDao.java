package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> allValue();

    int add(DicValue dicValue);

    int update(DicValue dicValue);

    int del(String[] arr);

    DicValue byId(String id);

    int delSome(String[] arr);

    List<DicValue> cache(String code);
}
