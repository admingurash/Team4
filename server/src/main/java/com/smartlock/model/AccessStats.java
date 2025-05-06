package com.smartlock.model;

public class AccessStats {
    private int totalAttempts;
    private int grantedAttempts;
    private int deniedAttempts;
    private int overtimeAttempts;
    private int excessiveAttempts;

    // Getters and Setters
    public int getTotalAttempts() {
        return totalAttempts;
    }

    public void setTotalAttempts(int totalAttempts) {
        this.totalAttempts = totalAttempts;
    }

    public int getGrantedAttempts() {
        return grantedAttempts;
    }

    public void setGrantedAttempts(int grantedAttempts) {
        this.grantedAttempts = grantedAttempts;
    }

    public int getDeniedAttempts() {
        return deniedAttempts;
    }

    public void setDeniedAttempts(int deniedAttempts) {
        this.deniedAttempts = deniedAttempts;
    }

    public int getOvertimeAttempts() {
        return overtimeAttempts;
    }

    public void setOvertimeAttempts(int overtimeAttempts) {
        this.overtimeAttempts = overtimeAttempts;
    }

    public int getExcessiveAttempts() {
        return excessiveAttempts;
    }

    public void setExcessiveAttempts(int excessiveAttempts) {
        this.excessiveAttempts = excessiveAttempts;
    }
} 