package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.PropertiesUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private TranDao tranDao;
    @Resource
    private ContactsActivityRelationDao activityRelationDao;
    @Resource
    private ClueDao clueDao;
    @Resource
    private UserDao userDao;
    @Resource
    private ClueRemarkDao clueRemarkDao;
    @Resource
    private ActivityDao activityDao;
    @Resource
    private ClueActivityRelationDao relationDao;
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private TranHistoryDao tranHistoryDao;

    @Override
    public VoForPage page(Map<String, Object> map) {
        VoForPage vo = new VoForPage();
        vo.setTotal(clueDao.total(map));
        vo.setDataList(clueDao.allClue(map));
        return vo;
    }

    @Override
    public List<User> allUser() {
        return userDao.allUser();
    }

    @Override
    public Map<String, Object> insertClue(Clue clue) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (clueDao.insertClue(clue) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Map<String, Object> updateClue(Clue clue) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (clueDao.updateClue(clue) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Map<String, Object> deleteClue(String[] arr) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (clueDao.deleteClue(arr) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Map<String, Object> deleteClueRemark(String id) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (clueRemarkDao.deleteClueRemark(id) > 0) {
            map.put("success", true);
        }
        return map;
    }

    @Override
    public Map<String, Object> insertClueRemark(ClueRemark clueRemark) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (clueRemarkDao.insertClueRemark(clueRemark) > 0) {
            map.put("success", true);
        }
        map.put("c", clueRemark);
        return map;
    }

    @Override
    public Map<String, Object> insertcar(List<ClueActivityRelation> list) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (relationDao.insertcar(list) > 0) {
            map.put("success", true);
        }

        return map;
    }

    @Override
    public Map<String, Object> deletecar(String id) {
        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        if (relationDao.deletecar(id) > 0) {
            map.put("success", true);
        }

        return map;
    }


    @Override
    public Clue toEdit(String id) {
        return clueDao.toEdit(id);
    }

    @Override
    public Clue toDetail(String id) {
        return clueDao.toDetail(id);
    }

    @Override
    public List<ClueRemark> getClueRemarkByClueId(String clueId) {
        return clueRemarkDao.getClueRemark(clueId);
    }

    @Override
    public List<Activity> relationActivityClue(String clueId) {
        return activityDao.relationActivityClue(clueId);
    }

    @Override
    public List<Activity> getActivityByName(String clueId, String name) {
        return activityDao.getActivityByName(clueId, name);
    }

    @Override
    public Clue getClueById(String id) {
        return clueDao.toDetail(id);
    }

    @Override
    public List<Activity> searchActivity(String name) {
        return activityDao.searchActivity(name);
    }

    @Override
    public Boolean transform(Tran tran, String clueId, String flag, HttpSession session) throws Exception {
        boolean b = true;
        Clue clue = clueDao.toEdit(clueId);
        String company = clue.getCompany();
        Customer customer = customerDao.getCustomerByName(company);
        User user = (User) session.getAttribute("user");
        if (customer == null) {
            customer=new Customer();
            PropertiesUtil.sets(customer, session);
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setOwner(clue.getOwner());
            customer.setDescription(clue.getDescription());
            customer.setContactSummary(clue.getContactSummary());
            customer.setAddress(clue.getAddress());
            customer.setName(company);
            int i = customerDao.insertCustomer(customer);
            if (i < 1) {
                b = false;
            }

        }

        Contacts contacts = new Contacts();
        PropertiesUtil.sets(contacts, session);
        contacts.setCustomerId(customer.getId());
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setJob(clue.getJob());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        int i = contactsDao.insertContacts(contacts);
        if (i < 1) {
            b = false;
        }
        List<ClueRemark> clueRemark = clueRemarkDao.getClueRemark(clueId);
        if (clueRemark != null && clueRemark.size() > 0) {
            List<CustomerRemark> customerRemarks = new ArrayList<>();
            for (ClueRemark c : clueRemark
            ) {
                CustomerRemark customerRemark = new CustomerRemark();
                PropertiesUtil.sets(customerRemark, session);
                customerRemark.setEditFlag("0");
                customerRemark.setNoteContent(c.getNoteContent());
                customerRemark.setCustomerId(customer.getId());
                customerRemarks.add(customerRemark);
            }
            if (customerRemarkDao.insertCustomerRemark(customerRemarks) < 0) {
                b = false;
            }

            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            for (ClueRemark c : clueRemark
            ) {
                ContactsRemark remark = new ContactsRemark();
                PropertiesUtil.sets(remark, session);
                remark.setEditFlag("0");
                remark.setContactsId(contacts.getId());
                remark.setNoteContent(c.getNoteContent());
                contactsRemarkList.add(remark);


            }
            if (contactsRemarkDao.insertContactsRemark(contactsRemarkList) < 0) {
                b = false;
            }
        }


        String[] activityId = relationDao.getActivityId(clueId);
        if (activityId != null & activityId.length > 0) {
            List<ContactsActivityRelation> relationList = new ArrayList<>();
            for (String id : activityId
            ) {
                ContactsActivityRelation relation = new ContactsActivityRelation();
                relation.setId(UUIDUtil.getUUID());
                relation.setActivityId(id);
                relation.setContactsId(contacts.getId());
                relationList.add(relation);
            }
            if (activityRelationDao.add(relationList) < 0) {
                b = false;
            }
        }

        if ("a".equals(flag)) {

            PropertiesUtil.sets(tran, session);
            tran.setContactsId(contacts.getId());
            tran.setCustomerId(customer.getId());
            tran.setOwner(user.getId());
            int s = tranDao.insertTran(tran);
            TranHistory tranHistory = new TranHistory();
            PropertiesUtil.sets(tranHistory, session);
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setTranId(tran.getId());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            int j = tranHistoryDao.insertTranHistory(tranHistory);
            if (j < 0 || s < 0) {
                b = false;
            }
        }
        clueRemarkDao.deleteClueRemarkByClueId(clueId);
        relationDao.deletecarByClueId(clueId);
        clueDao.deleteClueById(clueId);
        return b;
    }


}
