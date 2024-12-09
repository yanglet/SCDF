package com.example.batch.jobs.inactivateUser.reader;

import com.example.batch.application.user.dto.UserDto;
import com.example.batch.application.user.service.UserService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.item.ItemStreamException;
import org.springframework.batch.item.database.AbstractPagingItemReader;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import static com.example.batch.jobs.inactivateUser.job.InactivateUserJobConfiguration.ACTIVE_DAYS;
import static com.example.batch.jobs.inactivateUser.job.InactivateUserJobConfiguration.CHUNK_SIZE;

@Component
@RequiredArgsConstructor
public class InactivateUserItemReader extends AbstractPagingItemReader<UserDto> {

    private final UserService userService;

    private LocalDateTime now;
    private Long currentId;

    @PostConstruct
    public void init() {
        currentId = 0L;
        setPageSize(CHUNK_SIZE);
    }

    @Override
    public void open(ExecutionContext executionContext) throws ItemStreamException {
        executionContext.getLong("CURRENT_ID", currentId);
        now = LocalDateTime.now();
    }

    @Override
    public void update(ExecutionContext executionContext) throws ItemStreamException {
        executionContext.getLong("CURRENT_ID", currentId);
    }

    @Override
    protected void doReadPage() {
        if (results == null) {
            results = new CopyOnWriteArrayList<>();
        } else {
            currentId = results.get(results.size() - 1).userId();
            results.clear();
        }

        LocalDateTime lastActiveDays = getLastActiveDays();
        List<UserDto> users = userService.getUsersByCurrentIdAndLastLoginDate(
                currentId,
                lastActiveDays,
                Pageable.ofSize(CHUNK_SIZE));
        results.addAll(users);
    }

    private LocalDateTime getLastActiveDays() {
        return now.minusDays(ACTIVE_DAYS);
    }
}
