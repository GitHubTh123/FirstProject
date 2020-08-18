package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    List<Clue> allClue(Map<String, Object> map);

    int total(Map<String, Object> map);

    int insertClue(Clue clue);

    Clue toEdit(String id);

    int updateClue(Clue clue);

    int deleteClue(String[] arr);
    Clue toDetail(String id );
    int deleteClueById(String id);

}
