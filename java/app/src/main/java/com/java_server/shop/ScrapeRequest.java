package com.java_server.shop;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public class ScrapeRequest {

    @JsonProperty("shop_name")
    private List<String> shopName;

    @JsonProperty("shoping_list")
    private List<String> shoppingList;

    public List<String> getShopName() {
        return shopName;
    }

    public void setShopName(List<String> shopName) {
        this.shopName = shopName;
    }

    public List<String> getShoppingList() {
        return shoppingList;
    }

    public void setShoppingList(List<String> shoppingList) {
        this.shoppingList = shoppingList;
    }
}
