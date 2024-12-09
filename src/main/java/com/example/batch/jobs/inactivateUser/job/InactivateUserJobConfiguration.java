package com.example.batch.jobs.inactivateUser.job;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemWriter;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
public class InactivateUserJobConfiguration {

    public static final int CHUNK_SIZE = 2000;
    public static final int ACTIVE_DAYS = 60;

    private final ItemReader itemReader;
    private final ItemWriter itemWriter;
    private final ItemProcessor itemProcessor;

    public InactivateUserJobConfiguration(
            @Qualifier(value = "inactivateUserItemReader") ItemReader itemReader,
            @Qualifier(value = "inactivateUserItemWriter") ItemWriter itemWriter,
            @Qualifier(value = "inactivateUserItemProcessor") ItemProcessor itemProcessor) {
        this.itemReader = itemReader;
        this.itemWriter = itemWriter;
        this.itemProcessor = itemProcessor;
    }

    @Bean
    public Job inactivateUserJob(JobRepository jobRepository, PlatformTransactionManager transactionManager) {
        return new JobBuilder("inactivateUserJob", jobRepository)
                .start(inactivateUserStep(jobRepository, transactionManager))
                .build();
    }

    @Bean
    public Step inactivateUserStep(JobRepository jobRepository, PlatformTransactionManager transactionManager) {
        return new StepBuilder("inactivateUserStep", jobRepository)
                .chunk(CHUNK_SIZE, transactionManager)
                .reader(itemReader)
                .processor(itemProcessor)
                .writer(itemWriter)
                .build();
    }
}