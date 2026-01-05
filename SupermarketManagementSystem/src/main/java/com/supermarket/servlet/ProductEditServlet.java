package com.supermarket.servlet;

import com.supermarket.model.Product;
import com.supermarket.service.CategoryService;
import com.supermarket.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 商品编辑Servlet：修复序列化警告，补全数据回显与更新逻辑，完善异常处理
 */
@WebServlet("/product/edit")
public class ProductEditServlet extends HttpServlet {
    // 修复序列化警告：添加静态最终序列化版本号
    private static final long serialVersionUID = 1L;
    // 实例化业务层对象，处理商品和分类逻辑
    private ProductService productService = new ProductService();
    private CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // 1. 获取请求中的商品ID参数
        String id = request.getParameter("id");
        try {
            // 2. 校验ID是否为空/无效
            if (id == null || id.trim().isEmpty()) {
                throw new RuntimeException("商品ID不能为空");
            }
            // 3. 查询商品数据和分类列表，用于页面回显
            Product product = productService.getProductById(id);
            request.setAttribute("product", product);
            // 修正变量名：categorylist → categoryList（符合驼峰命名，与JSP页面匹配）
            request.setAttribute("categoryList", categoryService.getAllCategories());
            // 4. 转发至编辑页面
            request.getRequestDispatcher("/product/edit.jsp").forward(request, response);
        } catch (RuntimeException e) {
            // 业务逻辑异常（如ID无效、商品不存在）
            e.printStackTrace();
            request.setAttribute("errorMsg", e.getMessage());
            request.getRequestDispatcher("/product/list.jsp").forward(request, response);
        } catch (Exception e) {
            // 其他未知异常
            e.printStackTrace();
            request.setAttribute("errorMsg", "加载商品编辑数据失败：" + e.getMessage());
            request.getRequestDispatcher("/product/list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // 1. 获取表单所有参数（包含商品ID）
            String id = request.getParameter("id");
            String productNo = request.getParameter("productNo");
            String productName = request.getParameter("productName");
            String categoryId = request.getParameter("categoryId");
            Double price = Double.parseDouble(request.getParameter("price"));
            Integer stock = Integer.parseInt(request.getParameter("stock"));
            String productionDateStr = request.getParameter("productionDate");
            String supplier = request.getParameter("supplier");
            String description = request.getParameter("description");

            // 2. 非空校验（必填项）
            if (id == null || id.trim().isEmpty() || productNo == null || productNo.trim().isEmpty()
                    || productName == null || productName.trim().isEmpty() || categoryId == null || categoryId.trim().isEmpty()) {
                throw new RuntimeException("商品ID、编号、名称、分类为必填项");
            }

            // 3. 转换生产日期格式
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date productionDate = sdf.parse(productionDateStr);

            // 4. 创建商品对象并设置ID（用于更新）
            Product product = new Product(productNo, productName, categoryId, price, stock, productionDate, supplier, description);
            product.setId(id);

            // 5. 调用Service层执行更新操作
            boolean success = productService.updateProduct(product);
            if (success) {
                // 更新成功：重定向至商品列表页（避免表单重复提交）
                response.sendRedirect(request.getContextPath() + "/product/list");
            } else {
                // 更新失败：回显数据并提示错误
                request.setAttribute("errorMsg", "更新商品失败，商品可能不存在");
                request.setAttribute("product", product);
                request.setAttribute("categoryList", categoryService.getAllCategories());
                request.getRequestDispatcher("/product/edit.jsp").forward(request, response);
            }
        } catch (ParseException e) {
            // 日期格式异常
            request.setAttribute("errorMsg", "生产日期格式错误（需为yyyy-MM-dd）");
            // 回显分类列表，保证下拉框正常显示
            request.setAttribute("categoryList", categoryService.getAllCategories());
            request.getRequestDispatcher("/product/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // 价格/库存数字格式异常
            request.setAttribute("errorMsg", "价格或库存需为有效数字（价格最多两位小数，库存为非负整数）");
            request.setAttribute("categoryList", categoryService.getAllCategories());
            request.getRequestDispatcher("/product/edit.jsp").forward(request, response);
        } catch (RuntimeException e) {
            // 业务逻辑异常（如商品编号重复、ID无效）
            e.printStackTrace();
            request.setAttribute("errorMsg", e.getMessage());
            request.setAttribute("categoryList", categoryService.getAllCategories());
            request.getRequestDispatcher("/product/edit.jsp").forward(request, response);
        } catch (Exception e) {
            // 其他未知异常
            e.printStackTrace();
            request.setAttribute("errorMsg", "更新商品时发生异常：" + e.getMessage());
            request.setAttribute("categoryList", categoryService.getAllCategories());
            request.getRequestDispatcher("/product/edit.jsp").forward(request, response);
        }
    }
}