package com.attendance.service;

import com.attendance.model.*;
import com.attendance.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class AdminService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    // ===== User Management =====

    public List<User> getAllFaculty() {
        return userRepository.findAll().stream()
                .filter(u -> u.getRole() == User.Role.FACULTY)
                .collect(Collectors.toList());
    }

    public List<User> getAllStudents() {
        return userRepository.findAll().stream()
                .filter(u -> u.getRole() == User.Role.STUDENT)
                .collect(Collectors.toList());
    }

    @SuppressWarnings("null")
    public User getUserById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    @SuppressWarnings("null")
    public User saveUser(User user) {
        return userRepository.save(user);
    }

    public User createFaculty(String username, String password, String fullName, String email) {
        if (userRepository.existsByUsername(username))
            return null;
        User faculty = new User(username, password, fullName, email, User.Role.FACULTY);
        return userRepository.save(faculty);
    }

    public User createStudent(String username, String password, String fullName, String email) {
        if (userRepository.existsByUsername(username))
            return null;
        User student = new User(username, password, fullName, email, User.Role.STUDENT);
        return userRepository.save(student);
    }

    @SuppressWarnings("null")
    public User updateUser(Long id, String fullName, String username, String email, String password) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null)
            return null;
        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName);
        }
        if (username != null && !username.trim().isEmpty()) {
            user.setUsername(username);
        }
        if (email != null && !email.trim().isEmpty()) {
            user.setEmail(email);
        }
        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(password);
        }
        return userRepository.save(user);
    }

    // ===== Course Management =====

    public List<Course> getAllCourses() {
        return courseRepository.findAll();
    }

    @SuppressWarnings("null")
    public Course getCourseById(Long id) {
        return courseRepository.findById(id).orElse(null);
    }

    public Course createCourse(String courseName, String courseCode, Long facultyId) {
        if (courseRepository.existsByCourseName(courseName))
            return null;
        if (courseRepository.existsByCourseCode(courseCode))
            return null;
        User faculty = null;
        if (facultyId != null) {
            faculty = userRepository.findById(facultyId).orElse(null);
        }
        Course course = new Course(courseName, courseCode, faculty);
        return courseRepository.save(course);
    }

    @SuppressWarnings("null")
    public Course updateCourse(Long id, String courseName, String courseCode, Long facultyId) {
        Course course = courseRepository.findById(id).orElse(null);
        if (course == null)
            return null;
        if (courseName != null && !courseName.trim().isEmpty()) {
            course.setCourseName(courseName);
        }
        if (courseCode != null && !courseCode.trim().isEmpty()) {
            course.setCourseCode(courseCode);
        }
        if (facultyId != null) {
            User faculty = userRepository.findById(facultyId).orElse(null);
            if (faculty != null && faculty.getRole() == User.Role.FACULTY) {
                course.setFaculty(faculty);
            }
        }
        return courseRepository.save(course);
    }

    // ===== Enrollment Management =====

    @SuppressWarnings("null")
    public void enrollStudentInCourse(Long studentId, Long courseId) {
        User student = userRepository.findById(studentId).orElse(null);
        Course course = courseRepository.findById(courseId).orElse(null);
        if (student != null && course != null && !enrollmentRepository.existsByStudentAndCourse(student, course)) {
            enrollmentRepository.save(new Enrollment(student, course));
        }
    }

    public List<Course> getCoursesForStudent(Long studentId) {
        return enrollmentRepository.findByStudentId(studentId).stream()
                .map(Enrollment::getCourse)
                .collect(Collectors.toList());
    }

    public List<Course> getCoursesForFaculty(Long facultyId) {
        return courseRepository.findByFacultyId(facultyId);
    }

    // ===== Reports =====

    /**
     * Get the number of distinct dates a faculty has marked attendance for each
     * course.
     */
    public Map<Course, Long> getFacultyClassesEngaged(Long facultyId) {
        List<Course> courses = courseRepository.findByFacultyId(facultyId);
        Map<Course, Long> classesMap = new LinkedHashMap<>();
        for (Course course : courses) {
            List<Attendance> records = attendanceRepository.findByCourse(course);
            long distinctDates = records.stream()
                    .map(Attendance::getDate)
                    .distinct()
                    .count();
            classesMap.put(course, distinctDates);
        }
        return classesMap;
    }

    /**
     * Get overall system stats.
     */
    public Map<String, Object> getSystemStats() {
        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("totalFaculty", getAllFaculty().size());
        stats.put("totalStudents", getAllStudents().size());
        stats.put("totalCourses", courseRepository.count());
        stats.put("totalAttendanceRecords", attendanceRepository.count());
        stats.put("totalEnrollments", enrollmentRepository.count());
        return stats;
    }

    /**
     * Get attendance summary for all courses.
     */
    public List<Map<String, Object>> getAllCourseReports() {
        List<Map<String, Object>> reports = new ArrayList<>();
        List<Course> courses = courseRepository.findAll();
        for (Course course : courses) {
            Map<String, Object> report = new LinkedHashMap<>();
            report.put("course", course);
            List<Enrollment> enrollments = enrollmentRepository.findByCourseId(course.getId());
            report.put("enrolledStudents", enrollments.size());
            List<Attendance> records = attendanceRepository.findByCourse(course);
            long distinctDates = records.stream().map(Attendance::getDate).distinct().count();
            report.put("totalClasses", distinctDates);
            long presentCount = records.stream().filter(a -> a.getStatus() == Attendance.AttendanceStatus.PRESENT)
                    .count();
            long totalRecords = records.size();
            double avgAttendance = 100.0;
            if (distinctDates > 0 && totalRecords > 0) {
                avgAttendance = ((double) presentCount / totalRecords * 100.0);
            }
            report.put("avgAttendance", Math.round(avgAttendance * 100.0) / 100.0);
            reports.add(report);
        }
        return reports;
    }
}
