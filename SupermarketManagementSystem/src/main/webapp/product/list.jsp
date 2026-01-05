<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品列表 - 超市商品管理系统</title>
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: "微软雅黑", "Microsoft YaHei", sans-serif; 
        }
        
        body { 
            background-color: #f5f7fa; 
            padding: 20px; 
            min-height: 100vh;
        }
        
        list-container { 
            width: 100%; 
            max-width: 1400px; 
            margin: 0 auto;
            background: white; 
            padding: 30px; 
            border-radius: 12px; 
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); 
        }
        
        header-area { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 30px; 
            padding-bottom: 20px; 
            border-bottom: 2px solid #1890ff; 
        }
        
        list-title { 
            font-size: 24px; 
            color: #1a1a1a; 
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        list-title::before {
            content: "📦";
            font-size: 28px;
        }
        
        search-form { 
            display: flex; 
            gap: 12px; 
            align-items: center;
        }
        
        search-input { 
            padding: 10px 16px; 
            border: 1px solid #d9d9d9; 
            border-radius: 6px; 
            font-size: 14px; 
            width: 280px; 
            transition: all 0.3s;
            outline: none;
        }
        
        .search-input:focus {
            border-color: #1890ff;
            box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
        }
        
        .search-btn, .add-btn { 
            padding: 10px 24px; 
            background-color: #1890ff; 
            color: white; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-size: 14px; 
            text-decoration: none; 
            transition: all 0.3s;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .search-btn:hover, .add-btn:hover {
            background-color: #40a9ff;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
        }
        
        .add-btn { 
            background-color: #52c41a;
            margin-bottom: 20px; 
            display: inline-flex;
        }
        
        .add-btn:hover {
            background-color: #73d13d;
            box-shadow: 0 4px 12px rgba(82, 196, 26, 0.3);
        }
        
        .clear-btn {
            padding: 8px 16px;
            background-color: #f5f5f5;
            color: #595959;
            border: 1px solid #d9d9d9;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .clear-btn:hover {
            background-color: #e8e8e8;
            border-color: #bfbfbf;
        }
        
        .product-table { 
            width: 100%; 
            border-collapse: collapse; 
            font-size: 14px; 
            margin-top: 20px;
            overflow: hidden;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }
        
        .product-table th, .product-table td { 
            padding: 16px 12px; 
            text-align: center; 
            border: 1px solid #f0f0f0; 
        }
        
        .product-table th { 
            background: linear-gradient(to bottom, #fafafa, #f0f0f0); 
            color: #262626; 
            font-weight: 600;
            border-bottom: 2px solid #1890ff;
            position: sticky;
            top: 0;
        }
        
        .product-table tbody tr {
            transition: all 0.3s;
        }
        
        .product-table tbody tr:hover {
            background-color: #f6f8ff;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .product-table tbody tr:nth-child(even) {
            background-color: #fafafa;
        }
        
        .product-table tbody tr:nth-child(even):hover {
            background-color: #f6f8ff;
        }
        
        .edit-btn { 
            padding: 8px 16px; 
            background-color: #faad14; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            text-decoration: none; 
            font-size: 13px; 
            margin-right: 8px; 
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .edit-btn:hover {
            background-color: #ffc53d;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(250, 173, 20, 0.3);
        }
        
        .delete-btn { 
            padding: 8px 16px; 
            background-color: #ff4d4f; 
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            text-decoration: none; 
            font-size: 13px; 
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .delete-btn:hover {
            background-color: #ff7875;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(255, 77, 79, 0.3);
        }
        
        .error-msg { 
            color: #cf1322; 
            background-color: #fff2f0;
            border: 1px solid #ffccc7;
            font-size: 14px; 
            text-align: center; 
            margin: 20px 0; 
            padding: 16px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .empty-msg { 
            color: #8c8c8c; 
            font-size: 16px; 
            text-align: center; 
            padding: 60px 20px; 
            border: 2px dashed #d9d9d9;
            border-radius: 8px;
            margin: 20px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
        }
        
        .empty-icon {
            font-size: 48px;
            color: #bfbfbf;
        }
        
        .stock-low {
            color: #cf1322;
            font-weight: 600;
            background-color: #fff2f0;
            padding: 4px 8px;
            border-radius: 4px;
        }
        
        .stock-normal {
            color: #389e0d;
            font-weight: 500;
        }
        
        .price {
            color: #d48806;
            font-weight: 600;
        }
        
        .category-badge {
            display: inline-block;
            padding: 4px 12px;
            background-color: #e6f7ff;
            color: #0050b3;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .summary-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 16px;
            background-color: #f6ffed;
            border-radius: 8px;
            border: 1px solid #b7eb8f;
        }
        
        .summary-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
        }
        
        .summary-label {
            font-size: 12px;
            color: #8c8c8c;
        }
        
        .summary-value {
            font-size: 18px;
            font-weight: 600;
            color: #389e0d;
        }
        
        .actions-cell {
            white-space: nowrap;
        }
        
        @media (max-width: 992px) {
            .list-container {
                padding: 20px;
            }
            
            .header-area {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px;
            }
            
            .search-form {
                width: 100%;
                flex-wrap: wrap;
            }
            
            .search-input {
                width: 100%;
            }
            
            .product-table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }
        
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .product-table th, .product-table td {
                padding: 12px 8px;
                font-size: 13px;
            }
            
            .edit-btn, .delete-btn {
                padding: 6px 12px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="list-container">
        <div class="header-area">
            <h2 class="list-title">商品列表</h2>
            <form action="${pageContext.request.contextPath}/product/list" method="get" class="search-form">
                <input type="text" name="keyword" class="search-input" 
                       placeholder="🔍 输入商品名称/编号查找" value="${param.keyword}">
                <button type="submit" class="search-btn">查找</button>
                <c:if test="${not empty param.keyword}">
                    <a href="${pageContext.request.contextPath}/product/list" class="clear-btn">清除搜索</a>
                </c:if>
            </form>
        </div>

        <c:if test="${not empty productList && productList.size() > 0}">
            <div class="summary-bar">
                <div class="summary-item">
                    <span class="summary-label">商品总数</span>
                    <span class="summary-value">${productList.size()} 个</span>
                </div>
                <div class="summary-item">
                    <span class="summary-label">总库存</span>
                    <span class="summary-value">
                        <c:set var="totalStock" value="0" />
                        <c:forEach items="${productList}" var="product">
                            <c:set var="totalStock" value="${totalStock + product.stock}" />
                        </c:forEach>
                        ${totalStock}
                    </span>
                </div>
                <div class="summary-item">
                    <span class="summary-label">商品分类</span>
                    <span class="summary-value">
                        <c:set var="categoryCount" value="0" />
                        <c:forEach items="${categoryList}" var="category">
                            <c:set var="categoryCount" value="${categoryCount + 1}" />
                        </c:forEach>
                        ${categoryCount} 类
                    </span>
                </div>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/product/add" class="add-btn">
            <span>➕</span> 添加新商品
        </a>

        <c:if test="${not empty errorMsg}">
            <div class="error-msg">
                <span>⚠️</span> ${errorMsg}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty productList && productList.size() > 0}">
                <table class="product-table">
                    <thead>
                        <tr>
                            <th>商品编号</th>
                            <th>商品名称</th>
                            <th>分类</th>
                            <th>价格（元）</th>
                            <th>库存</th>
                            <th>生产日期</th>
                            <th>供应商</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${productList}" var="product">
                            <tr>
                                <td><strong>${product.productNo}</strong></td>
                                <td><strong>${product.productName}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty categoryList}">
                                            <c:forEach items="${categoryList}" var="category">
                                                <c:if test="${category.id == product.categoryId}">
                                                    <span class="category-badge">${category.categoryName}</span>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="category-badge">未分类</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="price">
                                    <fmt:formatNumber value="${product.price}" pattern="¥#,##0.00"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${product.stock < 10}">
                                            <span class="stock-low">${product.stock} (库存紧张)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-normal">${product.stock}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${product.productionDate}" pattern="yyyy-MM-dd"/>
                                </td>
                                <td>${empty product.supplier ? '-' : product.supplier}</td>
                                <td class="actions-cell">
                                    <a href="${pageContext.request.contextPath}/product/edit?id=${product.id}" 
                                       class="edit-btn" title="编辑商品">✏️ 编辑</a>
                                    <a href="${pageContext.request.contextPath}/product/delete?id=${product.id}" 
                                       class="delete-btn" 
                                       onclick="return confirm('确定删除商品【${product.productName}】吗？\n此操作不可撤销！');"
                                       title="删除商品">🗑️ 删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-msg">
                    <div class="empty-icon">📦</div>
                    <div>
                        <c:choose>
                            <c:when test="${not empty param.keyword}">
                                <h3>未找到匹配"${param.keyword}"的商品</h3>
                                <p>请尝试其他关键词或<a href="${pageContext.request.contextPath}/product/list" style="color: #1890ff;">查看所有商品</a></p>
                            </c:when>
                            <c:otherwise>
                                <h3>暂无商品数据</h3>
                                <p>点击上方"添加新商品"按钮开始添加商品</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        // 添加页面加载效果
        document.addEventListener('DOMContentLoaded', function() {
            // 表格行动画
            const rows = document.querySelectorAll('.product-table tbody tr');
            rows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(10px)';
                
                setTimeout(() => {
                    row.style.transition = 'opacity 0.3s, transform 0.3s';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
                }, index * 50);
            });
            
            // 搜索框自动聚焦
            const searchInput = document.querySelector('.search-input');
            if (searchInput && searchInput.value === '') {
                searchInput.focus();
            }
        });
    </script>
</body>
</html>