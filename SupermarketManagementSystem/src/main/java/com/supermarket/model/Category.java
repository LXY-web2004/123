package com.supermarket.model;

import com.supermarket.util.CommonUtil;

public class Category {
    private String id;
    private String categoryName;
    private String description;

    // 无参构造
    public Category() {}

    // 带参构造
    public Category(String categoryName, String description) {
        this.categoryName = CommonUtil.filterXSS(categoryName);
        this.description = CommonUtil.filterXSS(description);
        if (categoryName == null || categoryName.isEmpty()) {
            throw new IllegalArgumentException("分类名称不能为空");
        }
    }

    // Getter和Setter（添加XSS过滤）
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) {
        if (categoryName == null || categoryName.isEmpty()) {
            throw new IllegalArgumentException("分类名称不能为空");
        }
        this.categoryName = CommonUtil.filterXSS(categoryName);
    }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = CommonUtil.filterXSS(description); }
}