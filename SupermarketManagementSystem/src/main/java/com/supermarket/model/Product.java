package com.supermarket.model;

import com.supermarket.util.CommonUtil;
import java.util.Date;

public class Product {
    private String id; // MongoDB _id转字符串
    private String productNo;
    private String productName;
    private String categoryId;
    private Double price;
    private Integer stock;
    private Date productionDate;
    private String supplier;
    private String description;
    private Date createTime;

    // 无参构造
    public Product() {}

    // 带参构造（用于添加商品）
    public Product(String productNo, String productName, String categoryId, Double price, 
                   Integer stock, Date productionDate, String supplier, String description) {
        // XSS过滤
        this.productNo = CommonUtil.filterXSS(productNo);
        this.productName = CommonUtil.filterXSS(productName);
        this.categoryId = CommonUtil.filterXSS(categoryId);
        this.supplier = CommonUtil.filterXSS(supplier);
        this.description = CommonUtil.filterXSS(description);
        
        // 参数校验
        if (!CommonUtil.isValidProductNo(productNo)) {
            throw new IllegalArgumentException("商品编号格式错误（需为SP+3位数字，如SP001）");
        }
        if (!CommonUtil.isValidPrice(price)) {
            throw new IllegalArgumentException("价格格式错误（正数，最多两位小数）");
        }
        if (!CommonUtil.isValidStock(stock)) {
            throw new IllegalArgumentException("库存需为非负整数");
        }
        
        this.price = price;
        this.stock = stock;
        this.productionDate = productionDate;
        this.createTime = new Date();
    }

    // Getter和Setter（Setter中添加XSS过滤和校验，示例如下）
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getProductNo() { return productNo; }
    public void setProductNo(String productNo) {
        if (!CommonUtil.isValidProductNo(productNo)) {
            throw new IllegalArgumentException("商品编号格式错误");
        }
        this.productNo = CommonUtil.filterXSS(productNo);
    }

    // 其余字段Getter/Setter按上述格式补充（price、stock需校验，其余需XSS过滤）
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = CommonUtil.filterXSS(productName); }
    public String getCategoryId() { return categoryId; }
    public void setCategoryId(String categoryId) { this.categoryId = CommonUtil.filterXSS(categoryId); }
    public Double getPrice() { return price; }
    public void setPrice(Double price) {
        if (!CommonUtil.isValidPrice(price)) {
            throw new IllegalArgumentException("价格格式错误");
        }
        this.price = price;
    }
    public Integer getStock() { return stock; }
    public void setStock(Integer stock) {
        if (!CommonUtil.isValidStock(stock)) {
            throw new IllegalArgumentException("库存需为非负整数");
        }
        this.stock = stock;
    }
    public Date getProductionDate() { return productionDate; }
    public void setProductionDate(Date productionDate) { this.productionDate = productionDate; }
    public String getSupplier() { return supplier; }
    public void setSupplier(String supplier) { this.supplier = CommonUtil.filterXSS(supplier); }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = CommonUtil.filterXSS(description); }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}