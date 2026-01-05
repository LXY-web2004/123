<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑职工信息</title>
    <style>
        /* 全局样式：添加页面居中的核心样式 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "微软雅黑", sans-serif;
        }

        body {
            background-color: #f9f9f9;
            padding: 20px;
            /* 核心：让表单容器水平+垂直居中 */
            display: flex;
            justify-content: center;
            align-items: flex-start; /* 顶部对齐，避免页面过长时垂直居中变形 */
            min-height: 100vh;
        }

        /* 表单容器：居中后限制宽度，添加内边距 */
        .form-wrap {
            width: 100%;
            max-width: 600px;
            padding: 30px;
            background-color: #fff; /* 白色背景突出表单 */
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05); /* 轻微阴影增加层次感 */
        }

        .form-item {
            margin-bottom: 18px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            color: #333;
            margin-bottom: 6px;
        }

        .form-label .required {
            color: red;
        }

        .form-input {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            outline: none;
        }

        .form-input:focus {
            border-color: #999;
        }

        .gender-wrap {
            display: flex;
            align-items: center;
            padding: 5px 0;
        }

        .gender-item {
            margin-right: 20px;
            display: flex;
            align-items: center;
        }

        .gender-input {
            width: 16px;
            height: 16px;
            margin-right: 5px;
        }

        /* 按钮样式：保持与添加页一致的布局 */
        .btn-group {
            margin-top: 20px;
            display: flex;
            gap: 0;
        }

        .update-btn {
            padding: 8px 40px;
            background-color: #ff9900;
            color: white;
            border: none;
            border-radius: 4px 0 0 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .reset-btn {
            padding: 8px 40px;
            background-color: #e5e5e5;
            color: #333;
            border: none;
            border-radius: 0 4px 4px 0;
            cursor: pointer;
            font-size: 14px;
        }

        .error-msg {
            color: red;
            font-size: 14px;
            margin-bottom: 15px;
            text-align: center; /* 错误提示也居中 */
        }
    </style>
</head>
<body>
    <div class="form-wrap">
        <!-- 错误提示：居中显示 -->
        <c:if test="${not empty errorMsg}">
            <div class="error-msg">${errorMsg}</div>
        </c:if>

        <!-- 编辑表单：提交到编辑Servlet -->
        <form action="${pageContext.request.contextPath}/emp/edit" method="post">
            <!-- 隐藏字段：职工ID -->
            <input type="hidden" name="id" value="${emp.id}">

            <!-- 工号：回显原有工号 -->
            <div class="form-item">
                <label class="form-label">工号<span class="required">*</span></label>
                <input type="text" name="empNo" class="form-input" required placeholder="请输入唯一工号（如EMP001）" value="${emp.empNo}">
            </div>

            <!-- 姓名：回显原有姓名 -->
            <div class="form-item">
                <label class="form-label">姓名<span class="required">*</span></label>
                <input type="text" name="name" class="form-input" required placeholder="请输入职工姓名" value="${emp.name}">
            </div>

            <!-- 性别：回显原有选中状态 -->
            <div class="form-item">
                <label class="form-label">性别<span class="required">*</span></label>
                <div class="gender-wrap">
                    <div class="gender-item">
                        <input type="radio" name="gender" value="男" class="gender-input" ${emp.gender == '男' ? 'checked' : ''}>
                        <span>男</span>
                    </div>
                    <div class="gender-item">
                        <input type="radio" name="gender" value="女" class="gender-input" ${emp.gender == '女' ? 'checked' : ''}>
                        <span>女</span>
                    </div>
                </div>
            </div>

            <!-- 年龄：回显原有年龄 -->
            <div class="form-item">
                <label class="form-label">年龄</label>
                <input type="number" name="age" class="form-input" min="18" max="65" placeholder="可选，输入18-65之间的数字" value="${emp.age}">
            </div>

            <!-- 部门：回显原有部门 -->
            <div class="form-item">
                <label class="form-label">部门<span class="required">*</span></label>
                <input type="text" name="department" class="form-input" required placeholder="请输入所属部门" value="${emp.department}">
            </div>

            <!-- 职位：回显原有职位 -->
            <div class="form-item">
                <label class="form-label">职位<span class="required">*</span></label>
                <input type="text" name="position" class="form-input" required placeholder="请输入职工职位" value="${emp.position}">
            </div>

            <!-- 入职日期：格式化回显 -->
            <div class="form-item">
                <label class="form-label">入职日期<span class="required">*</span></label>
                <input type="date" name="hireDate" class="form-input" required value="<fmt:formatDate value="${emp.hireDate}" pattern="yyyy-MM-dd"/>">
            </div>

            <!-- 联系电话：回显原有手机号 -->
            <div class="form-item">
                <label class="form-label">联系电话</label>
                <input type="tel" name="phone" class="form-input" placeholder="可选，输入11位手机号" value="${emp.phone}">
            </div>

            <!-- 家庭地址：回显原有地址 -->
            <div class="form-item">
                <label class="form-label">家庭地址</label>
                <input type="text" name="address" class="form-input" placeholder="可选，输入详细家庭地址" value="${emp.address}">
            </div>

            <!-- 按钮组：保持与添加页一致的样式 -->
            <div class="btn-group">
                <button type="submit" class="update-btn">更新</button>
                <button type="reset" class="reset-btn">重置</button>
            </div>
        </form>
    </div>
</body>
</html>