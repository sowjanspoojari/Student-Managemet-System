package com.attendance.repository;

import com.attendance.model.Course;
import com.attendance.model.Enrollment;
import com.attendance.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {
    List<Enrollment> findByCourse(Course course);
    List<Enrollment> findByCourseId(Long courseId);
    List<Enrollment> findByStudent(User student);
    List<Enrollment> findByStudentId(Long studentId);
    boolean existsByStudentAndCourse(User student, Course course);
}
