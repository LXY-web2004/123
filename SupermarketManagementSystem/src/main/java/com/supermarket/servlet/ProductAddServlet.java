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
 * 商品添加Servlet：移除多余导入，修复语法错误，完善异常处理
 */
@WebServlet("/product/add")
public class ProductAddServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductService productService = new ProductService(); // 修正变量名大小写（原productservice）
    private CategoryService categoryService = new CategoryService(); // 修正变量名大小写（原categoryservice）

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // GET请求跳转至添加页面，并传递分类列表（下拉选择）
        try {
            request.setAttribute("categoryList", categoryService.getAllCategories());
            request.getRequestDispatcher("/product/add.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "加载分类列表失败：" + e.getMessage());
            request.getRequestDispatcher("/product/add.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // 获取表单参数
            String productNo = request.getParameter("productNo");
            String productName = request.getParameter("productName");
            String categoryId = request.getParameter("categoryId");
            Double price = Double.parseDouble(request.getParameter("price"));
            Integer stock = Integer.parseInt(request.getParameter("stock"));
            String productionDateStr = request.getParameter("productionDate");
            String supplier = request.getParameter("supplier");
            String description = request.getParameter("description");

            // 非空校验（补充前端未覆盖的必填项校验）
            if (productNo == null || productNo.trim().isEmpty() || productName == null || productName.trim().isEmpty()
                    || categoryId == null || categoryId.trim().isEmpty()) {
                throw new RuntimeException("商品编号、名称、分类为必填项");
            }

            // 转换日期格式
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date productionDate = sdf.parse(productionDateStr);

            // 创建商品对象
            Product product = new Product(productNo, productName, categoryId, price, stock, productionDate, supplier, description);

            // 调用Service添加商品
            boolean success = productService.addProduct(product);
            if (success) {
                // 添加成功，重定向至商品列表页（避免表单重复提交）
                response.sendRedirect(request.getContextPath() + "/product/list");
            } else {
                request.setAttribute("errorMsg", "添加商品失败，未知原因");
                request.setAttribute("categoryList", categoryService.getAllCategories()); // 回显分类列表
                request.getRequestDispatcher("/product/add.jsp").forward(request, response);
            }
        } catch (ParseException e) {
            request.setAttribute("errorMsg", "日期格式错误（需为yyyy-MM-dd）");
            request.setAttribute("categoryList", categoryService.getAllCategories()); // 回显分类列表
            request.getRequestDispatcher("/product/add.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "价格或库存需为有效数字（价格最多两位小数，库存为非负整数）");
            request.setAttribute("categoryList", categoryService.getAllCategories()); // 回显分类列表
            request.getRequestDispatcher("/product/add.jsp").forward(request, response);
        } catch (RuntimeException e) {
            request.setAttribute("errorMsg", e.getMessage());
            request.setAttribute("categoryList", categoryService.getAllCategories()); // 回显分类列表
            request.getRequestDispatcher("/product/add.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "添加商品异常：" + e.getMessage());
            request.setAttribute("categoryList", categoryService.getAllCategories()); // 回显分类列表
            request.getRequestDispatcher("/product/add.jsp").forward(request, response);
        }
    }
}