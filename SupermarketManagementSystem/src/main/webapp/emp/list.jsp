<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>职工列表 - 职工档案管理系统</title>
    <style>
        /* 全局样式：与添加/编辑页统一 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "微软雅黑", sans-serif;
        }

        body {
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            padding: 20px;
        }

        /* 列表容器：居中+白色卡片 */
        .list-container {
            width: 100%;
            max-width: 1000px;
            background-color: #fff;
            padding: 30px;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        /* 标题+搜索区：统一布局 */
        .header-area {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #0066cc;
        }

        .list-title {
            font-size: 20px;
            color: #333;
        }

        /* 搜索表单样式：与现有按钮风格统一 */
        .search-form {
            display: flex;
            gap: 10px;
        }

        .search-select {
            padding: 7px 10px;
            border: 1px solid #dcdfe6;
            border-radius: 4px;
            font-size: 14px;
        }

        .search-input {
            padding: 7px 10px;
            border: 1px solid #dcdfe6;
            border-radius: 4px;
            font-size: 14px;
            width: 200px;
        }

        .search-btn {
            padding: 7px 20px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        /* 列表样式：简洁表格 */
        .emp-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .emp-table th, .emp-table td {
            padding: 12px;
            text-align: center;
            border: 1px solid #e6e6e6;
        }

        .emp-table th {
            background-color: #f8f9fa;
            color: #333;
        }

        /* 操作按钮样式：与现有按钮风格统一 */
        .edit-btn {
            padding: 5px 10px;
            background-color: #ff9900;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            margin-right: 5px;
        }

        .delete-btn {
            padding: 5px 10px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
        }

        /* 新增按钮：回到添加页 */
        .add-btn {
            display: inline-block;
            padding: 8px 20px;
            background-color: #0066cc;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .error-msg {
            color: red;
            font-size: 14px;
            text-align: center;
            margin-bottom: 15px;
        }

        .empty-msg {
            color: #666;
            font-size: 14px;
            text-align: center;
            padding: 30px;
        }
    </style>
</head>
<body>
    <div class="list-container">
        <!-- 标题+搜索区 -->
        <div class="header-area">
            <h2 class="list-title">职工列表</h2>
            
            <!-- 新增：搜索表单 -->
            <form action="${pageContext.request.contextPath}/emp/list" method="get" class="search-form">
                <select name="searchType" class="search-select">
                    <option value="empNo" ${param.searchType == 'empNo' ? 'selected' : ''}>工号</option>
                    <option value="name" ${param.searchType == 'name' ? 'selected' : ''}>姓名</option>
                    <option value="department" ${param.searchType == 'department' ? 'selected' : ''}>部门</option>
                </select>
                <input type="text" name="keyword" class="search-input" placeholder="请输入查找关键词" value="${param.keyword}">
                <button type="submit" class="search-btn">查找</button>
            </form>
        </div>

        <!-- 新增职工按钮 -->
        <a href="${pageContext.request.contextPath}/emp/add" class="add-btn">添加新职工</a>

        <!-- 错误提示 -->
        <c:if test="${not empty errorMsg}">
            <div class="error-msg">${errorMsg}</div>
        </c:if>

        <!-- 职工列表 -->
        <c:if test="${not empty empList}">
            <table class="emp-table">
                <tr>
                    <th>工号</th>
                    <th>姓名</th>
                    <th>性别</th>
                    <th>年龄</th>
                    <th>部门</th>
                    <th>职位</th>
                    <th>入职日期</th>
                    <th>联系电话</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${empList}" var="emp">
                    <tr>
                        <td>${emp.empNo}</td>
                        <td>${emp.name}</td>
                        <td>${emp.gender}</td>
                        <td>${emp.age}</td>
                        <td>${emp.department}</td>
                        <td>${emp.position}</td>
                        <td><fmt:formatDate value="${emp.hireDate}" pattern="yyyy-MM-dd"/></td>
                        <td>${emp.phone}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/emp/edit/?id=${emp.id}" class="edit-btn">编辑</a>
                            <a href="${pageContext.request.contextPath}/emp/delete/?id=${emp.id}" class="delete-btn" onclick="return confirm('确定删除该职工吗？')">删除</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>

        <!-- 无数据提示 -->
        <c:if test="${empty empList}">
            <div class="empty-msg">
                <c:if test="${not empty param.keyword}">未找到匹配“${param.keyword}”的职工</c:if>
                <c:if test="${empty param.keyword}">暂无职工数据，请添加新职工</c:if>
            </div>
        </c:if>
    </div>
</body>
</html>