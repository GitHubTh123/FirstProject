package com.bjpowernode.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/file")
public class FileController {

    @RequestMapping("toMain.do")
    public String toMain() {
        return "workbench/main/index";
    }

    @RequestMapping("toTransaction.do")
    public String toTransaction() {
        return "workbench/transaction/index";
    }

    @RequestMapping("toContacts.do")
    public String toContacts() {
        return "workbench/contacts/index";
    }

    @RequestMapping("toCustomer.do")
    public String toCustomer() {
        return "workbench/customer/index";
    }

    @RequestMapping("toClue.do")
    public String toClue() {
        return "workbench/clue/index";
    }

    @RequestMapping("toActivity.do")
    public String toActivity() {
        return "workbench/activity/index";
    }

    @RequestMapping("/trIndex.do")
    public String trIndex() {
        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/caIndex.do")
    public String caIndex() {
        return "workbench/chart/customerAndContacts/index";
    }

    @RequestMapping("/clIndex.do")
    public String clIndex() {
        return "workbench/chart/clue/index";
    }

    @RequestMapping("/actIndex.do")
    public String actIndex() {
        return "workbench/chart/activity/index";
    }

    @RequestMapping("/toSettings.do")
    public String toSettings() {
        return "settings/index";
    }

    @RequestMapping("/toDictionary.do")
    public String toDictionary() {
        return "settings/dictionary/index";
    }

    @RequestMapping("/toType.do")
    public String toType() {
        return "settings/dictionary/type/index";
    }

    @RequestMapping("/toValue.do")
    public String toValue() {
        return "settings/dictionary/value/index";
    }

    @RequestMapping("/toSaveValue.do")
    public String toSaveValue() {
        return "settings/dictionary/value/save";
    }

    @RequestMapping("/toEditValue.do")
    public String toEditValue() {
        return "settings/dictionary/value/edit";
    }

    @RequestMapping("/toSaveType.do")
    public String toSaveType() {
        return "settings/dictionary/type/save";
    }
    @RequestMapping("/toEditType.do")
    public String toEditType() {
        return "settings/dictionary/type/edit";
    }

}
