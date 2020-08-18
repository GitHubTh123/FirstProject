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

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
<script type="text/javascript">
    $(function () {
        $.ajax({
            url: "dict/allType.do",
            dataType: "json",
            success: function (data) {
                var html = ""
                $.each(data, function (i, n) {
                    html += "<tr>"
                    html += "<td><input type='checkbox' name='flag' value='" + n.code + "'/></td>"
                    html += "<td>" + (i + 1) + "</td>"
                    html += "<td>" + n.code + "</td>"
                    html += "<td>" + n.name + "</td>"
                    html += "<td>" + n.description + "</td>"
                    html += "</tr>"

                })
                $("#tb").html(html)
                $("input[name=flag]").click(function () {
                    $("#ck").prop("checked", $("input[name=flag]").length == $("input[name=flag]:checked").length)
                })

            }
        })
        $("#ck").click(function () {
            $("input[name=flag]").prop("checked", this.checked)
        })

        $("#edit").click(function () {
            var num = $("input[name=flag]:checked")
            if (num.length > 1) {
                alert("对不起，至多只能选择一条记录进行改动")
            } else if (num.length < 1) {
                alert("请选择想要编辑的记录")
            } else {
                window.location.href = "dict/toEdit.do?code=" + num.val();
            }


        })

        $("#delete").click(function () {
            var num = $("input[name=flag]:checked");
            if (num.length < 1) {
                alert("请选择想要删除的记录")
            } else {
                if (confirm("不可撤销，其关联记录将一并删除，是否继续")) {
                    var arr = new Array(num.length);
                    for (let i = 0; i < arr.length; i++) {
                        arr[i] = num[i].value

                    }
                    window.location.href = "dict/del.do?arr=" + arr
                }
            }
        })
    })
</script>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>字典类型列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary" onclick="window.location.href='file/toSaveType.do'"><span
                class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button type="button" class="btn btn-default" id="edit"><span class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="del"><span class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>
<div style="position: relative; left: 30px; top: 20px;">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input type="checkbox" id="ck"/></td>
            <td>序号</td>
            <td>编码</td>
            <td>名称</td>
            <td>描述</td>
        </tr>
        </thead>
        <tbody id="tb">
        <tr class="active">
            <td><input type="checkbox"/></td>
            <td>1</td>
            <td>sex</td>
            <td>性别</td>
            <td>性别包括男和女</td>
        </tr>
        </tbody>
    </table>
</div>

</body>
</html>