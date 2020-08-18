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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript">
        $.fn.datetimepicker.dates['zh-CN'] = {
            days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
            daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
            daysMin: ["日", "一", "二", "三", "四", "五", "六", "日"],
            months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            today: "今天",
            suffix: [],
            meridiem: ["上午", "下午"]
        };
        var rsc_bs_pag = {
            go_to_page_title: 'Go to page',
            rows_per_page_title: 'Rows per page',
            current_page_label: 'Page',
            current_page_abbr_label: 'p.',
            total_pages_label: 'of',
            total_pages_abbr_label: '/',
            total_rows_label: 'of',
            rows_info_records: 'records',
            go_top_text: '首页',
            go_prev_text: '上一页',
            go_next_text: '下一页',
            go_last_text: '末页'
        };
        $(".time").datetimepicker({
            minView: "month",
            language: 'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "bottom-left"
        });

function toDetail(id) {
window.location.href="activity/toDetail.do?id="+id;

}
        function pageList(pageNo, pageSize) {
            $("#search-owner").val($.trim($("#hidden-owner").val()))
            $("#search-name").val($.trim($("#hidden-name").val()))
            $("#search-startTime").val($.trim($("#hidden-startDate").val()))
            $("#search-endTime").val($.trim($("#hidden-endDate").val()))
            $.ajax({
                url: "activity/allActivity.do",
                dataType: "json",
                data: {
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startTime").val()),
                    "endDate": $.trim($("#search-endTime").val()),
                    "pageNo": pageNo,
                    "pageSize": pageSize
                },
                success: function (data) {
                    var html = "";
                    $.each(data.dataList, function (i, n) {
                        html += "<tr>"
                        html += "<td><input type='checkbox' name='flag' value='" + n.id + "'/></td>"
                        html += "<td><a href='javascript:void(0)' onclick='toDetail(\""+n.id+"\")' >" + n.name + "</a></td>"
                        html += "<td>" + n.owner + "</td>"
                        html += "<td>" + n.startDate + "</td>"
                        html += "<td>" + n.endDate + "</td>"
                        html += "</tr>"

                    })
                    $("#tb").html(html);
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        /*

                        该回调函数，是用来做分页操作的
                        触发的时机是在我们几点分页组件（点击首页尾页上一页下一页...）的时候
                        方法中的参数：
                                            data是分页插件自己提供的（不是我们ajax的data）
                                            data.currentPage：指定当前的页码
                        data.rowsPerPage：指定当前的每页展现记录数

                        */
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });


                }
            })

        }

        $(function () {
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            $("#ck").prop("checked", false)

            pageList(1, 2)
            $("#search").click(function () {
                $("#hidden-endDate").val($.trim($("#search-endTime").val()))
                $("#hidden-startDate").val($.trim($("#search-startTime").val()))
                $("#hidden-name").val($.trim($("#search-name").val()))
                $("#hidden-owner").val($.trim($("#search-owner").val()))
                pageList(1, 2)
            })
            $("#ck").click(function () {
                $("input[name=flag]").prop("checked", this.checked);
            })
            $("#tb").on("click", $("input[name=flag]"), function () {
                $("#ck").prop("checked", $("input[name=flag]").length == $("input[name=flag]:checked").length)
            })

            //为添加按钮绑定事件
            $("#create").click(function () {

                $.ajax({
                    url: "activity/allUser.do",
                    dataType: "json",
                    success: function (data) {
                        var html = "";
                        $.each(data, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>"

                        })
                        $("#create-marketActivityOwner").html(html)
                        $("#create-marketActivityOwner").val("${user.id}")
                        $("#createActivityModal").modal("show")
                    }
                })
            })


            $("#save").click(function () {
                $.ajax({
                    url: "activity/save.do",
                    data: {
                        "name": $.trim($("#create-marketActivityName").val()),
                        "owner": $.trim($("#create-marketActivityOwner").val()),
                        "startDate": $.trim($("#create-startTime").val()),
                        "endDate": $.trim($("#create-endTime").val()),
                        "cost": $.trim($("#create-cost").val()),
                        "description": $.trim($("#create-describe").val()),
                       /* "createBy": "${user.name}"*/
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert("系统繁忙 稍后再试")
                        }

                    }
                })
            })
            $("#edit").click(function () {
                var s = $("input[name=flag]:checked");
                if (s.length > 1) {
                    alert("最多选择一条记录进行编辑")
                } else if (s.length < 1) {
                    alert("选择想要修改的记录")
                } else {
                    $.ajax({
                        url: "activity/toEdit.do",
                        data: {"id": s.val()},
                        dataType: "json",
                        success: function (data) {
                            $.ajax({
                                url: "activity/allUser.do",
                                dataType: "json",
                                success: function (data1) {
                                    var html = "";
                                    $.each(data1, function (i, n) {
                                        html += "<option value='" + n.id + "'>" + n.name + "</option>"

                                    })
                                    $("#edit-marketActivityOwner").html(html)
                                    $("#edit-marketActivityOwner").val(data.owner)
                                }
                            })
                            $("#edit-endTime").val(data.endDate)
                            $("#edit-startTime").val(data.startDate)
                            $("#edit-marketActivityName").val(data.name)
                            $("#edit-cost").val(data.cost)
                            $("#edit-describe").val(data.description)
                            $("#key").val(data.id)
                            $("#editActivityModal").modal("show")

                        }

                    })
                }
            })
            $("#update").click(function () {
                $.ajax({
                    url: "activity/update.do",
                    data: {
                        "name": $.trim($("#edit-marketActivityName").val()),
                        "owner": $.trim($("#edit-marketActivityOwner").val()),
                        "startDate": $.trim($("#edit-startTime").val()),
                        "endDate": $.trim($("#edit-endTime").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-describe").val()),
                        "id": $("#key").val()
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            $("#editActivityModal").modal("hide");
                        } else {
                            alert("系统繁忙 稍后再试")
                        }
                    }
                })
            })


            $("#delete").click(function () {
                var s = $("input[name=flag]:checked")
                if (s.length < 1) {
                    alert("请选择想要删除的记录")
                    return false;
                }
                var arr = new Array(s.length)
                for (let i = 0; i < arr.length; i++) {
                    arr[i] = s[i].value
                }
                $.ajax({
                    url: "activity/delete.do",
                    data: {
                        "arr": arr
                    },
                    traditional: true,
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            alert("系统繁忙 稍后再试")
                        }
                    }
                })

            })


            $("#exportActivityAllBtn").click(function () {
                window.location.href = "activity/downloadAdvice.do";
            })
            $("#exportActivityXzBtn").click(function () {
                var s = $("input[name=flag]:checked")
                if (s.length < 1) {
                    alert("请选择想要导出的记录")
                    return false;
                }
                var arr = new Array(s.length)
                for (let i = 0; i < arr.length; i++) {
                    arr[i] = s[i].value
                }
                window.location.href = "activity/download.do?arr=" + arr
            })


            $("#importActivityBtn").click(function () {
                var file = $("#activityFile").val();
                var fileName = file.substr(file.lastIndexOf(".") + 1);
                if (!("xls"==fileName || "xlsx"==fileName)) {
                alert("不是excel文件")
                    return false;
                }
                var upload = $("#activityFile")[0].files[0];
                if(upload.size>1024*1024*5){
                    alert("文件不得大于5M")
                    return  false;
                }
                 var formData = new FormData();
                formData.append("uploadFile",upload);
                $.ajax({
                    url:"activity/upload.do",
                    data:formData,
                    processData:false,
                    contentType:false,
                    dataType:"json",
                    type:"post",
                    success:function (data) {
                        if (data.success) {
                           $("#importActivityModal").modal("hide")
                            pageList(1,2)
                        } else {
                            alert("系统繁忙 稍后再试")
                        }

                    }
                })


            })
        });

    </script>
</head>
<body>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName" autocomplete="off">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startTime"autocomplete="off">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endTime" autocomplete="off">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" autocomplete="off" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" autocomplete="off" id="create-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="save">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                            <input type="hidden" id="key">
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="update">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS/XLSX的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" id="search-name" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" id="search-owner" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="search-startTime"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="search-endTime">
                    </div>
                </div>

                <button type="button" id="search" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="create">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="edit"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="delete"><span class="glyphicon glyphicon-minus"></span>
                    删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="ck"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="tb">
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a>
                    </td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a>
                    </td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage">

            </div>

        </div>

    </div>

</div>
</body>
</html>