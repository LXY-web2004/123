package com.supermarket.util;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoDatabase;

/**
 * MongoDB连接工具类：最简版（适配3.12.14驱动），无复杂配置，保证编译+运行成功
 */
public class MongoDBUtil {
    // 数据库配置常量
    private static final String HOST = "localhost";
    private static final int PORT = 27017;
    private static final String DB_NAME = "supermarket_db";
    private static MongoClient mongoClient; // 声明MongoClient实例

    // 静态初始化块：仅执行一次，初始化连接（最简配置）
    static {
        try {
            // 核心修复：使用3.12.14驱动的最简构造方法，无需复杂Options（新手项目足够用）
            mongoClient = new MongoClient(HOST, PORT);
            // 验证连接：确保数据库能正常访问
            mongoClient.getDatabase(DB_NAME).listCollectionNames().first();
            System.out.println("MongoDB连接成功（最简配置适配3.12.14驱动）");
        } catch (Exception e) {
            // 异常处理：抛出明确的初始化失败信息
            throw new RuntimeException("MongoDB连接初始化失败：" + e.getMessage(), e);
        }
    }

    // 获取数据库实例（对外提供的核心方法）
    public static MongoDatabase getDatabase() {
        if (mongoClient == null) {
            throw new RuntimeException("MongoDB客户端未初始化，请检查连接配置");
        }
        return mongoClient.getDatabase(DB_NAME);
    }

    // 关闭MongoClient连接（最简判断，避免版本兼容问题）
    public static void closeClient() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("MongoDB连接已关闭");
        }
    }
}