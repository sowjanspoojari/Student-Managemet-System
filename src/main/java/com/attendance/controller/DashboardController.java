package com.attendance.controller;

import com.attendance.model.Course;
import com.attendance.model.User;
import com.attendance.service.AttendanceService;
import com.attendance.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
public class DashboardController {

    @Autowired
    private CourseService courseService;

    @Autowired
    private AttendanceService attendanceService;

    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    @GetMapping("/faculty/dashboard")
    public String facultyDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.FACULTY) {
            return "redirect:/login";
        }
        List<Course> courses = courseService.getCoursesByFaculty(user.getId());
        model.addAttribute("courses", courses);
        model.addAttribute("user", user);
        return "faculty-dashboard";
    }

    @GetMapping("/student/dashboard")
    public String studentDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole() != User.Role.STUDENT) {
            return "redirect:/login";
        }
        List<Course> courses = courseService.getCoursesByStudent(user.getId());

        // Calculate attendance percentage for each course
        java.util.Map<Long, Double> percentages = new java.util.LinkedHashMap<>();
        for (Course course : courses) {
            double pct = attendanceService.calculateAttendancePercentage(user.getId(), course.getId());
            percentages.put(course.getId(), Math.round(pct * 100.0) / 100.0);
        }

        model.addAttribute("courses", courses);
        model.addAttribute("percentages", percentages);
        model.addAttribute("user", user);
        return "student-dashboard";
    }
}
