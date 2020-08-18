<%@ page import="java.util.List" %>
<%@ page import="com.bjpowernode.crm.settings.domain.DicValue" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
/*
    List<DicValue> stageList = (List<DicValue>) application.getAttribute("stage");
    Map<String, String> map = (Map<String, String>) application.getAttribute("map");
    int point = 0;
    for (int i = 0; i < stageList.size(); i++) {
        DicValue dicValue = stageList.get(i);
        String stage = dicValue.getValue();
        if ("0".equals(map.get(stage))) {
            point = i;
            break;
        }
    }*/
    List<DicValue> stageList = (List<DicValue>) application.getAttribute("stage");
    Map<String, String> map = (Map<String, String>) application.getAttribute("map");
    int point = 0;
    for (int i = 0; i < stageList.size(); i++) {
        DicValue dicValue = stageList.get(i);
        String stage = dicValue.getValue();
        if ("0".equals(map.get(stage))) {
            point = i;
            break;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>

    <style type="text/css">
        .mystage {
            font-size: 20px;
            vertical-align: middle;
            cursor: pointer;
        }

        .closingDate {
            font-size: 15px;
            cursor: pointer;
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        function deleteTranRemark(id) {
            $("#"+id).remove()

        }

        function tranRemark() {
            $.ajax({
                url: "workbench/transaction/tranRemark.do",
                data: {
                    "tranId": "${t.id}"
                },
                dataType: "json",
                success: function (data) {
                    var html = ""
                    $.each(data, function (i, n) {

                        html += '<div  id="' + n.id + '" class="remarkDiv" style="height: 60px;">'
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                        html += '<div style="position: relative; top: -40px; left: 40px;">'
                        html += '<h5>' + n.noteContent + '</h5>'
                        html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${t.customerId}-${t.name}</b> <small style="color: gray;">  ' + (n.editFlage == 0 ? n.createTime : n.editTime) + ': 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>'
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                        html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"style="font-size: 20px; color: #FF0000;"></span></a>'
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;'
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteTranRemark(\'' + n.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>'
                        html += '</div>'
                        html += '</div>'
                        html += '</div>'
                    })
                    $("#remarkDiv").before(html);

                }
            })
        }

        function history() {

            $.ajax({
                url: "workbench/transaction/allTranHistory.do",
                data: {
                    "tranId": "${t.id}"
                },
                dataType: "json",
                success: function (data) {
                    var html = ""
                    $.each(data, function (i, n) {

                        html += '<tr>'
                        html += '<td>' + n.stage + '</td>'
                        html += '<td>' + n.money + '</td>'
                        html += '<td>' + n.possibility + '</td>'
                        html += '<td>' + n.expectedDate + '</td>'
                        html += '<td>' + n.createTime + '</td>'
                        html += '<td>' + n.createBy + '</td>'
                        html += '</tr>'

                    })
                    $("#historyBody").html(html)

                }
            })
        }

        function changeStage(stage, i) {
            //alert(stage)
            //alert(i)
            $.ajax({
                url: "workbench/transaction/changeStage.do",
                data: {
                    "id": "${t.id}",
                    "money": "${t.money}",
                    "expectedDate": "${t.expectedDate}",
                    "stage": stage
                },
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        $("#editBy").html(data.tran.editBy)
                        $("#editTime").html(data.tran.editTime)
                        $("#stage").html(data.tran.stage)
                        $("#possibility").html(data.tran.possibility)

                        history()
                        changeIcon(stage, i);
                    } else {
                        alert("系统繁忙 ，稍后再试")
                    }

                }
            })
        }

        function changeIcon(stage, i) {
            var currentStage = stage;
            var currentPossibility = $("#possibility").html();
            var index = i;
            var point = "<%=point%>"
            if ("0" == currentPossibility) {
                //七个黑拳
                for (let i = point; i <<%=stageList.size()%>; i++) {
                    if (index == i) {
                        $("#" + i).removeClass()
                        $("#" + i).addClass("glyphicon glyphicon-remove mystage")
                        $("#" + i).css("color", "#FF0000")
                    } else {
                        $("#" + i).removeClass()
                        $("#" + i).addClass("glyphicon glyphicon-remove mystage")
                        $("#" + i).css("color", "#000000")
                    }
                }
                for (let i = 0; i < point; i++) {
                    $("#" + i).removeClass()
                    $("#" + i).addClass("glyphicon glyphicon-record mystage")
                    $("#" + i).css("color", "#000000")
                }
            } else {
                for (let i = point; i <<%=stageList.size()%>; i++) {
                    $("#" + i).removeClass()
                    $("#" + i).addClass("glyphicon glyphicon-remove mystage")
                    $("#" + i).css("color", "#000000")
                }
                for (let i = 0; i < point; i++) {
                    if (i == index) {
                        $("#" + i).removeClass()
                        $("#" + i).addClass("glyphicon glyphicon-map-marker mystage")
                        $("#" + i).css("color", "#90F790")
                    }
                    if (i > index) {
                        $("#" + i).removeClass()
                        $("#" + i).addClass("glyphicon glyphicon-record mystage")
                        $("#" + i).css("color", "#000000")
                    }
                    if (i < index) {
                        $("#" + i).removeClass()
                        $("#" + i).addClass("glyphicon glyphicon-ok-circle mystage")
                        $("#" + i).css("color", "#90F790")
                    }
                }
            }


        }

        $(function () {
            $("#save-remark").click(function () {
                $.ajax({
                    url: "workbench/transaction/saveRemark.do",
                    data: {
                        "tranId": "${t.id}",
                        "noteContent": $.trim($("#remark").val())
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            var html = ""


                            html += '<div  id="' + data.r.id + '" class="remarkDiv" style="height: 60px;">'
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                            html += '<div style="position: relative; top: -40px; left: 40px;">'
                            html += '<h5>' + data.r.noteContent + '</h5>'
                            html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${t.customerId}-${t.name}</b> <small style="color: gray;">  ' + (data.r.editFlage == 0 ? data.r.createTime : data.r.editTime) + ': 由' + (data.r.editFlag == 0 ? data.r.createBy : data.r.editBy) + '</small>'
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                            html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"style="font-size: 20px; color:  #FF0000;"></span></a>'
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;'
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteTranRemark(\'' + data.r.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color:  #FF0000;"></span></a>'
                            html += '</div>'
                            html += '</div>'
                            html += '</div>'


                            $("#remarkDiv").before(html);
                            $("#remark").val("")
                        } else {
                            alert("系统繁忙 稍后再试")
                        }


                    }
                })
            })

            history()
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });
            $("#remarkBody").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            })
            $("#remarkBody").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })
            tranRemark()


            //阶段提示框
            $(".mystage").popover({
                trigger: 'manual',
                placement: 'bottom',
                html: 'true',
                animation: false
            }).on("mouseenter", function () {
                var _this = this;
                $(this).popover("show");
                $(this).siblings(".popover").on("mouseleave", function () {
                    $(_this).popover('hide');
                });
            }).on("mouseleave", function () {
                var _this = this;
                setTimeout(function () {
                    if (!$(".popover:hover").length) {
                        $(_this).popover("hide")
                    }
                }, 100);
            });
        });


    </script>

</head>
<body>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${t.customerId}-${t.name} <small>￥${t.money}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 阶段状态 -->
<div style="position: relative; left: 40px; top: -50px;">
    阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

    <%
        Tran t = (Tran) request.getAttribute("t");
        String currentStage = t.getStage();
        String currentPossibility = map.get(currentStage);
        if ("0".equals(currentPossibility)) {
            for (int i = 0; i < stageList.size(); i++) {
                DicValue dicValue = stageList.get(i);
                String stage = dicValue.getValue();
                String possibility = map.get(stage);
                if ("0".equals(possibility)) {
                    if (stage.equals(currentStage)) {

                        //红叉
    %>
    <span class="glyphicon glyphicon-remove mystage" id="<%=i%>" style="color:red;"
          onclick="changeStage('<%=stage%>','<%=i%>')"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>"></span>
    -----------
    <%
    } else {

        //黑 %>
    <span class="glyphicon glyphicon-remove mystage" id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
          style="color:black;"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>"></span>
    -----------
    <%
        }
    } else {
        //黑圈
    %>
    <span class="glyphicon glyphicon-record mystage" id="<%=i%>" style="color:black;"
          onclick="changeStage('<%=stage%>','<%=i%>')"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>"></span>
    -----------
    <%
            }
        }
    }

    //如果当前阶段不是后两个阶段 后两个阶段全为黒×   前面7个 三种可能
    else {

        //先取分界点坐标
        int index = 0;
        for (int i = 0; i < stageList.size(); i++) {
            DicValue dicValue = stageList.get(i);
            String stage = dicValue.getValue();

            if (stage.equals(currentStage)) {
                index = i;
                break;
            }
        }

        for (int i = 0; i < stageList.size(); i++) {
            DicValue dicValue = stageList.get(i);
            String stage = dicValue.getValue();
            String possibility = map.get(stage);
            if ("0".equals(possibility)) {
                //黒×
    %>
    <span class="glyphicon glyphicon-remove mystage" id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
          style="color:black;"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>"></span>
    -----------
    <%
    } else {
        if (i == index) {
            //绿标
    %>
    <span class="glyphicon glyphicon-map-marker mystage" id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
          style="color: #90F790;" data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>"></span>
    -----------
    <%
    } else if (i < index) {
        //绿圈
    %>
    <span class="glyphicon glyphicon-ok-circle mystage" id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
          style="color: #90F790;" data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>"></span>
    -----------
    <% } else {
        //黑圈
    %>
    <span class="glyphicon glyphicon-record mystage" style="color:black;" id="<%=i%>"
          onclick="changeStage('<%=stage%>','<%=i%>')"
          data-toggle="popover" data-placement="bottom"
          data-content="<%=dicValue.getText()%>"></span>
    -----------

    <%
                    }
                }
            }
        }

    %>
    <%--     <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
               data-content="资质审查" style="color: #90F790;"></span>
         -----------
         <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
               data-content="需求分析" style="color: #90F790;"></span>
         -----------
         <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
               data-content="价值建议" style="color: #90F790;"></span>
         -----------
         <span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom"
               data-content="确定决策者" style="color: #90F790;"></span>
         -----------
         <span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom"
               data-content="提案/报价" style="color: #90F790;"></span>
         -----------
         <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
               data-content="谈判/复审"></span>
         -----------
         <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
               data-content="成交"></span>
         -----------
         <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
               data-content="丢失的线索"></span>
         -----------
         <span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom"
               data-content="因竞争丢失关闭"></span>
         -------------%>
    <span class="closingDate">${t.expectedDate}</span>


</div>

<!-- 详细信息 -->
<div style="position: relative; top: 0px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.money}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerId}-${t.name}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.expectedDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">客户名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerId}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${t.stage}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">类型</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.type}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${t.possibility}</b>
        </div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">来源</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.activityId}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">联系人名称</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.contactsId}</b></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${t.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b
                id="editBy">${t.editBy}&nbsp;&nbsp;</b> <small id="editTime"
                                                               style="font-size: 10px; color: gray;">${t.editTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${t.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                &nbsp;${t.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${t.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 100px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <%--    <!-- 备注1 -->
        <div class="remarkDiv" style="height: 60px;">
            <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>哎呦！</h5>
                <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;">
                2017-01-22 10:10:10 由zhangsan</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>

        <!-- 备注2 -->
        <div class="remarkDiv" style="height: 60px;">
            <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;">
                <h5>呵呵！</h5>
                <font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;">
                2017-01-22 10:20:10 由zhangsan</small>

                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>

                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                       style="font-size: 20px; color: #E6E6E6;"></span></a>

                </div>
            </div>
        </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="save-remark">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 阶段历史 -->
<div>
    <div style="position: relative; top: 100px; left: 40px;">
        <div class="page-header">
            <h4>阶段历史</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table id="activityTable" class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>阶段</td>
                    <td>金额</td>
                    <td>可能性</td>
                    <td>预计成交日期</td>
                    <td>创建时间</td>
                    <td>创建人</td>
                </tr>
                </thead>
                <tbody id="historyBody">
                <tr>
                    <td>资质审查</td>
                    <td>5,000</td>
                    <td>10</td>
                    <td>2017-02-07</td>
                    <td>2016-10-10 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>需求分析</td>
                    <td>5,000</td>
                    <td>20</td>
                    <td>2017-02-07</td>
                    <td>2016-10-20 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                <tr>
                    <td>谈判/复审</td>
                    <td>5,000</td>
                    <td>90</td>
                    <td>2017-02-07</td>
                    <td>2017-02-09 10:10:10</td>
                    <td>zhangsan</td>
                </tr>
                </tbody>
            </table>
        </div>

    </div>
</div>

<div style="height: 200px;"></div>

</body>
</html>