package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.domain.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

public interface TranService {
    List<User> allUser();

    List<String> getCustomerName(String name);

    List<Activity> searchActivity(String name);

    List<Contacts> searchContacts(String name);

    String saveTran(Tran tran, String customerName, HttpSession session) throws Exception;

    VoForPage pageList(Map<String, Object> map);
    Tran getTranById(String id);

    List<TranHistory> allTranHistory(String tranId);

    Map<String, Object> changeStage(Tran tran, HttpServletRequest request);

    List<TranRemark> allTranRemark(String tranId);


    Map<String,Object> saveRemark(TranRemark remark);
}
