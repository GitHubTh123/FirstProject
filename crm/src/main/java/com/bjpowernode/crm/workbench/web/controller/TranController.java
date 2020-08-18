package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.PropertiesUtil;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/transaction")
public class TranController {
    @Autowired
    private TranService service;

    @RequestMapping("/toSave.do")
    public ModelAndView toSave() {
        ModelAndView mv = new ModelAndView();
        List<User> user = service.allUser();
        mv.setViewName("workbench/transaction/save");
        mv.addObject("allUser", user);
        return mv;
    }

    @RequestMapping("/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerName(String name) {
        return service.getCustomerName(name);
    }

    @ResponseBody
    @RequestMapping("/possibility.do")
    public String possibility(String stage, HttpServletRequest request) {
        Map<String, String> map = (Map<String, String>) request.getServletContext().getAttribute("map");

        String possibility = map.get(stage);
        return possibility;

    }

    @RequestMapping("/saveTran.do")
    public String saveTran(Tran tran, HttpSession session, String customerName) throws Exception {
        return service.saveTran(tran, customerName, session);
    }

    @RequestMapping("/searchContacts.do")
    @ResponseBody
    public List<Contacts> searchContacts(String name) {
        return service.searchContacts(name);
    }

    @ResponseBody
    @RequestMapping("/searchActivity.do")
    public List<Activity> searchActivity(String name) {
        return service.searchActivity(name);
    }


    @RequestMapping("/pageList.do")
    @ResponseBody
    public VoForPage pageList(Integer pageNo, Integer pageSize, String name,
                              String stage, String type, String source, String customerId, String activityId
            , String owner) {
        Map<String, Object> map = new HashMap<>();
        Integer skipCount = (pageNo - 1) * pageSize;
        map.put("owner", owner);
        map.put("name", name);
        map.put("stage", stage);
        map.put("source", source);
        map.put("skipCount", skipCount);
        map.put("customerId", customerId);
        map.put("activityId", activityId);
        map.put("type", type);
        map.put("pageSize", pageSize);
        return service.pageList(map);

    }

    @RequestMapping("/exit.do")
    public String exit() {
        return "redirect:/file/toTransaction.do";
    }

    @RequestMapping("/toDetail.do")
    public ModelAndView toDetail(String id, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView();

        Tran tran = service.getTranById(id);
        Map<String, String> map = (Map<String, String>) request.getServletContext().getAttribute("map");
        String possibility = map.get(tran.getStage());
        tran.setPossibility(possibility);
        mv.addObject("t", tran);

        mv.setViewName("workbench/transaction/detail");
        return mv;
    }

    @RequestMapping("/allTranHistory.do")
    @ResponseBody
    public List<TranHistory> allTranHistory(String tranId, HttpServletRequest request) {
        Map<String, String> map = (Map<String, String>) request.getServletContext().getAttribute("map");
        List<TranHistory> tranHistories = service.allTranHistory(tranId);
        for (TranHistory th : tranHistories
        ) {
            String possibility = map.get(th.getStage());
            th.setPossibility(possibility);

        }
        return tranHistories;
    }

    @ResponseBody
    @RequestMapping("/changeStage.do")
    public Map<String, Object> changeStage(Tran tran, HttpServletRequest request) {
        return service.changeStage(tran, request);
    }

    @ResponseBody
    @RequestMapping("/tranRemark.do")
    public List<TranRemark> tranRemark(String tranId) {
        System.out.println(tranId);
        return service.allTranRemark(tranId);
    }

    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public Map<String, Object> saveRemark(TranRemark remark, HttpSession session) throws Exception {
        PropertiesUtil.sets(remark, session);
        remark.setEditFlag("0");
        Map<String, Object> map = service.saveRemark(remark);
        map.put("r", remark);
        return map;
    }
}
