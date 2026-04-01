<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Reports - Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <nav class="navbar">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">
                        <span class="icon">&#128218;</span>
                        Attendance System
                    </a>
                    <ul class="navbar-nav">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/courses">Courses</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/faculty">Faculty</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/students">Students</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/reports" class="active">Reports</a></li>
                    </ul>
                    <div class="navbar-user">
                        <div class="user-info">
                            <div class="user-name">${user.fullName}</div>
                            <div class="user-role">Admin</div>
                        </div>
                        <div class="avatar">A</div>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
                    </div>
                </nav>

                <div class="container">
                    <div class="page-header">
                        <h1>&#128202; Detailed Reports</h1>
                        <p>Comprehensive attendance and faculty engagement reports</p>
                    </div>

                    <!-- System Stats -->
                    <div class="stats-grid">
                        <div class="stat-card purple">
                            <div class="stat-icon">&#128104;&#8205;&#127891;</div>
                            <div class="stat-value">${stats.totalFaculty}</div>
                            <div class="stat-label">Total Faculty</div>
                        </div>
                        <div class="stat-card blue">
                            <div class="stat-icon">&#127891;</div>
                            <div class="stat-value">${stats.totalStudents}</div>
                            <div class="stat-label">Total Students</div>
                        </div>
                        <div class="stat-card green">
                            <div class="stat-icon">&#128218;</div>
                            <div class="stat-value">${stats.totalCourses}</div>
                            <div class="stat-label">Total Courses</div>
                        </div>
                        <div class="stat-card orange">
                            <div class="stat-icon">&#128203;</div>
                            <div class="stat-value">${stats.totalAttendanceRecords}</div>
                            <div class="stat-label">Attendance Records</div>
                        </div>
                    </div>

                    <!-- Faculty Engagement Report -->
                    <div class="card" style="margin-bottom: 1.5rem;">
                        <div class="card-header">
                            <h2>&#128104;&#8205;&#127891; Faculty Engagement Report</h2>
                        </div>
                        <p style="color: var(--text-secondary); margin-bottom: 1rem; font-size: 0.9rem;">
                            Shows how many classes (distinct dates) each faculty has conducted per course.
                        </p>
                        <c:forEach var="fReport" items="${facultyReports}">
                            <div
                                style="margin-bottom: 1.5rem; padding: 1rem; border: 1px solid var(--border); border-radius: var(--radius);">
                                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 1rem;">
                                    <div class="student-avatar"
                                        style="width: 40px; height: 40px; border-radius: 10px; background: var(--gradient-1); display: flex; align-items: center; justify-content: center; font-weight: 700;">
                                        ${fReport.faculty.fullName.substring(0,1)}
                                    </div>
                                    <div>
                                        <div style="font-weight: 600; font-size: 1rem;">${fReport.faculty.fullName}
                                        </div>
                                        <div style="font-size: 0.82rem; color: var(--text-muted);">
                                            ${fReport.faculty.email}
                                        </div>
                                    </div>
                                </div>

                                <c:choose>
                                    <c:when test="${not empty fReport.classesEngaged}">
                                        <div class="table-wrapper">
                                            <table>
                                                <thead>
                                                    <tr>
                                                        <th>Course Code</th>
                                                        <th>Course Name</th>
                                                        <th>Classes Conducted</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="entry" items="${fReport.classesEngaged}">
                                                        <tr>
                                                            <td><span class="course-code">${entry.key.courseCode}</span>
                                                            </td>
                                                            <td style="font-weight: 500;">${entry.key.courseName}</td>
                                                            <td>
                                                                <span
                                                                    style="font-weight: 700; color: var(--primary-light);">${entry.value}</span>
                                                                <span style="color: var(--text-muted);"> classes</span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color: var(--text-muted); font-size: 0.9rem;">No classes conducted
                                            yet.
                                        </p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Course-wise Attendance Report -->
                    <div class="card">
                        <div class="card-header">
                            <h2>&#128202; Course-wise Attendance Summary</h2>
                        </div>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Course</th>
                                        <th>Code</th>
                                        <th>Faculty</th>
                                        <th>Enrolled Students</th>
                                        <th>Total Classes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="report" items="${courseReports}">
                                        <tr>
                                            <td style="font-weight: 500;">${report.course.courseName}</td>
                                            <td><span class="course-code">${report.course.courseCode}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${report.course.faculty != null}">
                                                        ${report.course.faculty.fullName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Unassigned</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: center;">${report.enrolledStudents}</td>
                                            <td style="text-align: center;">${report.totalClasses}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </body>

            </html>