package com.smartlock.controller;

import com.smartlock.model.AccessLog;
import com.smartlock.model.User;
import com.smartlock.service.AccessService;
import com.smartlock.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@RestController
@RequestMapping("/api/access")
public class AccessController {

    @Autowired
    private AccessService accessService;

    @Autowired
    private NotificationService notificationService;

    private static final LocalTime WORK_START_TIME = LocalTime.of(9, 0);
    private static final LocalTime WORK_END_TIME = LocalTime.of(18, 0);
    private static final int MAX_ATTEMPTS_PER_HOUR = 5;
    private static final int MAX_ATTEMPTS_PER_DAY = 20;

    @PostMapping("/verify")
    public ResponseEntity<?> verifyAccess(@RequestBody AccessRequest request) {
        LocalDateTime now = LocalDateTime.now();
        LocalTime currentTime = now.toLocalTime();
        User user = accessService.getUserByCardId(request.getCardId());

        // Check if access is outside working hours
        boolean isOvertime = currentTime.isBefore(WORK_START_TIME) || currentTime.isAfter(WORK_END_TIME);
        
        // Check access attempts
        int hourlyAttempts = accessService.getAccessAttemptsInLastHour(user.getId());
        int dailyAttempts = accessService.getAccessAttemptsInLastDay(user.getId());
        
        boolean isExcessiveHourly = hourlyAttempts >= MAX_ATTEMPTS_PER_HOUR;
        boolean isExcessiveDaily = dailyAttempts >= MAX_ATTEMPTS_PER_DAY;

        // Log the access attempt
        AccessLog log = new AccessLog();
        log.setUserId(user.getId());
        log.setCardId(request.getCardId());
        log.setAccessTime(now);
        log.setLocation(request.getLocation());
        log.setStatus("DENIED");
        log.setAttemptCount(hourlyAttempts + 1);
        log.setIsOvertime(isOvertime);
        log.setIsExcessiveAttempt(isExcessiveHourly || isExcessiveDaily);
        
        accessService.logAccess(log);

        // Check if we need to notify admin
        if (isOvertime || isExcessiveHourly || isExcessiveDaily) {
            String message = String.format(
                "Security Alert: User %s attempted access with following issues:\n" +
                "- Overtime Access: %s\n" +
                "- Excessive Hourly Attempts: %s (%d attempts)\n" +
                "- Excessive Daily Attempts: %s (%d attempts)",
                user.getName(),
                isOvertime ? "Yes" : "No",
                isExcessiveHourly ? "Yes" : "No",
                hourlyAttempts,
                isExcessiveDaily ? "Yes" : "No",
                dailyAttempts
            );
            notificationService.sendAdminNotification(message);
        }

        // Determine access status
        if (isOvertime) {
            return ResponseEntity.ok(new AccessResponse(false, "Access denied: Outside working hours"));
        }
        if (isExcessiveHourly) {
            return ResponseEntity.ok(new AccessResponse(false, "Access denied: Too many attempts in the last hour"));
        }
        if (isExcessiveDaily) {
            return ResponseEntity.ok(new AccessResponse(false, "Access denied: Too many attempts today"));
        }

        // If all checks pass, grant access
        log.setStatus("GRANTED");
        accessService.logAccess(log);
        return ResponseEntity.ok(new AccessResponse(true, "Access granted"));
    }

    @GetMapping("/logs")
    public ResponseEntity<List<AccessLog>> getAccessLogs(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String cardId,
            @RequestParam(required = false) LocalDateTime startTime,
            @RequestParam(required = false) LocalDateTime endTime) {
        return ResponseEntity.ok(accessService.getAccessLogs(userId, cardId, startTime, endTime));
    }

    @GetMapping("/stats")
    public ResponseEntity<AccessStats> getAccessStats(
            @RequestParam(required = false) LocalDateTime startTime,
            @RequestParam(required = false) LocalDateTime endTime) {
        return ResponseEntity.ok(accessService.getAccessStats(startTime, endTime));
    }
} 