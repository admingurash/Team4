package com.smartlock.service;

import com.smartlock.model.AccessLog;
import com.smartlock.model.User;
import com.smartlock.repository.AccessLogRepository;
import com.smartlock.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class AccessService {

    @Autowired
    private AccessLogRepository accessLogRepository;

    @Autowired
    private UserRepository userRepository;

    public User getUserByCardId(String cardId) {
        return userRepository.findByCardId(cardId)
                .orElseThrow(() -> new RuntimeException("User not found with card ID: " + cardId));
    }

    public void logAccess(AccessLog log) {
        accessLogRepository.save(log);
    }

    public int getAccessAttemptsInLastHour(Long userId) {
        LocalDateTime oneHourAgo = LocalDateTime.now().minusHours(1);
        return accessLogRepository.countByUserIdAndAccessTimeAfter(userId, oneHourAgo);
    }

    public int getAccessAttemptsInLastDay(Long userId) {
        LocalDateTime oneDayAgo = LocalDateTime.now().minusDays(1);
        return accessLogRepository.countByUserIdAndAccessTimeAfter(userId, oneDayAgo);
    }

    public List<AccessLog> getAccessLogs(Long userId, String cardId, LocalDateTime startTime, LocalDateTime endTime) {
        if (userId != null && cardId != null) {
            return accessLogRepository.findByUserIdAndCardIdAndAccessTimeBetween(userId, cardId, startTime, endTime);
        } else if (userId != null) {
            return accessLogRepository.findByUserIdAndAccessTimeBetween(userId, startTime, endTime);
        } else if (cardId != null) {
            return accessLogRepository.findByCardIdAndAccessTimeBetween(cardId, startTime, endTime);
        } else {
            return accessLogRepository.findByAccessTimeBetween(startTime, endTime);
        }
    }

    public AccessStats getAccessStats(LocalDateTime startTime, LocalDateTime endTime) {
        List<AccessLog> logs = accessLogRepository.findByAccessTimeBetween(startTime, endTime);
        
        AccessStats stats = new AccessStats();
        stats.setTotalAttempts(logs.size());
        stats.setGrantedAttempts((int) logs.stream().filter(log -> "GRANTED".equals(log.getStatus())).count());
        stats.setDeniedAttempts((int) logs.stream().filter(log -> "DENIED".equals(log.getStatus())).count());
        stats.setOvertimeAttempts((int) logs.stream().filter(AccessLog::getIsOvertime).count());
        stats.setExcessiveAttempts((int) logs.stream().filter(AccessLog::getIsExcessiveAttempt).count());
        
        return stats;
    }
} 