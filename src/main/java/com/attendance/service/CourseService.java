package com.attendance.service;

import com.attendance.model.Course;
import com.attendance.model.Enrollment;
import com.attendance.model.User;
import com.attendance.repository.CourseRepository;
import com.attendance.repository.EnrollmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CourseService {

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    /**
     * Get all courses taught by a faculty member.
     */
    public List<Course> getCoursesByFaculty(Long facultyId) {
        return courseRepository.findByFacultyId(facultyId);
    }

    /**
     * Get all students enrolled in a course.
     */
    public List<User> getStudentsByCourse(Long courseId) {
        List<Enrollment> enrollments = enrollmentRepository.findByCourseId(courseId);
        List<User> students = new ArrayList<>();
        for (Enrollment enrollment : enrollments) {
            students.add(enrollment.getStudent());
        }
        return students;
    }

    /**
     * Get all courses a student is enrolled in.
     */
    public List<Course> getCoursesByStudent(Long studentId) {
        List<Enrollment> enrollments = enrollmentRepository.findByStudentId(studentId);
        List<Course> courses = new ArrayList<>();
        for (Enrollment enrollment : enrollments) {
            courses.add(enrollment.getCourse());
        }
        return courses;
    }

    /**
     * Get a course by ID.
     */
    @SuppressWarnings("null")
    public Course getCourseById(Long courseId) {
        return courseRepository.findById(courseId).orElse(null);
    }

    /**
     * Get all courses.
     */
    public List<Course> getAllCourses() {
        return courseRepository.findAll();
    }
}
