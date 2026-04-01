package com.attendance;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = {"com.attendance"}, excludeFilters = {
    @org.springframework.context.annotation.ComponentScan.Filter(
        type = org.springframework.context.annotation.FilterType.REGEX,
        pattern = "com\\.attendance\\.servlet\\..*"
    )
})
@ServletComponentScan
public class StudentAttendanceApplication {

    public static void main(String[] args) {
        SpringApplication.run(StudentAttendanceApplication.class, args);
    }
}
