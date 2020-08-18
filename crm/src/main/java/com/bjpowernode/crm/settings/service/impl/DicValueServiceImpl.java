package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.dao.DicValueDao;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {
    @Resource
    private DicValueDao dicValueDao;

    @Override
    public List<DicValue> allValue() {
        return dicValueDao.allValue();
    }

    @Override
    public int add(DicValue dicValue) {
        return dicValueDao.add(dicValue);
    }

    @Override
    public int update(DicValue dicValue) {
        return dicValueDao.update(dicValue);
    }

    @Override
    public int del(String[] arr) {
        return dicValueDao.del(arr);
    }

    @Override
    public DicValue byId(String id) {
        return dicValueDao.byId(id);
    }

    @Override
    public int delSome(String[] arr) {
        return dicValueDao.delSome(arr);
    }

    @Override
    public List<DicValue> cache(String code) {
        return dicValueDao.cache(code);
    }
}
