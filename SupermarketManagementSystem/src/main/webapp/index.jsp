<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>超市商品管理系统</title>
    <style>
        body { background-color: #f0f2f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; font-family: "微软雅黑"; }
        .index-container { text-align: center; background: white; padding: 50px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .index-title { color: #0066cc; margin-bottom: 30px; }
        .jump-btn { padding: 10px 30px; background-color: #0066cc; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; text-decoration: none; }
    </style>
</head>
<body>
    <div class="index-container">
        <h1 class="index-title">超市商品管理系统</h1>
        <a href="${pageContext.request.contextPath}/product/list" class="jump-btn">进入系统</a>
    </div>
</body>
</html>