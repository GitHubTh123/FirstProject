<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        function init() {
            $.ajax({
                url: "activityremark/all.do",
                data: {
                    "id": "${activity.id}"
                },
                dataType: "json",
                success: function (data) {
                    var html = ""
                    $.each(data, function (i, n) {

                        html += '<div class="remarkDiv"id="' + n.id + '" style="height: 60px;">'
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                        html += '<div style="position: relative; top: -40px; left: 40px;" >'
                        html += '<h5 id="h' + n.id + '">' + n.noteContent + '</h5>'
                        html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id=s'+n.id+'> ' + (n.editFlag == 0 ? n.createTime : n.editTime) + ' 由' + (n.editFlag == 0 ? n.createBy : n.editBy) + '</small>'
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                        html += '<a class="myHref" href="javascript:void(0);" onclick="edit(\'' + n.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>'
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;'
                        html += '<a class="myHref" onclick="deleteAct(\'' + n.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>'
                        html += '</div>'
                        html += '</div>'
                        html += '</div>'


                    })
                    $("#remarkDiv").before(html)

                }
            })
        }

        function edit(id) {
            $("#noteContent").val($("#h" + id).html());
            $("#key").val(id)
            $("#editRemarkModal").modal("show")


        }

        function deleteAct(id) {
            $.ajax({
                url: "activityremark/delete.do",
                data: {

                    "id": id
                },
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        $("#" + id).remove()
                    }

                }
            })
        }

        $(function () {


            $("#save").click(function () {
                $.ajax({
                    url: "activityremark/save.do",
                    data: {
                        "activityId": "${activity.id}",
                        "noteContent": $("#remark").val()
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            var html = "";
                            html += '<div class="remarkDiv"id="' + data.ac.id + '" style="height: 60px;">'
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
                            html += '<div style="position: relative; top: -40px; left: 40px;" >'
                            html += '<h5 id="h"+' + data.ac.id + '>' + data.ac.noteContent + '</h5>'
                            html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"id=s'+data.ac.id+'> ' + data.ac.createTime + ' 由' + data.ac.createBy + '</small>'
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
                            html += '<a class="myHref" href="javascript:void(0);" onclick="edit(\'' + data.ac.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>'
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;'
                            html += '<a class="myHref" onclick="deleteAct(\'' + data.ac.id + '\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>'
                            html += '</div>'
                            html += '</div>'
                            html += '</div>'
                            $("#remarkDiv").before(html)
                            $("#remark").val("")

                        } else {
                            alert("系统繁忙 稍后再试")
                        }

                    }
                })

            })
            $("#updateRemarkBtn").click(function () {
            var id =$("#key").val();
            $.ajax({
                url:"activityremark/update.do",
                data:{
                    "id":id,
                    "noteContent":$("#noteContent").val()
                },
                dataType:"json",
                success:function (data) {
                    if(data.success){
                        $("#h"+id).html(data.ac.noteContent);
                        $("#s"+id).html(
                            data.ac.editTime+"由"+data.ac.editBy
                        )
                        $("#editRemarkModal").modal("hide")
                    }else{
                        alert("系统繁忙稍后再试")
                    }

                }
            })
            })

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

            init()
        });

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            <input type="hidden" id="key">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${activity.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;">
            <b>${activity.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${activity.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <%--		<!-- 备注1 -->
            <div class="remarkDiv" style="height: 60px;">
                <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
                <div style="position: relative; top: -40px; left: 40px;" >
                    <h5>哎呦！</h5>
                    <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
                    <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                        <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    </div>
                </div>
            </div>

            <!-- 备注2 -->
            <div class="remarkDiv" style="height: 60px;">
                <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
                <div style="position: relative; top: -40px; left: 40px;" >
                    <h5>呵呵！</h5>
                    <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
                    <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                        <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    </div>
                </div>
            </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="save">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>