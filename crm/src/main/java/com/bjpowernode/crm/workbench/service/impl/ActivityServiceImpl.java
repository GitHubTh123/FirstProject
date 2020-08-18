package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityDao dao;

    @Override
    public VoForPage allActivity(Map<String, Object> map) {
        VoForPage vo = new VoForPage();
        int total = dao.total(map);
        List<Activity> list = dao.allActivity(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;
    }

    @Override
    public List<User> allUser() {
        return dao.allUser();
    }

    @Override
    public Map<String, Object> insert(Activity activity) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (dao.insertActivity(activity) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Map<String, Object> update(Activity activity) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (dao.update(activity) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Map<String, Object> delete(String[] arr) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (dao.delete(arr) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Activity toEdit(String id) {
        return dao.toEdit(id);
    }

    @Override
    public List<Activity> downloadAdvice() {
        return dao.downloadAdvice();
    }

    @Override
    public List<Activity> download(String[] arr) {
        return dao.download(arr);
    }

    @Override
    public Map<String, Object> addSome(List<Activity> activities) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (dao.addSome(activities) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Activity toDetail(String id) {
        return dao.toDetail(id);
    }
}
