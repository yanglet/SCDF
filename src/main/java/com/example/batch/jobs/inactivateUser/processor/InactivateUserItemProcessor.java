package com.example.batch.jobs.inactivateUser.processor;

import com.example.batch.application.user.dto.UserDto;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.stereotype.Component;

@Component
public class InactivateUserItemProcessor implements ItemProcessor<UserDto, Long> {

    @Override
    public Long process(UserDto item) {
        return item.userId();
    }
}
