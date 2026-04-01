package com.attendance.servlet;

import com.attendance.model.User;
import com.attendance.service.AttendanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/faculty/mark-attendance")
public class MarkAttendanceServlet extends HttpServlet {

    @Autowired
    private AttendanceService attendanceService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User faculty = (User) session.getAttribute("user");
        if (faculty.getRole() != User.Role.FACULTY) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Long courseId = Long.parseLong(request.getParameter("courseId"));
            String dateStr = request.getParameter("date");
            LocalDate date = LocalDate.parse(dateStr);

            // Collect student attendance statuses from form
            String[] studentIds = request.getParameterValues("studentId");
            Map<Long, String> studentStatuses = new HashMap<>();

            if (studentIds != null) {
                for (String studentIdStr : studentIds) {
                    Long studentId = Long.parseLong(studentIdStr);
                    String status = request.getParameter("status_" + studentId);
                    if (status != null && !status.isEmpty()) {
                        studentStatuses.put(studentId, status);
                    }
                }
            }

            // Spring Boot service handles business logic
            attendanceService.markAttendance(courseId, date, studentStatuses, faculty.getId());

            // Redirect back with success message
            response.sendRedirect(
                    request.getContextPath() + "/faculty/attendance-form?courseId=" + courseId + "&success=true");

        } catch (Exception e) {
            request.setAttribute("error", "Error marking attendance: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
