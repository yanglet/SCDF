package com.example.batch.application.user.dto;

import java.time.LocalDateTime;

public record UserDto(
        Long userId,
        String name,
        String age,
        boolean active,
        LocalDateTime lastLoginDate
) {
}
