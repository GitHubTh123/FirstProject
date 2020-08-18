package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
VoForPage allActivity(Map<String,Object> map);
    List<User> allUser();
    Map<String,Object> insert(Activity activity);
    Map<String,Object> update(Activity activity);
    Map<String,Object> delete(String [] arr);
    Activity toEdit(String id );
    List<Activity> downloadAdvice();
    List<Activity> download(String []arr);
    Map<String,Object>  addSome(List<Activity> activities);


    Activity toDetail(String id);
}
