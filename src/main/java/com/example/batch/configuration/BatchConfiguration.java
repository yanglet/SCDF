package com.example.batch.configuration;

import org.slf4j.MDC;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.explore.JobExplorer;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.repository.dao.Jackson2ExecutionContextStringSerializer;
import org.springframework.boot.autoconfigure.batch.BatchProperties;
import org.springframework.boot.autoconfigure.batch.JobLauncherApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;

@Configuration
@EnableBatchProcessing(executionContextSerializerRef = "customSerializer")
public class BatchConfiguration {

    @Bean
    @ConditionalOnProperty(
            prefix = "spring.batch.job",
            name = {"enabled"},
            havingValue = "true",
            matchIfMissing = true
    )
    public JobLauncherApplicationRunner jobLauncherApplicationRunner(
            JobLauncher jobLauncher, JobExplorer jobExplorer, JobRepository jobRepository, BatchProperties properties) {
        JobLauncherApplicationRunner runner = new JobLauncherApplicationRunner(jobLauncher, jobExplorer, jobRepository);
        String jobName = properties.getJob().getName();
        if (StringUtils.hasText(jobName)) {
            runner.setJobName(jobName);
            MDC.put("job.name", jobName);
        }

        return runner;
    }

    @Bean
    public BatchProperties batchProperties() {
        return new BatchProperties();
    }

    /**
     * spring batch 메타테이블 중 Context 에 알아볼 수 있게 저장되도록 ,,
     */
    @Bean
    public Jackson2ExecutionContextStringSerializer customSerializer() {
        return new Jackson2ExecutionContextStringSerializer();
    }
}
