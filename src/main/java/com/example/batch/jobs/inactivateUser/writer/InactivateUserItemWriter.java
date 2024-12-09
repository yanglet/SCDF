package com.example.batch.jobs.inactivateUser.writer;

import com.example.batch.application.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.item.Chunk;
import org.springframework.batch.item.ItemWriter;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class InactivateUserItemWriter implements ItemWriter<Long> {

    private final UserService userService;

    @Override
    public void write(Chunk<? extends Long> chunk) {
        List<Long> userIds = (List<Long>) chunk.getItems();
        userService.inactivateUsers(userIds);
    }
}
