package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.domain.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

public interface ClueService {
    VoForPage page(Map<String, Object> map);

    List<User> allUser();

    Map<String, Object> insertClue(Clue clue);

    Map<String, Object> updateClue(Clue clue);

    Map<String, Object> deleteClue(String[] arr);

    Map<String, Object> deleteClueRemark(String id);

    Map<String, Object> insertClueRemark(ClueRemark clueRemark);
    Map<String, Object> insertcar(List<ClueActivityRelation> list);
    Map<String, Object> deletecar(String id);

    Clue toEdit(String id);

    Clue toDetail(String id);

    List<ClueRemark> getClueRemarkByClueId(String clueId);
    List<Activity> relationActivityClue(String clueId);
    List<Activity> getActivityByName(String clueId,String name);

    Clue getClueById(String id);
    List<Activity> searchActivity(String name);

    Boolean transform(Tran tran, String clueId, String flag, HttpSession session) throws Exception;
}
