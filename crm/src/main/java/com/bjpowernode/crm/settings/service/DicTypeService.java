package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

public interface DicTypeService {
    List<DicType> allType();

    DicType byId(String code);

    int update(DicType dicType);

    int del(String[] arr);
    int add(DicType dicType);
}
