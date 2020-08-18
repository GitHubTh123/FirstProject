package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/activityremark")
public class ActivityRemarkController {
    @Resource
    private ActivityRemarkService service;

    @RequestMapping("/all.do")
    @ResponseBody
    public List<ActivityRemark> all(String id) {
        return service.all(id);
    }

    @ResponseBody
    @RequestMapping("/delete.do")
    public Map<String, Object> delete(String id) {
        return service.delete(id);
    }

    @RequestMapping("/save.do")
    @ResponseBody
    public Map<String, Object> save(String activityId, String noteContent, HttpServletRequest request) {
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setActivityId(activityId);
        activityRemark.setEditFlag("0");
        User user = (User) request.getSession().getAttribute("user");
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setCreateBy(user.getName());
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setNoteContent(noteContent);

        Map<String, Object> map = service.save(activityRemark);
        map.put("ac", activityRemark);
        return map;

    }
    @ResponseBody
    @RequestMapping("/update.do")
    public Map<String,Object> delete(ActivityRemark activityRemark,HttpServletRequest request){
        User user = (User) request.getSession().getAttribute("user");
        activityRemark.setEditFlag("1");
        activityRemark.setEditBy(user.getName());
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        Map<String, Object> map = service.update(activityRemark);
        map.put("ac",activityRemark);
        return map;
    }

}
