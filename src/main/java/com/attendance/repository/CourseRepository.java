package com.attendance.repository;

import com.attendance.model.Course;
import com.attendance.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {
    List<Course> findByFaculty(User faculty);

    List<Course> findByFacultyId(Long facultyId);

    boolean existsByCourseName(String courseName);

    boolean existsByCourseCode(String courseCode);
}
