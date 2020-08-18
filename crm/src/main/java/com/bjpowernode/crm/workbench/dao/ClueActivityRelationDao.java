package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {
int insertcar(List<ClueActivityRelation> list);
int deletecar(String id);
String[] getActivityId(String clueId);
int deletecarByClueId(String clueId);
}
