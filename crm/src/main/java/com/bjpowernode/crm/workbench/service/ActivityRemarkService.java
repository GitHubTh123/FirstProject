package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public interface ActivityRemarkService {
    List<ActivityRemark> all(String id);
    Map<String,Object> delete(String id);
    Map<String,Object> save(ActivityRemark activityRemark);
    Map<String,Object> update(ActivityRemark activityRemark);
}

