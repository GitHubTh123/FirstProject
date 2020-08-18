package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    List<Activity> allActivity(Map<String, Object> map);

    int total(Map<String, Object> map);

    List<User> allUser();

    int insertActivity(Activity activity);

    Activity toEdit(String id);

    int update(Activity activity);

    int delete(String[] arr);

    List<Activity> downloadAdvice();

    List<Activity> download(String[] arr);

    int addSome(List<Activity> activities);

    Activity toDetail(String id);

    List<Activity> relationActivityClue(String clueId);

    List<Activity> getActivityByName(@Param("clueId") String Id, @Param("name") String activityName);
    List<Activity> searchActivity(String name);
}
