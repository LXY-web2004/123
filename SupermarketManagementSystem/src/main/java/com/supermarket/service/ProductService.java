package com.supermarket.service;

import com.supermarket.dao.ProductDAO;
import com.supermarket.model.Product;
import java.util.List;

public class ProductService {
    private ProductDAO productDAO = new ProductDAO();

    // 添加商品（校验商品编号唯一性）
    public boolean addProduct(Product product) {
        // 校验商品编号是否已存在
        List<Product> allProducts = getAllProducts();
        for (Product p : allProducts) {
            if (p.getProductNo().equals(product.getProductNo())) {
                throw new RuntimeException("商品编号已存在");
            }
        }
        return productDAO.addProduct(product);
    }

    // 查询所有商品
    public List<Product> getAllProducts() {
        return productDAO.getAllProducts();
    }

    // 按ID查询商品
    public Product getProductById(String id) {
        Product product = productDAO.getProductById(id);
        if (product == null) {
            throw new RuntimeException("未找到该商品");
        }
        return product;
    }

    // 搜索商品
    public List<Product> searchProducts(String keyword) {
        return productDAO.searchProducts(keyword);
    }

    // 更新商品
    public boolean updateProduct(Product product) {
        // 校验商品编号唯一性（排除当前商品）
        List<Product> allProducts = getAllProducts();
        for (Product p : allProducts) {
            if (!p.getId().equals(product.getId()) && p.getProductNo().equals(product.getProductNo())) {
                throw new RuntimeException("商品编号已存在");
            }
        }
        return productDAO.updateProduct(product);
    }

    // 删除商品
    public boolean deleteProduct(String id) {
        return productDAO.deleteProduct(id);
    }
}