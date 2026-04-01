package com.attendance.controller;

import com.attendance.model.Attendance;
import com.attendance.model.Course;
import com.attendance.model.User;
import com.attendance.service.AttendanceService;
import com.attendance.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
public class AttendanceController {

    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private CourseService courseService;

    /**
     * Show the attendance marking form for a course (Faculty).
     */
    @GetMapping("/faculty/attendance-form")
    public String attendanceForm(@RequestParam("courseId") Long courseId,
                                  @RequestParam(value = "date", required = false) String dateStr,
                                  @RequestParam(value = "success", required = false) String success,
                                  HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.FACULTY) {
            return "redirect:/login";
        }

        Course course = courseService.getCourseById(courseId);
        List<User> students = courseService.getStudentsByCourse(courseId);

        LocalDate date = (dateStr != null && !dateStr.isEmpty()) ? LocalDate.parse(dateStr) : LocalDate.now();

        // Check existing attendance for this date
        List<Attendance> existingAttendance = attendanceService.getAttendanceByCourseAndDate(courseId, date);
        java.util.Map<Long, String> existingStatuses = new java.util.HashMap<>();
        for (Attendance att : existingAttendance) {
            existingStatuses.put(att.getStudent().getId(), att.getStatus().name());
        }

        model.addAttribute("course", course);
        model.addAttribute("students", students);
        model.addAttribute("date", date.toString());
        model.addAttribute("existingStatuses", existingStatuses);
        model.addAttribute("user", user);

        if ("true".equals(success)) {
            model.addAttribute("success", "Attendance marked successfully!");
        }

        return "mark-attendance";
    }

    /**
     * Faculty: View attendance report for a course.
     */
    @GetMapping("/faculty/attendance-report")
    public String facultyAttendanceReport(@RequestParam("courseId") Long courseId,
                                           @RequestParam(value = "startDate", required = false) String startDateStr,
                                           @RequestParam(value = "endDate", required = false) String endDateStr,
                                           HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.FACULTY) {
            return "redirect:/login";
        }

        Course course = courseService.getCourseById(courseId);
        List<Attendance> records;

        LocalDate startDate = null;
        LocalDate endDate = null;

        if (startDateStr != null && !startDateStr.isEmpty() && endDateStr != null && !endDateStr.isEmpty()) {
            startDate = LocalDate.parse(startDateStr);
            endDate = LocalDate.parse(endDateStr);
            records = attendanceService.getAttendanceByCourseAndDateRange(courseId, startDate, endDate);
        } else {
            records = attendanceService.getAttendanceByCourse(courseId);
        }

        // Get summary
        Map<User, Double> summary = attendanceService.getCourseSummary(courseId);

        model.addAttribute("course", course);
        model.addAttribute("records", records);
        model.addAttribute("summary", summary);
        model.addAttribute("startDate", startDate != null ? startDate.toString() : "");
        model.addAttribute("endDate", endDate != null ? endDate.toString() : "");
        model.addAttribute("user", user);

        return "attendance-report";
    }

    /**
     * Student: View own attendance for a specific course.
     */
    @GetMapping("/student/attendance")
    public String studentAttendance(@RequestParam(value = "courseId", required = false) Long courseId,
                                     HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.STUDENT) {
            return "redirect:/login";
        }

        List<Course> courses = courseService.getCoursesByStudent(user.getId());
        model.addAttribute("courses", courses);
        model.addAttribute("user", user);

        if (courseId != null) {
            Course course = courseService.getCourseById(courseId);
            List<Attendance> records = attendanceService.getStudentAttendanceByCourse(user.getId(), courseId);
            double percentage = attendanceService.calculateAttendancePercentage(user.getId(), courseId);

            model.addAttribute("selectedCourse", course);
            model.addAttribute("records", records);
            model.addAttribute("percentage", Math.round(percentage * 100.0) / 100.0);
        }

        return "student-attendance";
    }
}
