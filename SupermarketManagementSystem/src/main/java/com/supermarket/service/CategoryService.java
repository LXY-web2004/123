package com.supermarket.service;

import com.supermarket.dao.CategoryDAO;
import com.supermarket.model.Category;
import java.util.List;

public class CategoryService {
    private CategoryDAO categoryDAO = new CategoryDAO();

    // 添加分类
    public boolean addCategory(Category category) {
        // 校验分类名称唯一性
        List<Category> allCategories = getAllCategories();
        for (Category c : allCategories) {
            if (c.getCategoryName().equals(category.getCategoryName())) {
                throw new RuntimeException("分类名称已存在");
            }
        }
        return categoryDAO.addCategory(category);
    }

    // 查询所有分类
    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }

    // 按ID查询分类
    public Category getCategoryById(String id) {
        Category category = categoryDAO.getCategoryById(id);
        if (category == null) {
            throw new RuntimeException("未找到该分类");
        }
        return category;
    }

    // 更新分类
    public boolean updateCategory(Category category) {
        // 校验分类名称唯一性（排除当前分类）
        List<Category> allCategories = getAllCategories();
        for (Category c : allCategories) {
            if (!c.getId().equals(category.getId()) && c.getCategoryName().equals(category.getCategoryName())) {
                throw new RuntimeException("分类名称已存在");
            }
        }
        return categoryDAO.updateCategory(category);
    }

    // 删除分类
    public boolean deleteCategory(String id) {
        try {
            return categoryDAO.deleteCategory(id);
        } catch (RuntimeException e) {
            throw e; // 抛出DAO层的关联商品异常
        }
    }
}