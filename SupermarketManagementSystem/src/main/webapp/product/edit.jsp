<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑商品 - 超市商品管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "微软雅黑"; }
        body { background-color: #f0f2f5; display: flex; justify-content: center; padding: 20px; }
        .form-card { width: 100%; max-width: 600px; background: white; padding: 30px 40px; border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .form-title { text-align: center; font-size: 20px; color: #333; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #ff9900; }
        .form-item { margin-bottom: 16px; }
        .form-label { display: block; font-size: 14px; color: #333; margin-bottom: 5px; }
        .form-label .required { color: red; }
        .form-input, .form-select { width: 100%; padding: 7px 10px; border: 1px solid #dcdfe6; border-radius: 4px; font-size: 14px; outline: none; }
        .form-input:focus, .form-select:focus { border-color: #999; }
        .btn-group { margin-top: 20px; display: flex; gap: 10px; }
        .update-btn, .reset-btn { flex: 1; padding: 8px 0; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .update-btn { background-color: #ff9900; color: white; }
        .reset-btn { background-color: #e5e5e5; color: #333; }
        .error-msg { color: red; font-size: 14px; text-align: center; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2 class="form-title">编辑商品</h2>

        <c:if test="${not empty errorMsg}">
            <div class="error-msg">${errorMsg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/product/edit" method="post">
            <input type="hidden" name="id" value="${product.id}">

            <div class="form-item">
                <label class="form-label">商品编号<span class="required">*</span></label>
                <input type="text" name="productNo" class="form-input" required placeholder="格式：SP+3位数字（如SP001）" value="${product.productNo}">
            </div>

            <div class="form-item">
                <label class="form-label">商品名称<span class="required">*</span></label>
                <input type="text" name="productName" class="form-input" required placeholder="请输入商品名称" value="${product.productName}">
            </div>

            <div class="form-item">
                <label class="form-label">商品分类<span class="required">*</span></label>
                <select name="categoryId" class="form-select" required>
                    <option value="">请选择分类</option>
                    <c:forEach items="${categoryList}" var="category">
                        <option value="${category.id}" ${category.id == product.categoryId ? 'selected' : ''}>${category.categoryName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-item">
                <label class="form-label">商品价格（元）<span class="required">*</span></label>
                <input type="number" name="price" class="form-input" required step="0.01" min="0.01" placeholder="最多两位小数" value="${product.price}">
            </div>

            <div class="form-item">
                <label class="form-label">库存数量<span class="required">*</span></label>
                <input type="number" name="stock" class="form-input" required min="0" placeholder="非负整数" value="${product.stock}">
            </div>

            <div class="form-item">
                <label class="form-label">生产日期<span class="required">*</span></label>
                <input type="date" name="productionDate" class="form-input" required value="<fmt:formatDate value="${product.productionDate}" pattern="yyyy-MM-dd"/>">
            </div>

            <div class="form-item">
                <label class="form-label">供应商</label>
                <input type="text" name="supplier" class="form-input" placeholder="可选，输入供应商名称" value="${product.supplier}">
            </div>

            <div class="form-item">
                <label class="form-label">商品描述</label>
                <input type="text" name="description" class="form-input" placeholder="可选，输入商品详细描述" value="${product.description}">
            </div>

            <div class="btn-group">
                <button type="submit" class="update-btn">更新</button>
                <button type="reset" class="reset-btn">重置</button>
            </div>
        </form>
    </div>
</body>
</html>