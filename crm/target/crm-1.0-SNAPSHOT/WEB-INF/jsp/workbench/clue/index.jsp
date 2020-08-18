<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

        function pageList(pageNo, pageSize) {
            $("#ck").prop("checked", false)

            $("#search-owner").val($.trim($("#hidden-owner").val()))
            $("#search-fullname").val($.trim($("#hidden-fullname").val()))
            $("#search-company").val($.trim($("#hidden-company").val()))
            $("#search-state").val($.trim($("#hiddenn-state").val()))
            $("#search-source").val($.trim($("#hidden-source").val()))
            $("#search-mphone").val($.trim($("#hidden-mphone").val()))
            $("#search-phone").val($.trim($("#hidden-phone").val()))
            $.ajax({
                url: "clue/pageList.do",
                dataType: "json",
                data: {
                    "pageSize": pageSize,
                    "pageNo": pageNo,
                    "fullname": $.trim($("#search-fullname").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "state": $.trim($("#search-state").val()),
                    "source": $.trim($("#search-source").val()),
                    "company": $.trim($("#search-company").val()),
                    "mphone": $.trim($("#search-mphone").val()),
                    "phone": $.trim($("#search-phone").val())
                },
                success: function (data) {
                    var html = "";
                    $.each(data.dataList, function (i, n) {

                        html += '<tr>'
                        html += '<td><input type="checkbox"  name="flag" value="' + n.id + '"/></td>'
                        html += '<td><a style="text-decoration: none; cursor: pointer;"  onclick="Detail(\'' + n.id + '\')">' + (n.fullname + n.appellation) + '</a></td>'
                        html += '<td>' + n.company + '</td>'
                        html += '<td>' + n.phone + '</td>'
                        html += '<td>' + n.mphone + '</td>'
                        html += '<td>' + n.source + '</td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '<td>' + n.state + '</td>'
                        html += '</tr>'
                    })
                    $("#clueBody").html(html);
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                    $("#cluePage").bs_pagination({
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

        function Detail(id) {
            window.location.href = "clue/toDetail.do?id=" + id;
        }

        $(function () {
            $("#delete").click(function () {
                var num = $("input[name=flag]:checked")
                if (num.length < 1) {
                    alert("选择想要删除的记录")
                    return false
                }
                var arr = new Array(num.length);
                for (let i = 0; i < arr.length; i++) {
                    arr[i] = num[i].value
                }
                $.ajax({
                    url: "clue/deleteClue.do",
                    data: {
                        "arr": arr
                    },
                    traditional: "true",
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
                                , $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));


                        } else {
                            alert("系统繁忙稍后再试")
                        }
                    }

                })

            })


            $("#update").click(function () {
                $.ajax({
                    url: "clue/update.do",
                    data: {
                        "fullname": $.trim($("#edit-surname").val()),
                        "appellation": $.trim($("#edit-call").val()),
                        "owner": $.trim($("#edit-clueOwner").val()),
                        "company": $.trim($("#edit-company").val()),
                        "job": $.trim($("#edit-job").val()),
                        "email": $.trim($("#edit-email").val()),
                        "phone": $.trim($("#edit-phone").val()),
                        "website": $.trim($("#edit-website").val()),
                        "mphone": $.trim($("#edit-mphone").val()),
                        "state": $.trim($("#edit-status").val()),
                        "source": $.trim($("#edit-source").val()),
                        "description": $.trim($("#edit-describe").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "address": $.trim($("#edit-address").val()),
                        "id": $("#key").val()
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
                                , $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
                            $("#editClueModal").modal("hide")

                        } else {
                            alert("系统繁忙稍后再试")
                        }

                    }
                })
            })

            $("#edit").click(function () {
                var num = $("input[name=flag]:checked")
                if (num.length > 1) {
                    alert("对不起至多只能选择一条记录进行编辑")
                } else if (num.length < 1) {
                    alert("请选择想要编辑的记录")
                } else {
                    $.ajax({
                        url: "clue/toEdit.do",
                        data: {
                            "id": num.val()
                        },
                        dataType: "json",
                        success: function (data) {

                            $.ajax({
                                url: "clue/allUser.do",
                                dataType: "json",
                                success: function (data1) {
                                    var html = ""
                                    $.each(data1, function (i, n) {

                                        html += "<option value='" + n.id + "'>" + n.name + "</option>"

                                    })
                                    $("#edit-clueOwner").html(html);
                                    $("#edit-clueOwner").val(data.owner);

                                }
                            })
                            $("#edit-status").val(data.state);
                            $("#edit-contactSummary").val(data.contactSummary)
                            $("#edit-nextContactTime").val(data.nextContactTime);
                            $("#edit-surname").val(data.fullname);
                            $("#edit-address").val(data.address);
                            $("#edit-company").val(data.company);
                            $("#edit-job").val(data.job);
                            $("#edit-mphone").val(data.mphone);
                            $("#edit-phone").val(data.phone);
                            $("#edit-source").val(data.source);
                            $("#edit-email").val(data.email);
                            $("#edit-website").val(data.website);
                            $("#edit-call").val(data.appellation);
                            $("#edit-describe").val(data.description);
                            $("#key").val(data.id)
                            $("#editClueModal").modal("show");
                        }
                    })
                }


            })


            $("#save").click(function () {
                $.ajax({
                    url: "clue/save.do",
                    data: {
                        "fullname": $.trim($("#create-surname").val()),
                        "appellation": $.trim($("#create-call").val()),
                        "owner": $.trim($("#create-clueOwner").val()),
                        "company": $.trim($("#create-company").val()),
                        "job": $.trim($("#create-job").val()),
                        "email": $.trim($("#create-email").val()),
                        "phone": $.trim($("#create-phone").val()),
                        "website": $.trim($("#create-website").val()),
                        "mphone": $.trim($("#create-mphone").val()),
                        "state": $.trim($("#create-status").val()),
                        "source": $.trim($("#create-source").val()),
                        "description": $.trim($("#create-describe").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "address": $.trim($("#create-address").val())
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
                                , $("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
                            $("#createClueModal").modal("hide")
                        } else {
                            alert("添加失败")
                        }


                    }
                })

            })


            $("#create").click(function () {
                $.ajax({
                    url: "clue/allUser.do",
                    dataType: "json",
                    success: function (data) {
                        var html = ""
                        $.each(data, function (i, n) {

                            html += "<option value='" + n.id + "'>" + n.name + "</option>"

                        })
                        $("#create-clueOwner").html(html);
                        $("#create-clueOwner").val("${user.id}");
                        $("#createClueModal").modal("show")


                    }
                })

            })
            $("#clueBody").on("click", $("input[name=flag]"), function () {
                $("#ck").prop("checked", $("input[name=flag]").length == $("input[name=flag]:checked").length)
            })
            $("#ck").click(function () {
                $("input[name=flag]").prop("checked", this.checked)
            })


            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            pageList(1, 2)
            $("#search").click(function () {
                $("#hidden-owner").val($.trim($("#search-owner").val()))
                $("#hidden-fullname").val($.trim($("#search-fullname").val()))
                $("#hidden-company").val($.trim($("#search-company").val()))
                $("#hidden-state").val($.trim($("#search-state").val()))
                $("#hidden-source").val($.trim($("#search-source").val()))
                $("#hidden-mphone").val($.trim($("#search-mphone").val()))
                $("#hidden-phone").val($.trim($("#search-phone").val()))


                pageList(1, 2)
            })


        });

    </script>
</head>
<body>
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-fullname">
<input type="hidden" id="hidden-state">
<input type="hidden" id="hidden-source">
<input type="hidden" id="hidden-company">
<input type="hidden" id="hidden-mphone">
<input type="hidden" id="hidden-phone">

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-clueOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-call">
                                <option></option>
                                <%--<option>先生</option>
                                <option>夫人</option>
                                <option>女士</option>
                                <option>博士</option>
                                <option>教授</option>--%>
                                <c:forEach items="${appellation}" var="a">
                                    <option ${a.value}>${a.text}</option>
                                    >
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-status">
                                <option></option>
                                <%--<option>试图联系</option>
                                <option>将来联系</option>
                                <option>已联系</option>
                                <option>虚假线索</option>
                                <option>丢失线索</option>
                                <option>未联系</option>
                                <option>需要条件</option>--%>
                                <c:forEach var="s" items="${clueState}">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <%-- <option>广告</option>
                                 <option>推销电话</option>
                                 <option>员工介绍</option>
                                 <option>外部介绍</option>
                                 <option>在线商场</option>
                                 <option>合作伙伴</option>
                                 <option>公开媒介</option>
                                 <option>销售邮件</option>
                                 <option>合作伙伴研讨会</option>
                                 <option>内部研讨会</option>
                                 <option>交易会</option>
                                 <option>web下载</option>
                                 <option>web调研</option>
                                 <option>聊天</option>--%>
                                <c:forEach items="${source}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
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

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>
                    <input type="hidden" id="key">
                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <option></option>
                                <%-- <option selected>先生</option>
                                 <option>夫人</option>
                                 <option>女士</option>
                                 <option>博士</option>
                                 <option>教授</option>--%>
                                <c:forEach var="a" items="${appellation}">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-status">
                                <option></option>
                                <%-- <option>试图联系</option>
                                 <option>将来联系</option>
                                 <option selected>已联系</option>
                                 <option>虚假线索</option>
                                 <option>丢失线索</option>
                                 <option>未联系</option>
                                 <option>需要条件</option>--%>
                                <c:forEach items="${clueState}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <%--<option selected>广告</option>
                                <option>推销电话</option>
                                <option>员工介绍</option>
                                <option>外部介绍</option>
                                <option>在线商场</option>
                                <option>合作伙伴</option>
                                <option>公开媒介</option>
                                <option>销售邮件</option>
                                <option>合作伙伴研讨会</option>
                                <option>内部研讨会</option>
                                <option>交易会</option>
                                <option>web下载</option>
                                <option>web调研</option>
                                <option>聊天</option>--%>
                                <c:forEach var="s" items="${source}">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime"
                                       value="2017-05-01">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
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


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
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
                        <input class="form-control" type="text" id="search-fullname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="search-company">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="search-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="search-source">
                            <option></option>
                            <%-- <option>广告</option>
                           <option>推销电话</option>
                           <option>员工介绍</option>
                           <option>外部介绍</option>
                           <option>在线商场</option>
                           <option>合作伙伴</option>
                           <option>公开媒介</option>
                           <option>销售邮件</option>
                           <option>合作伙伴研讨会</option>
                           <option>内部研讨会</option>
                           <option>交易会</option>
                           <option>web下载</option>
                           <option>web调研</option>
                           <option>聊天</option>--%>
                            <c:forEach items="${source}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="search-mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="search-state">
                            <option></option>
                            <%--<option>试图联系</option>
                            <option>将来联系</option>
                            <option>已联系</option>
                            <option>虚假线索</option>
                            <option>丢失线索</option>
                            <option>未联系</option>
                            <option>需要条件</option>--%>
                            <c:forEach var="s" items="${clueState}">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" id="search" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="create"><span class="glyphicon glyphicon-plus"></span>
                    创建
                </button>
                <button type="button" class="btn btn-default" id="edit"><span class="glyphicon glyphicon-pencil"></span>
                    修改
                </button>
                <button type="button" class="btn btn-danger" id="delete"><span class="glyphicon glyphicon-minus"></span>
                    删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="ck"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueBody">
                <tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.jsp';">李四先生</a></td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.jsp';">李四先生</a></td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;">
            <div id="cluePage"></div>


        </div>

    </div>

</div>
</body>
</html>