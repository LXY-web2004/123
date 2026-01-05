package com.supermarket.servlet;

import com.supermarket.model.Product;
import com.supermarket.service.ProductService;
import com.supermarket.service.CategoryService; // 新增：用于分类列表回显

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 商品列表Servlet：修复序列化警告，补全变量与服务实例，完善编码和查询逻辑
 */
@WebServlet("/product/list")
public class ProductListServlet extends HttpServlet {
    // 修复序列化警告：添加静态最终序列化版本号
    private static final long serialVersionUID = 1L;
    // 实例化业务层对象，处理商品和分类逻辑
    private ProductService productService = new ProductService();
    private CategoryService categoryService = new CategoryService(); // 新增：用于分类列表回显

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 统一编码：解决中文乱码问题
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        List<Product> productList; // 定义商品列表变量，修复“未定义”错误
        try {
            // 获取搜索关键词参数
            String keyword = request.getParameter("keyword");
            
            // 执行查询逻辑：有关键词则模糊搜索，无则查询所有
            if (keyword != null && !keyword.trim().isEmpty()) {
                productList = productService.searchProducts(keyword.trim());
            } else {
                productList = productService.getAllProducts();
            }

            // 存入request域：商品列表+分类列表（用于页面分类名称回显）
            request.setAttribute("productList", productList);
            request.setAttribute("categoryList", categoryService.getAllCategories()); // 新增：分类列表供页面使用
            // 转发至商品列表页
            request.getRequestDispatcher("/product/list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // 异常提示：修正文字表述，更精准
            request.setAttribute("errorMsg", "查询商品列表失败：" + e.getMessage());
            request.getRequestDispatcher("/product/list.jsp").forward(request, response);
        }
    }

    // POST请求复用GET逻辑（兼容表单POST提交的搜索请求）
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}