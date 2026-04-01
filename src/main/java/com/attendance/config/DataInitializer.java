package com.attendance.config;

import com.attendance.model.*;
import com.attendance.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Override
    public void run(String... args) throws Exception {
        // Skip initialization if data already exists (prevents duplicate key errors on
        // restart)
        if (userRepository.existsByUsername("admin")) {
            System.out.println("=== Demo data already initialized. Skipping. ===");
            return;
        }

        // Create Admin user
        User admin = new User("admin", "admin", "System Administrator", "admin@university.edu", User.Role.ADMIN);
        userRepository.save(admin);

        // Create Faculty members
        User faculty1 = new User("faculty1", "password123", "Dr. Rajesh Kumar", "rajesh@university.edu",
                User.Role.FACULTY);
        User faculty2 = new User("faculty2", "password123", "Prof. Priya Sharma", "priya@university.edu",
                User.Role.FACULTY);
        userRepository.save(faculty1);
        userRepository.save(faculty2);

        // Create Students
        User student1 = new User("student1", "password123", "Amit Patel", "amit@student.edu", User.Role.STUDENT);
        User student2 = new User("student2", "password123", "Sneha Reddy", "sneha@student.edu", User.Role.STUDENT);
        User student3 = new User("student3", "password123", "Rahul Verma", "rahul@student.edu", User.Role.STUDENT);
        User student4 = new User("student4", "password123", "Ananya Gupta", "ananya@student.edu", User.Role.STUDENT);
        User student5 = new User("student5", "password123", "Vikram Singh", "vikram@student.edu", User.Role.STUDENT);
        userRepository.save(student1);
        userRepository.save(student2);
        userRepository.save(student3);
        userRepository.save(student4);
        userRepository.save(student5);

        // Create Courses
        Course cs101 = new Course("Data Structures & Algorithms", "CS101", faculty1);
        Course cs102 = new Course("Database Management Systems", "CS102", faculty1);
        Course cs201 = new Course("Web Technologies", "CS201", faculty2);
        Course cs202 = new Course("Operating Systems", "CS202", faculty2);
        courseRepository.save(cs101);
        courseRepository.save(cs102);
        courseRepository.save(cs201);
        courseRepository.save(cs202);

        // Enroll Students in Courses
        enrollmentRepository.save(new Enrollment(student1, cs101));
        enrollmentRepository.save(new Enrollment(student2, cs101));
        enrollmentRepository.save(new Enrollment(student3, cs101));
        enrollmentRepository.save(new Enrollment(student4, cs101));
        enrollmentRepository.save(new Enrollment(student5, cs101));

        enrollmentRepository.save(new Enrollment(student1, cs102));
        enrollmentRepository.save(new Enrollment(student2, cs102));
        enrollmentRepository.save(new Enrollment(student3, cs102));

        enrollmentRepository.save(new Enrollment(student1, cs201));
        enrollmentRepository.save(new Enrollment(student2, cs201));
        enrollmentRepository.save(new Enrollment(student3, cs201));
        enrollmentRepository.save(new Enrollment(student4, cs201));

        enrollmentRepository.save(new Enrollment(student3, cs202));
        enrollmentRepository.save(new Enrollment(student4, cs202));
        enrollmentRepository.save(new Enrollment(student5, cs202));

        // Seed some attendance data for the past week
        LocalDate today = LocalDate.now();

        // CS101 - Day 1 (3 days ago)
        LocalDate day1 = today.minusDays(3);
        attendanceRepository.save(new Attendance(student1, cs101, day1, Attendance.AttendanceStatus.PRESENT, faculty1));
        attendanceRepository.save(new Attendance(student2, cs101, day1, Attendance.AttendanceStatus.PRESENT, faculty1));
        attendanceRepository.save(new Attendance(student3, cs101, day1, Attendance.AttendanceStatus.ABSENT, faculty1));
        attendanceRepository.save(new Attendance(student4, cs101, day1, Attendance.AttendanceStatus.PRESENT, faculty1));
        attendanceRepository.save(new Attendance(student5, cs101, day1, Attendance.AttendanceStatus.LATE, faculty1));

        // CS101 - Day 2 (2 days ago)
        LocalDate day2 = today.minusDays(2);
        attendanceRepository.save(new Attendance(student1, cs101, day2, Attendance.AttendanceStatus.PRESENT, faculty1));
        attendanceRepository.save(new Attendance(student2, cs101, day2, Attendance.AttendanceStatus.ABSENT, faculty1));
        attendanceRepository.save(new Attendance(student3, cs101, day2, Attendance.AttendanceStatus.PRESENT, faculty1));
        attendanceRepository.save(new Attendance(student4, cs101, day2, Attendance.AttendanceStatus.PRESENT, faculty1));
        attendanceRepository.save(new Attendance(student5, cs101, day2, Attendance.AttendanceStatus.PRESENT, faculty1));

        // CS101 - Day 3 (yesterday)
        LocalDate day3 = today.minusDays(1);
        attendanceRepository.save(new Attendance(student1, cs101, day3, Attendance.AttendanceStatus.PRESENT, faculty1));
        attendanceRepository.save(new Attendance(student2, cs101, day3, Attendance.AttendanceStatus.PRESENT, faculty1));
        attendanceRepository.save(new Attendance(student3, cs101, day3, Attendance.AttendanceStatus.PRESENT, faculty1));
        attendanceRepository.save(new Attendance(student4, cs101, day3, Attendance.AttendanceStatus.ABSENT, faculty1));
        attendanceRepository.save(new Attendance(student5, cs101, day3, Attendance.AttendanceStatus.PRESENT, faculty1));

        // CS201 - Day 1 (2 days ago)
        attendanceRepository.save(new Attendance(student1, cs201, day2, Attendance.AttendanceStatus.PRESENT, faculty2));
        attendanceRepository.save(new Attendance(student2, cs201, day2, Attendance.AttendanceStatus.PRESENT, faculty2));
        attendanceRepository.save(new Attendance(student3, cs201, day2, Attendance.AttendanceStatus.ABSENT, faculty2));
        attendanceRepository.save(new Attendance(student4, cs201, day2, Attendance.AttendanceStatus.LATE, faculty2));

        System.out.println("=== Demo Data Initialized Successfully ===");
        System.out.println("Admin: admin/admin");
        System.out.println("Faculty: faculty1/password123, faculty2/password123");
        System.out.println("Students: student1-5/password123");
    }
}
