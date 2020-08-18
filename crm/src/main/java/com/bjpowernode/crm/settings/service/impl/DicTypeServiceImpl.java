package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.dao.DicTypeDao;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.service.DicTypeService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DicTypeServiceImpl implements DicTypeService {
    @Resource
    private DicTypeDao dao;

    @Override
    public List<DicType> allType() {
        return dao.allType();
    }

    @Override
    public DicType byId(String code) {
        return dao.byId(code);
    }

    @Override
    public int update(DicType dicType) {
        return dao.update(dicType);
    }

    @Override
    public int del(String[] arr) {
        return dao.del(arr);
    }

    @Override
    public int add(DicType dicType) {
        return dao.add(dicType);
    }
}
