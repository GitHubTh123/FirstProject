package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PropertiesUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/clue")
public class ClueController {
    @Resource
    private ClueService service;

    @RequestMapping("/pageList.do")
    @ResponseBody
    public VoForPage page(String owner, String fullname,
                          String company, String mphone,
                          String phone, String source,
                          String state, Integer pageNo,
                          Integer pageSize
    ) {


        Map<String, Object> map = new HashMap<>();
        Integer skipCount = (pageNo - 1) * pageSize;
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        map.put("company", company);
        map.put("owner", owner);
        map.put("fullname", fullname);
        map.put("mphone", mphone);
        map.put("phone", phone);
        map.put("state", state);
        map.put("source", source);
        return service.page(map);
    }

    @ResponseBody
    @RequestMapping("/allUser.do")
    public List<User> allUser() {
        return service.allUser();
    }

    @RequestMapping("save.do")
    @ResponseBody
    public Map<String, Object> save(Clue clue, HttpSession session) throws Exception {
        PropertiesUtil.sets(clue, session);
        return service.insertClue(clue);
    }

    @ResponseBody
    @RequestMapping("/toEdit.do")
    public Clue toEdit(String id) {
        return service.toEdit(id);
    }

    @RequestMapping("/update.do")
    @ResponseBody
    public Map<String, Object> update(Clue clue, HttpSession session) {
        User user = (User) session.getAttribute("user");
        clue.setEditTime(DateTimeUtil.getSysTime());
        clue.setEditBy(user.getName());

        return service.updateClue(clue);
    }

    @ResponseBody
    @RequestMapping("/deleteClue.do")
    public Map<String, Object> deleteClue(String[] arr) {
        return service.deleteClue(arr);
    }

    @RequestMapping("/toDetail.do")
    public ModelAndView toDetail(String id) {
        ModelAndView mv = new ModelAndView();
        Clue clue = service.toDetail(id);
        mv.addObject("clue", clue);
        mv.setViewName("workbench/clue/detail");
        return mv;
    }

    @RequestMapping("/getRemark.do")
    @ResponseBody
    public List<ClueRemark> getRemark(String id) {
        return service.getClueRemarkByClueId(id);
    }

    @ResponseBody
    @RequestMapping("/deleteClueRemark.do")
    public Map<String, Object> deleteClueRemark(String id) {
        return service.deleteClueRemark(id);
    }

    @RequestMapping("/insertClueRemark.do")
    @ResponseBody
    public Map<String, Object> insertClueRemark(ClueRemark clueRemark, HttpSession session) throws Exception {
        PropertiesUtil.sets(clueRemark, session);
        clueRemark.setEditFlag("0");
        return service.insertClueRemark(clueRemark);
    }

    @RequestMapping("/relationActivityClue.do")
    @ResponseBody
    public List<Activity> relationActivityClue(String clueId) {
        return service.relationActivityClue(clueId);
    }

    @ResponseBody
    @RequestMapping("/getActivityByName.do")
    public List<Activity> getActivityByName(String clueId, String name) {
        return service.getActivityByName(clueId, name);
    }

    @RequestMapping("/correaltionActivityClue.do")
    @ResponseBody
    public Map<String, Object> correaltionActivityClue(String clueId, String[] arr) {
        List<ClueActivityRelation> list = new ArrayList<>();
        for (String activityId : arr) {
            ClueActivityRelation c = new ClueActivityRelation();
            c.setActivityId(activityId);
            c.setClueId(clueId);
            c.setId(UUIDUtil.getUUID());
            list.add(c);
        }

        return service.insertcar(list);
    }

    @ResponseBody
    @RequestMapping("/unRealtion.do")
    public Map<String, Object> unRealtion(String id) {
        return service.deletecar(id);
    }

    @RequestMapping("/toConvert.do")
    public ModelAndView toConvert(String id) {
        ModelAndView mv = new ModelAndView();
        Clue clue = service.getClueById(id);
        mv.addObject("c", clue);
        mv.setViewName("workbench/clue/convert");
        return mv;
    }

    @RequestMapping("/searchActivity.do")
    @ResponseBody
    public List<Activity> searchActivity(String name) {
        return service.searchActivity(name);
    }

    @RequestMapping("/transform.do")
    public String transform(Tran tran, String clueId, String flag, HttpSession session) throws Exception {

        String s = "redirect:/fail.jsp";
        if (service.transform(tran, clueId, flag, session)) {
            s = "redirect:/file/toClue.do";
        }
        return s;
    }
}