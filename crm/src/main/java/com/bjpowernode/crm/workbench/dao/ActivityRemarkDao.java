package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
List<ActivityRemark> all(String id);
int delete(String id);
int save(ActivityRemark activityRemark);
int update(ActivityRemark activityRemark);
}
