package com.attendance.service;

import com.attendance.model.*;
import com.attendance.repository.AttendanceRepository;
import com.attendance.repository.CourseRepository;
import com.attendance.repository.EnrollmentRepository;
import com.attendance.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;

@Service
public class AttendanceService {

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    /**
     * Mark attendance for multiple students in a course on a given date.
     */
    @SuppressWarnings("null")
    public void markAttendance(Long courseId, LocalDate date, Map<Long, String> studentStatuses, Long markedById) {
        Course course = courseRepository.findById(courseId).orElseThrow(() -> new RuntimeException("Course not found"));
        User markedBy = userRepository.findById(markedById)
                .orElseThrow(() -> new RuntimeException("Faculty not found"));

        for (Map.Entry<Long, String> entry : studentStatuses.entrySet()) {
            Long studentId = entry.getKey();
            String statusStr = entry.getValue();

            Attendance.AttendanceStatus status = Attendance.AttendanceStatus.valueOf(statusStr.toUpperCase());

            // Look up all records for this (student, course, date)
            List<Attendance> existing = attendanceRepository.findByStudentIdAndCourseIdAndDate(studentId,
                    courseId, date);

            if (!existing.isEmpty()) {
                // Update the first record
                Attendance att = existing.get(0);
                att.setStatus(status);
                att.setMarkedBy(markedBy);
                attendanceRepository.save(att);

                // Clean up any duplicate records left over from the old bug
                for (int i = 1; i < existing.size(); i++) {
                    @SuppressWarnings("null")
                    Attendance toDelete = existing.get(i);
                    attendanceRepository.delete(toDelete);
                }
            } else {
                // Create a brand-new record
                @SuppressWarnings("null")
                User student = userRepository.findById(studentId)
                        .orElseThrow(() -> new RuntimeException("Student not found"));
                Attendance attendance = new Attendance(student, course, date, status, markedBy);
                attendanceRepository.save(attendance);
            }
        }
    }

    /**
     * Get attendance records for a course on a specific date.
     */
    public List<Attendance> getAttendanceByCourseAndDate(Long courseId, LocalDate date) {
        return attendanceRepository.findByCourseIdAndDate(courseId, date);
    }

    /**
     * Get attendance records for a course within a date range.
     */
    public List<Attendance> getAttendanceByCourseAndDateRange(Long courseId, LocalDate startDate, LocalDate endDate) {
        return attendanceRepository.findByCourseIdAndDateBetween(courseId, startDate, endDate);
    }

    /**
     * Get all attendance records for a specific student.
     */
    public List<Attendance> getStudentAttendance(Long studentId) {
        return attendanceRepository.findByStudentId(studentId);
    }

    /**
     * Get attendance records for a student in a specific course.
     */
    public List<Attendance> getStudentAttendanceByCourse(Long studentId, Long courseId) {
        return attendanceRepository.findByStudentIdAndCourseId(studentId, courseId);
    }

    /**
     * Calculate attendance percentage for a student in a course.
     */
    public double calculateAttendancePercentage(Long studentId, Long courseId) {
        long total = attendanceRepository.countTotalByStudentAndCourse(studentId, courseId);
        if (total == 0)
            return 0.0;
        long present = attendanceRepository.countPresentByStudentAndCourse(studentId, courseId);
        return (double) present / total * 100.0;
    }

    /**
     * Get all attendance records for a course.
     */
    public List<Attendance> getAttendanceByCourse(Long courseId) {
        return attendanceRepository.findByCourseId(courseId);
    }

    /**
     * Get attendance summary: map of student -> percentage for a course.
     */
    public Map<User, Double> getCourseSummary(Long courseId) {
        List<Enrollment> enrollments = enrollmentRepository.findByCourseId(courseId);
        Map<User, Double> summary = new LinkedHashMap<>();
        for (Enrollment enrollment : enrollments) {
            Long studentId = enrollment.getStudent().getId();
            double percentage = calculateAttendancePercentage(studentId, courseId);
            summary.put(enrollment.getStudent(), percentage);
        }
        return summary;
    }
}
