<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>添加新职工 - 职工档案管理系统</title>
    <style>
        /* 全局样式重置与基础设置 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", "Segoe UI", sans-serif;
        }

        body {
            background-color: #f5f7fa;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        /* 表单容器样式 */
        .form-container {
            background: #ffffff;
            width: 100%;
            max-width: 600px;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #e8e8e8;
        }

        /* 标题样式 */
        .form-title {
            text-align: center;
            font-size: 24px;
            color: #1f2937;
            margin-bottom: 30px;
            font-weight: 600;
            position: relative;
        }

        .form-title::after {
            content: "";
            display: block;
            width: 60px;
            height: 3px;
            background-color: #2563eb;
            margin: 10px auto 0;
            border-radius: 3px;
        }

        /* 表单项目样式 */
        .form-item {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            color: #374151;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            color: #111827;
            transition: border-color 0.3s ease;
            outline: none;
        }

        .form-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-input::placeholder {
            color: #9ca3af;
        }

        /* 性别单选框样式 */
        .gender-group {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 10px 0;
        }

        .gender-item {
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
        }

        .gender-input {
            width: 16px;
            height: 16px;
            accent-color: #2563eb;
        }

        .gender-text {
            font-size: 14px;
            color: #374151;
        }

        /* 按钮样式 */
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .submit-btn {
            flex: 1;
            padding: 14px;
            background-color: #2563eb;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .submit-btn:hover {
            background-color: #1d4ed8;
        }

        .reset-btn {
            flex: 1;
            padding: 14px;
            background-color: #f3f4f6;
            color: #4b5563;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .reset-btn:hover {
            background-color: #e5e7eb;
        }

        /* 错误提示样式 */
        .error-msg {
            text-align: center;
            color: #dc2626;
            font-size: 14px;
            padding: 10px;
            background-color: #fef2f2;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #fecaca;
        }

        /* 响应式适配 */
        @media (max-width: 500px) {
            .form-container {
                padding: 25px;
            }

            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2 class="form-title">添加新职工</h2>

        <%-- 错误提示展示 --%>
        <c:if test="${not empty errorMsg}">
            <div class="error-msg">${errorMsg}</div>
        </c:if>

        <%-- 表单提交 --%>
        <form action="${pageContext.request.contextPath}/emp/add" method="post">
            <%-- 工号 --%>
            <div class="form-item">
                <label class="form-label">工号 <span style="color: #dc2626;">*</span></label>
                <input type="text" name="empNo" class="form-input" required placeholder="请输入唯一工号（如EMP001）">
            </div>

            <%-- 姓名 --%>
            <div class="form-item">
                <label class="form-label">姓名 <span style="color: #dc2626;">*</span></label>
                <input type="text" name="name" class="form-input" required placeholder="请输入职工姓名">
            </div>

            <%-- 性别 --%>
            <div class="form-item">
                <label class="form-label">性别 <span style="color: #dc2626;">*</span></label>
                <div class="gender-group">
                    <div class="gender-item">
                        <input type="radio" name="gender" value="男" class="gender-input" checked>
                        <span class="gender-text">男</span>
                    </div>
                    <div class="gender-item">
                        <input type="radio" name="gender" value="女" class="gender-input">
                        <span class="gender-text">女</span>
                    </div>
                </div>
            </div>

            <%-- 年龄 --%>
            <div class="form-item">
                <label class="form-label">年龄</label>
                <input type="number" name="age" class="form-input" min="18" max="65" placeholder="可选，输入18-65之间的数字">
            </div>

            <%-- 部门 --%>
            <div class="form-item">
                <label class="form-label">部门 <span style="color: #dc2626;">*</span></label>
                <input type="text" name="department" class="form-input" required placeholder="请输入所属部门">
            </div>

            <%-- 职位 --%>
            <div class="form-item">
                <label class="form-label">职位 <span style="color: #dc2626;">*</span></label>
                <input type="text" name="position" class="form-input" required placeholder="请输入职工职位">
            </div>

            <%-- 入职日期 --%>
            <div class="form-item">
                <label class="form-label">入职日期 <span style="color: #dc2626;">*</span></label>
                <input type="date" name="hireDate" class="form-input" required>
            </div>

            <%-- 联系电话 --%>
            <div class="form-item">
                <label class="form-label">联系电话</label>
                <input type="tel" name="phone" class="form-input" placeholder="可选，输入11位手机号">
            </div>

            <%-- 家庭地址 --%>
            <div class="form-item">
                <label class="form-label">家庭地址</label>
                <input type="text" name="address" class="form-input" placeholder="可选，输入详细家庭地址">
            </div>

            <%-- 按钮组 --%>
            <div class="btn-group">
                <button type="submit" class="submit-btn">提交</button>
                <button type="reset" class="reset-btn">重置</button>
            </div>
        </form>
    </div>
</body>
</html>