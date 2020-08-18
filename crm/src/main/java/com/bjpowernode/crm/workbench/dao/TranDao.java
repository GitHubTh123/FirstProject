package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {
int insertTran(Tran tran);
List<Tran> allTran(Map<String,Object> map);
 int total(Map<String,Object> map);
 Tran getTranById(String id);
 int updateTran(Tran tran);
}
