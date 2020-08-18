<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">
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
            $("search-owner").val($.trim($("hidden-owner").val()))
            $("search-name").val($.trim($("hidden-name").val()))
            $("search-website").val($.trim($("hidden-website").val()))
            $("search-phone").val($.trim($("hidden-phone").val()))

            $.ajax({
                url: "workbench/customer/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "website": $.trim($("#search-website").val()),
                    "phone": $.trim($("#search-phone").val()),
                    "owner": $.trim($("#search-owner").val())

                },
                dataType: "json",
                success: function (data) {
                    var html = ""
                    $.each(data.dataList, function (i, n) {


                        html += '<tr>'
                        html += '<td><input type="checkbox" name="flag" value="' + n.id + '"/></td>'
                        html += '<td><a onclick="toCustomerDetail(\''+n.id+'\')" style="text-decoration: none; cursor: pointer;">' + n.name + '</a>'
                        html += '</td>'
                        html += '<td>' + n.owner + '</td>'
                        html += '<td>' + n.phone + '</td>'
                        html += '<td>' + n.website + '</td>'
                        html += '</tr>'

                    })
                    $("#customerBody").html(html)
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                    $("#customerPage").bs_pagination({
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

        function toCustomerDetail(id){
            window.location.href="workbench/customer/toDetail.do?id="+id
        }

        $(function () {

            $("#delete").click(function () {
var num =$("input[name=flag]:checked");
if(num.length<1){
    alert("请选择想要删除的记录")
    return false
}
var arr = new Array(num.length)
                for (let i = 0; i <arr.length ; i++) {
                    arr[i]=num[i].value
                }
$.ajax({
    url:"workbench/customer/deleteCustomer.do",
    data:{
        "arr":arr
    },
    dataType:"json",
    traditional:true,
    success:function (data) {
        if(data.success){
            pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
                , $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

        }else{
            alert("删除失败 ")
        }


    }
})

            })
            $("#update").click(function () {
                $.ajax({
                    url: "workbench/customer/updateCustomer.do",
                    data: {
                        "description": $.trim($("#edit-describe").val()),
                        "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                        "contactSummary": $.trim($("#edit-contactSummary").val()),
                        "phone": $.trim($("#edit-phone").val()),
                        "address": $.trim($("#edit-address").val()),
                        "owner": $.trim($("#edit-customerOwner").val()),
                        "website": $.trim($("#edit-website").val()),
                        "name": $.trim($("#edit-customerName").val()),
                        "id":$("#key").val(),
                        "editBy":"${user.name}"
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
                                , $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            $("#editCustomerModal").modal("hide")
                        } else {
                            alert("修改失败")
                        }

                    }
                })
            })

            $("#edit").click(function () {
                var num = $("input[name=flag]:checked");
                if (num.length > 1) {
                    alert("对不起 至多只能选择一条记录进行修改")
                } else if (num.length < 1) {
                    alert("请选择想要修改的记录")
                } else {
                    $.ajax({
                        url: "workbench/customer/edit.do",
                        data: {
                            /* "description": $.trim($("#edit-describe").val()),
                             "nextContactTime": $.trim($("#edit-nextContactTime").val()),
                             "contactSummary": $.trim($("#edit-contactSummary").val()),
                             "phone": $.trim($("#edit-phone").val()),
                             "address": $.trim($("#edit-address").val()),
                             "owner": $.trim($("#edit-customerOwner").val()),
                             "website": $.trim($("#edit-website").val()),
                             "name": $.trim($("#edit-customerName").val())*/
                            "id": num.val()
                        },
                        dataType: "json",
                        success: function (data) {

                            if (data.success) {
                                $.ajax({
                                    url: "workbench/customer/allUser.do",
                                    dataType: "json",
                                    success: function (data1) {
                                        var html = "";
                                        $.each(data1, function (i, n) {
                                            html += "<option value='" + n.id + "'>" + n.name + "</option>";
                                        })
                                        $("#edit-customerOwner").html(html)
                                        $("#edit-customerOwner").val(data.c.owner)

                                    }
                                })

                                $("#edit-describe").val(data.c.description)
                                $("#edit-nextContactTime").val(data.c.nextContactTime)
                                $("#edit-contactSummary").val(data.c.contactSummary)
                                $("#edit-phone").val(data.c.phone)
                                $("#edit-address").val(data.c.address)
                                $("#edit-website").val(data.c.website)
                                $("#edit-customerName").val(data.c.name)
                                $("#key").val(data.c.id)
                                $("#editCustomerModal").modal("show")
                            }
                        }
                    })

                }


            })

            $("#ck").click(function () {
                $("input[name=flag]").prop("checked", this.checked);
            })
            $("#customerBody").on("click", $("input[name=flag]"), function () {
                $("#ck").prop("checked", $("input[name=flag]").length == $("input[nameflag]:checked").length);
            })
            $("#create").click(function () {
                $.ajax({
                    url: "workbench/customer/allUser.do",
                    dataType: "json",
                    success: function (data) {
                        var html = "";
                        $.each(data, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>";
                        })
                        $("#create-customerOwner").html(html)
                        $("#create-customerOwner").val("${user.id}")
                        $("#createCustomerModal").modal("show")
                    }
                })

            })

            $("#save").click(function () {
                $.ajax({
                    url: "workbench/customer/saveCustomer.do",
                    data: {
                        "description": $.trim($("#create-describe").val()),
                        "nextContactTime": $.trim($("#create-nextContactTime").val()),
                        "contactSummary": $.trim($("#create-contactSummary").val()),
                        "phone": $.trim($("#create-phone").val()),
                        "address": $.trim($("#create-address").val()),
                        "owner": $.trim($("#create-customerOwner").val()),
                        "website": $.trim($("#create-website").val()),
                        "name": $.trim($("#create-customerName").val())
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
                                , $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            $("#createCustomerModal").modal("hide")
                        } else {
                            alert("添加失败")
                        }

                    }
                })
            })


            $("#search-Btn").click(function () {
                $("hidden-owner").val($.trim($("search-owner").val()))
                $("hidden-name").val($.trim($("search-name").val()))
                $("hidden-website").val($.trim($("search-website").val()))
                $("hidden-phone").val($.trim($("search-phone").val()))


                pageList(1, 2)
            })
            pageList(1, 2)

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

        });

    </script>
</head>
<body>
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-website">
<input type="hidden" id="hidden-name">

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-customerOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="create-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-customerName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
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
                                <input type="text" class="form-control" id="create-nextContactTime">
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

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-customerOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                            <input type="hidden" id="key">
                        </div>
                        <label for="edit-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-customerName" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"><%--北京大兴大族企业湾--%></textarea>
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
            <h3>客户列表</h3>
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
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
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
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="search-website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="search-Btn">查询</button>

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
                <button type="button" id="delete" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span>
                    删除
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
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="customerBody">
                <tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a>
                    </td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a>
                    </td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="customerPage"></div>


        </div>

    </div>

</div>
</body>
</html>