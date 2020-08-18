package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkDao {

    List<TranRemark> allTranRemark(String tranId);

    int saveRemark(TranRemark remark);
}
