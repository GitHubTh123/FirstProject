package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PropertiesUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.TranService;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private TranDao tranDao;
    @Autowired
    private UserDao userDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private ActivityDao activityDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;
    @Autowired
    private TranRemarkDao tranRemarkDao;

    @Override
    public List<User> allUser() {
        return userDao.allUser();
    }

    @Override
    public List<String> getCustomerName(String name) {
        return customerDao.getCustomerName(name);
    }

    @Override
    public List<Activity> searchActivity(String name) {
        return activityDao.searchActivity(name);
    }

    @Override
    public List<Contacts> searchContacts(String name) {
        return contactsDao.getByName(name);
    }

    @Override
    public String saveTran(Tran tran, String customerName, HttpSession session) throws Exception {
        String s = "redirect:/file/toTransaction.do";
        Map<String, String> map = (Map<String, String>) session.getServletContext().getAttribute("map");
        Customer customer = customerDao.getCustomerByName(customerName);
        if (customer == null) {
            customer = new Customer();
            PropertiesUtil.sets(customer, session);
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setName(customerName);
            customer.setOwner(tran.getOwner());
            customer.setDescription(tran.getDescription());
            tran.setCustomerId(customer.getId());
            customerDao.insertCustomer(customer);

        } else {
            tran.setCustomerId(customer.getId());
        }

        PropertiesUtil.sets(tran, session);
        tranDao.insertTran(tran);
        TranHistory th = new TranHistory();
        PropertiesUtil.sets(th, session);
        th.setMoney(tran.getMoney());
        th.setExpectedDate(tran.getExpectedDate());
        th.setTranId(tran.getId());
        th.setStage(tran.getStage());
        tranHistoryDao.insertTranHistory(th);

        return s;
    }

    @Override
    public VoForPage pageList(Map<String, Object> map) {
        VoForPage vo = new VoForPage();
        vo.setDataList(tranDao.allTran(map));
        vo.setTotal(tranDao.total(map));
        return vo;
    }

    @Override
    public Tran getTranById(String id) {
        return tranDao.getTranById(id);
    }

    @Override
    public List<TranHistory> allTranHistory(String tranId) {
        return tranHistoryDao.allTranHistory(tranId);
    }

    @Override
    public Map<String, Object> changeStage(Tran tran, HttpServletRequest request) {
        Map<String, Object> map = new HashMap<>();
        User user = (User) request.getSession().getAttribute("user");
        Map<String, String> newMap = (Map<String, String>) request.getServletContext().getAttribute("map");
        map.put("success", false);
        tran.setEditBy(user.getName());
        tran.setEditTime(DateTimeUtil.getSysTime());
        if (tranDao.updateTran(tran) > 0) {
       /*     Tran newTran = tranDao.getTranById(tran.getId());
            String stage = newTran.getStage();
            String possibility = newMap.get(stage);
            newTran.setPossibility(possibility);*/
            String possibility = newMap.get(tran.getStage());
            tran.setPossibility(possibility);
            TranHistory th = new TranHistory();
            th.setId(UUIDUtil.getUUID());
            th.setCreateTime(DateTimeUtil.getSysTime());
            th.setCreateBy(user.getName());
            th.setMoney(tran.getMoney());
            th.setExpectedDate(tran.getExpectedDate());
            th.setTranId(tran.getId());
          /*  th.setStage(newTran.getStage());
            th.setPossibility(newTran.getPossibility());*/
            th.setPossibility(tran.getPossibility());
            th.setStage(tran.getStage());
            tranHistoryDao.insertTranHistory(th);
            /*  map.put("tran", newTran);*/
            map.put("tran", tran);
            map.put("success", true);
        }


        return map;
    }

    @Override
    public List<TranRemark> allTranRemark(String tranId) {
        return tranRemarkDao.allTranRemark(tranId);
    }


    @Override
    public Map<String, Object> saveRemark(TranRemark remark) {
        Map<String, Object> map = new HashMap<>();
        if (tranRemarkDao.saveRemark(remark) > 0) {
            map.put("success", true);
        }
        return map;
    }
}
