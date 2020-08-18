package com.bjpowernode.crm.vo;

import java.util.List;

public class VoForPage<T> {
    private List<T> dataList;
    private int total;

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }
}
