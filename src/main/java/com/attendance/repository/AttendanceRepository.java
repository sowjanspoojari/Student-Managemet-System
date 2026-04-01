package com.attendance.repository;

import com.attendance.model.Attendance;
import com.attendance.model.Course;
import com.attendance.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Long> {

    List<Attendance> findByCourseAndDate(Course course, LocalDate date);

    List<Attendance> findByCourseIdAndDate(Long courseId, LocalDate date);

    List<Attendance> findByStudentAndCourse(User student, Course course);

    List<Attendance> findByStudentIdAndCourseId(Long studentId, Long courseId);

    List<Attendance> findByStudent(User student);

    List<Attendance> findByStudentId(Long studentId);

    List<Attendance> findByCourse(Course course);

    List<Attendance> findByCourseId(Long courseId);

    List<Attendance> findByCourseAndDateBetween(Course course, LocalDate startDate, LocalDate endDate);

    List<Attendance> findByCourseIdAndDateBetween(Long courseId, LocalDate startDate, LocalDate endDate);

    List<Attendance> findByStudentAndCourseAndDateBetween(User student, Course course, LocalDate startDate,
            LocalDate endDate);

    // Returns all matching records (handles legacy duplicates gracefully)
    List<Attendance> findByStudentIdAndCourseIdAndDate(Long studentId, Long courseId, LocalDate date);

    @Query("SELECT COUNT(a) FROM Attendance a WHERE a.student.id = :studentId AND a.course.id = :courseId AND a.status = 'PRESENT'")
    long countPresentByStudentAndCourse(@Param("studentId") Long studentId, @Param("courseId") Long courseId);

    @Query("SELECT COUNT(a) FROM Attendance a WHERE a.student.id = :studentId AND a.course.id = :courseId")
    long countTotalByStudentAndCourse(@Param("studentId") Long studentId, @Param("courseId") Long courseId);

    boolean existsByCourseAndDateAndStudent(Course course, LocalDate date, User student);
}
