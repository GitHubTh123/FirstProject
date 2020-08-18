package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {
    int insertTranHistory(TranHistory tranHistory);

    List<TranHistory> allTranHistory(String tranId);
}
