package com.smartlock.model;

public class AccessRequest {
    private String cardId;
    private String location;

    // Getters and Setters
    public String getCardId() {
        return cardId;
    }

    public void setCardId(String cardId) {
        this.cardId = cardId;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
} 