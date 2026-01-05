package com.supermarket.dao;

import com.supermarket.model.Product;
import com.supermarket.util.MongoDBUtil;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    // 获取商品集合
    private MongoCollection<Document> getCollection() {
        MongoDatabase db = MongoDBUtil.getDatabase();
        return db.getCollection("product");
    }

    // 添加商品
    public boolean addProduct(Product product) {
        try {
            Document doc = new Document()
                    .append("productNo", product.getProductNo())
                    .append("productName", product.getProductName())
                    .append("categoryId", product.getCategoryId())
                    .append("price", product.getPrice())
                    .append("stock", product.getStock())
                    .append("productionDate", product.getProductionDate())
                    .append("supplier", product.getSupplier())
                    .append("description", product.getDescription())
                    .append("createTime", product.getCreateTime());
            getCollection().insertOne(doc);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 查询所有商品
    public List<Product> getAllProducts() {
        List<Product> productList = new ArrayList<>();
        FindIterable<Document> iterable = getCollection().find();
        for (Document doc : iterable) {
            productList.add(docToProduct(doc));
        }
        return productList;
    }

    // 按ID查询商品
    public Product getProductById(String id) {
        if (!ObjectId.isValid(id)) return null;
        Document doc = getCollection().find(Filters.eq("_id", new ObjectId(id))).first();
        return doc != null ? docToProduct(doc) : null;
    }

    // 模糊查询（按商品名称/编号）
    public List<Product> searchProducts(String keyword) {
        List<Product> productList = new ArrayList<>();
        Bson filter = Filters.or(
                Filters.regex("productName", keyword, "i"), // 不区分大小写
                Filters.regex("productNo", keyword, "i")
        );
        FindIterable<Document> iterable = getCollection().find(filter);
        for (Document doc : iterable) {
            productList.add(docToProduct(doc));
        }
        return productList;
    }

    // 更新商品
    public boolean updateProduct(Product product) {
        if (!ObjectId.isValid(product.getId())) return false;
        Document updateDoc = new Document()
                .append("$set", new Document()
                        .append("productNo", product.getProductNo())
                        .append("productName", product.getProductName())
                        .append("categoryId", product.getCategoryId())
                        .append("price", product.getPrice())
                        .append("stock", product.getStock())
                        .append("productionDate", product.getProductionDate())
                        .append("supplier", product.getSupplier())
                        .append("description", product.getDescription()));
        UpdateResult result = getCollection().updateOne(
                Filters.eq("_id", new ObjectId(product.getId())),
                updateDoc
        );
        return result.getModifiedCount() > 0;
    }

    // 删除商品
    public boolean deleteProduct(String id) {
        if (!ObjectId.isValid(id)) return false;
        DeleteResult result = getCollection().deleteOne(Filters.eq("_id", new ObjectId(id)));
        return result.getDeletedCount() > 0;
    }

    // Document转Product实体
    private Product docToProduct(Document doc) {
        Product product = new Product();
        product.setId(doc.getObjectId("_id").toString());
        product.setProductNo(doc.getString("productNo"));
        product.setProductName(doc.getString("productName"));
        product.setCategoryId(doc.getString("categoryId"));
        product.setPrice(doc.getDouble("price"));
        product.setStock(doc.getInteger("stock"));
        product.setProductionDate(doc.getDate("productionDate"));
        product.setSupplier(doc.getString("supplier"));
        product.setDescription(doc.getString("description"));
        product.setCreateTime(doc.getDate("createTime"));
        return product;
    }
}