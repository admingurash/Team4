package com.smartlock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendAdminNotification(String message) {
        SimpleMailMessage email = new SimpleMailMessage();
        email.setTo("admin@company.com"); // 관리자 이메일 주소
        email.setSubject("Smart Lock Security Alert");
        email.setText(message);
        mailSender.send(email);
    }
} 