<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%><!DOCTYPE html>
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
        function toDetail(id) {
            window.location.href="workbench/transaction/toDetail.do?id="+id

        }
        function pageList(pageNo, pageSize) {
            $.ajax({
                url: "workbench/transaction/pageList.do",
                data: {

                    " owner": $.trim($("#search-owner").val()),
                    " name": $.trim($("#search-name").val()),
                    " customerId": $.trim($("#search-customerId").val()),
                    " stage": $.trim($("#search-stage").val()),
                    " type": $.trim($("#search-type").val()),
                    " source": $.trim($("#search-source").val()),
                    " contactsId": $.trim($("#search-contactsId").val()),
                    "pageNo": pageNo,
                    "pageSize": pageSize


                },
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $.each(data.dataList, function (i, n) {

                        html += '<tr>'
                        html += '<td><input type="checkbox" name="flag" value="'+n.id+'"/></td>'
                        html += '<td><a onclick="toDetail(\''+n.id+'\')" style="text-decoration: none; cursor: pointer;">' + n.customerId + '-' + n.name + '</a>'
                        html += '</td>'
                        html += '<td>' + n.customerId + '</td>'
                        html += '<td>' + n.stage + '</td>'
                        html += '<td>' + n.type + '</td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '<td>' + n.source + '</td>'
                        html += '<td>' + n.contactsId + '</td>'
                        html += '</tr>'


                    })
                    $("#tranBody").html(html);

                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                    $("#tranPage").bs_pagination({
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
            pageList(1,2)


        });

    </script>
</head>
<body>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="search-customerId">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="search-stage">
                            <option></option>
                            <c:forEach items="${stage}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                            <%--		  	<option>资质审查</option>
                                          <option>需求分析</option>
                                          <option>价值建议</option>
                                          <option>确定决策者</option>
                                          <option>提案/报价</option>
                                          <option>谈判/复审</option>
                                          <option>成交</option>
                                          <option>丢失的线索</option>
                                          <option>因竞争丢失关闭</option>--%>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control" id="search-type">
                            <option></option>
                            <option>已有业务</option>
                            <option>新业务</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="search-clueSource">
                            <option></option>
                            <c:forEach var="s" items="${source}">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>

                            <%--               <option>广告</option>
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
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" id="search-contactsId" type="text">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="search">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"
                        onclick="window.location.href='workbench/transaction/toSave.do';"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>名称</td>
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="tranBody">
                <tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a>
                    </td>
                    <td>动力节点</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点-交易01</a>
                    </td>
                    <td>动力节点</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 20px;">

       <div id="tranPage"></div>

        </div>

    </div>

</div>
</body>
</html>