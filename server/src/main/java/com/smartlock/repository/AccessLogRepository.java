package com.smartlock.repository;

import com.smartlock.model.AccessLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AccessLogRepository extends JpaRepository<AccessLog, Long> {
    int countByUserIdAndAccessTimeAfter(Long userId, LocalDateTime time);
    
    List<AccessLog> findByUserIdAndCardIdAndAccessTimeBetween(
        Long userId, String cardId, LocalDateTime startTime, LocalDateTime endTime);
    
    List<AccessLog> findByUserIdAndAccessTimeBetween(
        Long userId, LocalDateTime startTime, LocalDateTime endTime);
    
    List<AccessLog> findByCardIdAndAccessTimeBetween(
        String cardId, LocalDateTime startTime, LocalDateTime endTime);
    
    List<AccessLog> findByAccessTimeBetween(
        LocalDateTime startTime, LocalDateTime endTime);
} 