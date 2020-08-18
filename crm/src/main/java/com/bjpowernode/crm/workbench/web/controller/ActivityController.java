package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PropertiesUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.VoForPage;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/activity")
public class ActivityController {
    @Resource
    private ActivityService service;

    @ResponseBody
    @RequestMapping("allActivity.do")
    public VoForPage allActivity(String name, String owner, String endDate, String startDate, Integer pageSize, Integer pageNo) {
        Integer skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("pageSize", pageSize);
        map.put("skipCount", skipCount);
        return service.allActivity(map);

    }

    @RequestMapping("/allUser.do")
    @ResponseBody
    public List<User> allUser() {
        return service.allUser();
    }

    @ResponseBody
    @RequestMapping("/save.do")
    public Map<String, Object> save(Activity activity, HttpSession session) throws Exception{
        /*activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateTimeUtil.getSysTime());*/
        PropertiesUtil.sets(activity, session);
        return service.insert(activity);
    }

    @RequestMapping("/update.do")
    @ResponseBody
    public Map<String, Object> update(Activity activity, HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute("user");
        activity.setEditTime(DateTimeUtil.getSysTime());
        activity.setEditBy(user.getName());

        return service.update(activity);
    }

    @ResponseBody
    @RequestMapping("/toEdit.do")
    public Activity toEdit(String id) {
        return service.toEdit(id);
    }


    @RequestMapping("/delete.do")
    @ResponseBody
    public Map<String, Object> delete(String[] arr) {
        return service.delete(arr);
    }

    @RequestMapping("/downloadAdvice.do")
    public void downloadAdvice(HttpServletResponse response) throws Exception {
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("市场活动详细页");
        HSSFRow row = sheet.createRow(0);


        HSSFCell cell0 = row.createCell(0);
        HSSFCell cell1 = row.createCell(1);
        HSSFCell cell2 = row.createCell(2);
        HSSFCell cell3 = row.createCell(3);
        HSSFCell cell4 = row.createCell(4);
        HSSFCell cell5 = row.createCell(5);
        HSSFCell cell6 = row.createCell(6);
        HSSFCell cell7 = row.createCell(7);
        HSSFCell cell8 = row.createCell(8);
        HSSFCell cell9 = row.createCell(9);
        HSSFCell cell10 = row.createCell(10);


        cell0.setCellValue("主键");
        cell1.setCellValue("所有者");
        cell2.setCellValue("活动名称");
        cell3.setCellValue("开始时期");
        cell4.setCellValue("结束日期");
        cell5.setCellValue("创建人");
        cell6.setCellValue("创建时间");
        cell7.setCellValue("修改人");
        cell8.setCellValue("修改时间");
        cell9.setCellValue("成本");
        cell10.setCellValue("描述");


        List<Activity> list = service.downloadAdvice();
        for (int i = 0; i < list.size(); i++) {
            Activity ac = list.get(i);
            row = sheet.createRow(i + 1);

            cell0 = row.createCell(0);
            cell1 = row.createCell(1);
            cell2 = row.createCell(2);
            cell3 = row.createCell(3);
            cell4 = row.createCell(4);
            cell5 = row.createCell(5);
            cell6 = row.createCell(6);
            cell7 = row.createCell(7);
            cell8 = row.createCell(8);
            cell9 = row.createCell(9);
            cell10 = row.createCell(10);


            cell0.setCellValue(ac.getId());
            cell1.setCellValue(ac.getOwner());
            cell2.setCellValue(ac.getName());
            cell3.setCellValue(ac.getStartDate());
            cell4.setCellValue(ac.getEndDate());
            cell5.setCellValue(ac.getCreateBy());
            cell6.setCellValue(ac.getCreateTime());
            cell7.setCellValue(ac.getEditBy());
            cell8.setCellValue(ac.getEditTime());
            cell9.setCellValue(ac.getCost());
            cell10.setCellValue(ac.getDescription());
        }
        response.setContentType("octets/stream");
        response.setHeader("Content-Disposition", "attachment;filename=Activity-" + DateTimeUtil.getSysTime() + ".xls");

        OutputStream out = response.getOutputStream();

        workbook.write(out);

    }


    @RequestMapping("/download.do")
    public void download(String[] arr, HttpServletResponse response) throws Exception {

        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("市场活动详细页");
        HSSFRow row = sheet.createRow(0);


        HSSFCell cell0 = row.createCell(0);
        HSSFCell cell1 = row.createCell(1);
        HSSFCell cell2 = row.createCell(2);
        HSSFCell cell3 = row.createCell(3);
        HSSFCell cell4 = row.createCell(4);
        HSSFCell cell5 = row.createCell(5);
        HSSFCell cell6 = row.createCell(6);
        HSSFCell cell7 = row.createCell(7);
        HSSFCell cell8 = row.createCell(8);
        HSSFCell cell9 = row.createCell(9);
        HSSFCell cell10 = row.createCell(10);


        cell0.setCellValue("主键");
        cell1.setCellValue("所有者");
        cell2.setCellValue("活动名称");
        cell3.setCellValue("开始时期");
        cell4.setCellValue("结束日期");
        cell5.setCellValue("创建人");
        cell6.setCellValue("创建时间");
        cell7.setCellValue("修改人");
        cell8.setCellValue("修改时间");
        cell9.setCellValue("成本");
        cell10.setCellValue("描述");


        List<Activity> list = service.download(arr);
        for (int i = 0; i < list.size(); i++) {
            Activity ac = list.get(i);
            row = sheet.createRow(i + 1);

            cell0 = row.createCell(0);
            cell1 = row.createCell(1);
            cell2 = row.createCell(2);
            cell3 = row.createCell(3);
            cell4 = row.createCell(4);
            cell5 = row.createCell(5);
            cell6 = row.createCell(6);
            cell7 = row.createCell(7);
            cell8 = row.createCell(8);
            cell9 = row.createCell(9);
            cell10 = row.createCell(10);


            cell0.setCellValue(ac.getId());
            cell1.setCellValue(ac.getOwner());
            cell2.setCellValue(ac.getName());
            cell3.setCellValue(ac.getStartDate());
            cell4.setCellValue(ac.getEndDate());
            cell5.setCellValue(ac.getCreateBy());
            cell6.setCellValue(ac.getCreateTime());
            cell7.setCellValue(ac.getEditBy());
            cell8.setCellValue(ac.getEditTime());
            cell9.setCellValue(ac.getCost());
            cell10.setCellValue(ac.getDescription());
        }
        response.setContentType("octets/stream");
        response.setHeader("Content-Disposition", "attachment;filename=Activity-" + DateTimeUtil.getSysTime() + ".xls");

        OutputStream out = response.getOutputStream();

        workbook.write(out);

    }

    @RequestMapping("/upload.do")
    @ResponseBody
    public Map<String, Object> upload(@RequestParam("uploadFile") MultipartFile file, HttpServletRequest request) throws Exception {



        List<Activity> list = new ArrayList<>();
        String path = request.getServletContext().getRealPath("tempDir");
        //定义一个文件名
        String fileName = DateTimeUtil.getSysTimeForUpload() + "xls";
        file.transferTo(new File(path + "/" + fileName));
        InputStream inputStream = new FileInputStream(path + "/" + fileName);
        HSSFWorkbook workbook = new HSSFWorkbook(inputStream);
        HSSFSheet sheetAt = workbook.getSheetAt(0);


        for (int i = 1; i < sheetAt.getLastRowNum() + 1; i++) {
            Activity activity = new Activity();
            HSSFRow row = sheetAt.getRow(i);
            for (int j = 0; j < row.getLastCellNum(); j++) {
                HSSFCell cell = row.getCell(j);
                if (j == 0) {
                    System.out.println(cell);
                    System.out.println(activity);
                    activity.setId(cell.getStringCellValue());
                } else if (j == 1) {
                    activity.setOwner(cell.getStringCellValue());
                } else if (j == 2) {
                    activity.setName(cell.getStringCellValue());
                } else if (j == 3) {
                    activity.setStartDate(cell.getStringCellValue());
                } else if (j == 4) {
                    activity.setEndDate(cell.getStringCellValue());
                } else if (j == 5) {
                    activity.setCreateBy(cell.getStringCellValue());
                } else if (j == 6) {
                    activity.setCreateTime(cell.getStringCellValue());
                } else if (j == 7) {
                    activity.setEditBy(cell.getStringCellValue());
                } else if (j == 8) {
                    activity.setEditTime(cell.getStringCellValue());
                } else if (j == 9) {
                    activity.setCost(cell.getStringCellValue());
                } else if (j == 10) {
                    activity.setDescription(cell.getStringCellValue());
                }
            }
            list.add(activity);
        }

        return service.addSome(list);
    }

    @RequestMapping("/toDetail.do")
    public ModelAndView toDetail(String id){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("workbench/activity/detail");
        Activity activity = service.toDetail(id);
        mv.addObject("activity",activity);
        return mv;
    }
}