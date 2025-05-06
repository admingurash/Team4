package com.smartlock.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "access_logs")
public class AccessLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "card_id")
    private String cardId;

    @Column(name = "access_time")
    private LocalDateTime accessTime;

    @Column(name = "location")
    private String location;

    @Column(name = "status")
    private String status;

    @Column(name = "attempt_count")
    private Integer attemptCount;

    @Column(name = "is_overtime")
    private Boolean isOvertime;

    @Column(name = "is_excessive_attempt")
    private Boolean isExcessiveAttempt;

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getCardId() {
        return cardId;
    }

    public void setCardId(String cardId) {
        this.cardId = cardId;
    }

    public LocalDateTime getAccessTime() {
        return accessTime;
    }

    public void setAccessTime(LocalDateTime accessTime) {
        this.accessTime = accessTime;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getAttemptCount() {
        return attemptCount;
    }

    public void setAttemptCount(Integer attemptCount) {
        this.attemptCount = attemptCount;
    }

    public Boolean getIsOvertime() {
        return isOvertime;
    }

    public void setIsOvertime(Boolean overtime) {
        isOvertime = overtime;
    }

    public Boolean getIsExcessiveAttempt() {
        return isExcessiveAttempt;
    }

    public void setIsExcessiveAttempt(Boolean excessiveAttempt) {
        isExcessiveAttempt = excessiveAttempt;
    }
} 