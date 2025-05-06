package com.smartlock.model;

public class AccessResponse {
    private boolean granted;
    private String message;

    public AccessResponse(boolean granted, String message) {
        this.granted = granted;
        this.message = message;
    }

    // Getters and Setters
    public boolean isGranted() {
        return granted;
    }

    public void setGranted(boolean granted) {
        this.granted = granted;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
} 