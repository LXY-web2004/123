package com.supermarket.util;

import java.util.regex.Pattern;

public class CommonUtil {
    // 商品编号正则（SP+3位数字）
    private static final Pattern PRODUCT_NO_PATTERN = Pattern.compile("^SP\\d{3}$");
    // 价格正则（正数，最多两位小数）
    private static final Pattern PRICE_PATTERN = Pattern.compile("^\\d+(\\.\\d{1,2})?$");

    // XSS过滤（防止脚本注入）
    public static String filterXSS(String input) {
        if (input == null || input.isEmpty()) return "";
        return input.replaceAll("<", "&lt;")
                    .replaceAll(">", "&gt;")
                    .replaceAll("'", "&#39;")
                    .replaceAll("\"", "&quot;");
    }

    // 商品编号校验
    public static boolean isValidProductNo(String productNo) {
        return productNo != null && PRODUCT_NO_PATTERN.matcher(productNo).matches();
    }

    // 价格校验
    public static boolean isValidPrice(Double price) {
        return price != null && price > 0 && PRICE_PATTERN.matcher(price.toString()).matches();
    }

    // 库存校验（非负整数）
    public static boolean isValidStock(Integer stock) {
        return stock != null && stock >= 0;
    }
}