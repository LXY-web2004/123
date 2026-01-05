package com.supermarket.servlet;

import com.supermarket.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 商品删除Servlet：修复序列化警告，补全删除逻辑，完善异常处理
 */
@WebServlet("/product/delete")
public class ProductDeleteServlet extends HttpServlet {
    // 修复序列化警告：添加静态最终序列化版本号
    private static final long serialVersionUID = 1L;
    // 实例化ProductService，处理商品删除业务逻辑
    private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 1. 获取请求中的商品ID参数
        String id = request.getParameter("id");
        try {
            // 2. 校验ID是否为空
            if (id == null || id.trim().isEmpty()) {
                throw new RuntimeException("商品ID不能为空");
            }

            // 3. 调用Service层执行删除操作
            boolean success = productService.deleteProduct(id);
            if (success) {
                // 删除成功：重定向至商品列表页（避免刷新重复删除）
                response.sendRedirect(request.getContextPath() + "/product/list");
            } else {
                // 删除失败：返回列表页并提示错误
                request.setAttribute("errorMsg", "删除商品失败，商品可能不存在");
                request.getRequestDispatcher("/product/list.jsp").forward(request, response);
            }
        } catch (RuntimeException e) {
            // 业务逻辑异常（如ID无效、商品不存在）
            e.printStackTrace();
            request.setAttribute("errorMsg", e.getMessage());
            request.getRequestDispatcher("/product/list.jsp").forward(request, response);
        } catch (Exception e) {
            // 其他未知异常
            e.printStackTrace();
            request.setAttribute("errorMsg", "删除商品时发生异常：" + e.getMessage());
            request.getRequestDispatcher("/product/list.jsp").forward(request, response);
        }
    }

    // 若有POST请求删除需求，复用GET逻辑
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}