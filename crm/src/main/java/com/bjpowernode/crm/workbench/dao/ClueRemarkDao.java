package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
List<ClueRemark> getClueRemark(String clueId);
int deleteClueRemark(String id );
int insertClueRemark(ClueRemark clueRemark);
int deleteClueRemarkByClueId(String clueId);
}
