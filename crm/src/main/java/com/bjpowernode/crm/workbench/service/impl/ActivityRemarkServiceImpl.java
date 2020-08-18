package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Resource
    private ActivityRemarkDao dao;


    @Override
    public List<ActivityRemark> all(String id) {
        return dao.all(id);
    }

    @Override
    public Map<String, Object> delete(String id) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (dao.delete(id) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Map<String, Object> save(ActivityRemark activityRemark) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (dao.save(activityRemark) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Map<String, Object> update(ActivityRemark activityRemark) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (dao.update(activityRemark) > 0) {
            map.put("success", true);
        }
        return map;
    }
}
