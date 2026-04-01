package com.attendance.controller;

import com.attendance.model.*;
import com.attendance.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    // ===== Helper: Check admin access =====
    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && user.getRole() == User.Role.ADMIN;
    }

    // ===== Dashboard =====
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";
        User user = (User) session.getAttribute("user");
        Map<String, Object> stats = adminService.getSystemStats();
        List<Map<String, Object>> courseReports = adminService.getAllCourseReports();
        model.addAttribute("user", user);
        model.addAttribute("stats", stats);
        model.addAttribute("courseReports", courseReports);
        return "admin-dashboard";
    }

    // ===== Course Management =====
    @GetMapping("/courses")
    public String listCourses(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";
        model.addAttribute("user", session.getAttribute("user"));
        model.addAttribute("courses", adminService.getAllCourses());
        model.addAttribute("facultyList", adminService.getAllFaculty());
        return "admin-courses";
    }

    @PostMapping("/courses/add")
    public String addCourse(@RequestParam String courseName,
            @RequestParam String courseCode,
            @RequestParam(required = false) Long facultyId,
            HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";
        Course course = adminService.createCourse(courseName, courseCode, facultyId);
        if (course == null) {
            // Determine which field caused the conflict for a precise message
            boolean nameTaken = adminService.getAllCourses().stream()
                    .anyMatch(c -> c.getCourseName().equalsIgnoreCase(courseName));
            if (nameTaken) {
                return "redirect:/admin/courses?error=Course+name+already+exists";
            }
            return "redirect:/admin/courses?error=Course+code+already+exists";
        }
        return "redirect:/admin/courses?success=Course+created+successfully";
    }

    @PostMapping("/courses/update")
    public String updateCourse(@RequestParam Long courseId,
            @RequestParam String courseName,
            @RequestParam String courseCode,
            @RequestParam(required = false) Long facultyId,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        adminService.updateCourse(courseId, courseName, courseCode, facultyId);
        return "redirect:/admin/courses?success=Course+updated+successfully";
    }

    // ===== Faculty Management =====
    @GetMapping("/faculty")
    public String listFaculty(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";
        model.addAttribute("user", session.getAttribute("user"));
        model.addAttribute("facultyList", adminService.getAllFaculty());
        model.addAttribute("courses", adminService.getAllCourses());
        return "admin-faculty";
    }

    @PostMapping("/faculty/add")
    public String addFaculty(@RequestParam String username,
            @RequestParam String password,
            @RequestParam String fullName,
            @RequestParam String email,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        User faculty = adminService.createFaculty(username, password, fullName, email);
        if (faculty == null) {
            return "redirect:/admin/faculty?error=Username+already+exists";
        }
        return "redirect:/admin/faculty?success=Faculty+added+successfully";
    }

    @PostMapping("/faculty/update")
    public String updateFaculty(@RequestParam Long userId,
            @RequestParam String fullName,
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam(required = false) String password,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        adminService.updateUser(userId, fullName, username, email, password);
        return "redirect:/admin/faculty?success=Faculty+updated+successfully";
    }

    @PostMapping("/faculty/assign-course")
    public String assignCourseToFaculty(@RequestParam Long facultyId,
            @RequestParam Long courseId,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        adminService.updateCourse(courseId, null, null, facultyId);
        return "redirect:/admin/faculty?success=Course+assigned+successfully";
    }

    // ===== Student Management =====
    @GetMapping("/students")
    public String listStudents(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";
        model.addAttribute("user", session.getAttribute("user"));
        model.addAttribute("studentList", adminService.getAllStudents());
        model.addAttribute("courses", adminService.getAllCourses());
        return "admin-students";
    }

    @PostMapping("/students/add")
    public String addStudent(@RequestParam String username,
            @RequestParam String password,
            @RequestParam String fullName,
            @RequestParam String email,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        User student = adminService.createStudent(username, password, fullName, email);
        if (student == null) {
            return "redirect:/admin/students?error=Username+already+exists";
        }
        return "redirect:/admin/students?success=Student+added+successfully";
    }

    @PostMapping("/students/update")
    public String updateStudent(@RequestParam Long userId,
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String password,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        adminService.updateUser(userId, fullName, null, email, password);
        return "redirect:/admin/students?success=Student+updated+successfully";
    }

    @PostMapping("/students/enroll")
    public String enrollStudent(@RequestParam Long studentId,
            @RequestParam Long courseId,
            HttpSession session) {
        if (!isAdmin(session))
            return "redirect:/login";
        adminService.enrollStudentInCourse(studentId, courseId);
        return "redirect:/admin/students?success=Student+enrolled+in+course";
    }

    // ===== Reports =====
    @GetMapping("/reports")
    public String reports(HttpSession session, Model model) {
        if (!isAdmin(session))
            return "redirect:/login";
        model.addAttribute("user", session.getAttribute("user"));
        model.addAttribute("stats", adminService.getSystemStats());
        model.addAttribute("courseReports", adminService.getAllCourseReports());
        model.addAttribute("facultyList", adminService.getAllFaculty());

        // Faculty engagement data
        List<Map<String, Object>> facultyReports = new java.util.ArrayList<>();
        for (User faculty : adminService.getAllFaculty()) {
            Map<String, Object> fReport = new java.util.LinkedHashMap<>();
            fReport.put("faculty", faculty);
            fReport.put("courses", adminService.getCoursesForFaculty(faculty.getId()));
            fReport.put("classesEngaged", adminService.getFacultyClassesEngaged(faculty.getId()));
            facultyReports.add(fReport);
        }
        model.addAttribute("facultyReports", facultyReports);

        return "admin-reports";
    }
}
