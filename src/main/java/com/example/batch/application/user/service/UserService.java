package com.example.batch.application.user.service;

import com.example.batch.application.user.dto.UserDto;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {

    public List<UserDto> getUsersByCurrentIdAndLastLoginDate(
            Long currentId, LocalDateTime lastLoginDate, Pageable pageable) {
        return new ArrayList<>();
    }

    public void inactivateUsers(List<Long> userIds) {
        // update
    }
}
