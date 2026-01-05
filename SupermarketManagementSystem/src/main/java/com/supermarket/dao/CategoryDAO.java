package com.supermarket.dao;

import com.supermarket.model.Category;
import com.supermarket.model.Product; // 关键：添加Product类的导入
import com.supermarket.util.MongoDBUtil;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.List;

/**
 * 分类数据访问层：优化删除逻辑，修复导入与语法错误
 */
public class CategoryDAO {
    // 获取分类集合
    private MongoCollection<Document> getCollection() {
        MongoDatabase db = MongoDBUtil.getDatabase();
        return db.getCollection("category");
    }

    // 添加分类
    public boolean addCategory(Category category) {
        try {
            Document doc = new Document()
                    .append("categoryName", category.getCategoryName())
                    .append("description", category.getDescription());
            getCollection().insertOne(doc);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 查询所有分类（用于商品添加/编辑时的下拉选择）
    public List<Category> getAllCategories() {
        List<Category> categoryList = new ArrayList<>();
        FindIterable<Document> iterable = getCollection().find();
        for (Document doc : iterable) {
            Category category = new Category();
            category.setId(doc.getObjectId("_id").toString());
            category.setCategoryName(doc.getString("categoryName"));
            category.setDescription(doc.getString("description"));
            categoryList.add(category);
        }
        return categoryList;
    }

    // 按ID查询分类
    public Category getCategoryById(String id) {
        if (!ObjectId.isValid(id)) return null;
        Document doc = getCollection().find(Filters.eq("_id", new ObjectId(id))).first();
        if (doc == null) return null;
        Category category = new Category();
        category.setId(doc.getObjectId("_id").toString());
        category.setCategoryName(doc.getString("categoryName"));
        category.setDescription(doc.getString("description"));
        return category;
    }

    // 更新分类
    public boolean updateCategory(Category category) {
        if (!ObjectId.isValid(category.getId())) return false;
        Document updateDoc = new Document()
                .append("$set", new Document()
                        .append("categoryName", category.getCategoryName())
                        .append("description", category.getDescription()));
        UpdateResult result = getCollection().updateOne(
                Filters.eq("_id", new ObjectId(category.getId())),
                updateDoc
        );
        return result.getModifiedCount() > 0;
    }

    // 删除分类（优化逻辑：先判断是否有商品关联，避免数据冗余）
    public boolean deleteCategory(String id) {
        if (!ObjectId.isValid(id)) return false;
        
        // 1. 实例化ProductDAO，查询所有商品判断关联
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getAllProducts(); // 替换为查询所有商品的方法，更高效
        
        // 2. 遍历商品，检查是否关联当前分类
        for (Product product : products) {
            if (id.equals(product.getCategoryId())) {
                throw new RuntimeException("该分类下存在商品，无法删除"); // 修复语法错误：补充引号和分号
            }
        }
        
        // 3. 无关联则执行删除
        DeleteResult result = getCollection().deleteOne(Filters.eq("_id", new ObjectId(id)));
        return result.getDeletedCount() > 0;
    }
}