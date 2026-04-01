<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Admin Dashboard - Attendance System</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">
                    <span class="icon">&#128218;</span>
                    Attendance System
                </a>
                <ul class="navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/courses">Courses</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/faculty">Faculty</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/students">Students</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/reports">Reports</a></li>
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
                    <h1>&#128736;&#65039; Admin Dashboard</h1>
                    <p>System overview and quick management</p>
                </div>

                <!-- Stats -->
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

                <!-- Quick Actions -->
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div class="card-header">
                        <h2>&#9889; Quick Actions</h2>
                    </div>
                    <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-primary">&#128218;
                            Manage Courses</a>
                        <a href="${pageContext.request.contextPath}/admin/faculty"
                            class="btn btn-secondary">&#128104;&#8205;&#127891; Manage Faculty</a>
                        <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-secondary">&#127891;
                            Manage Students</a>
                        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-success">&#128202;
                            View Reports</a>
                    </div>
                </div>

                <!-- Course Overview -->
                <div class="card">
                    <div class="card-header">
                        <h2>&#128202; Course Overview</h2>
                    </div>
                    <c:if test="${not empty courseReports}">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Course</th>
                                        <th>Code</th>
                                        <th>Faculty</th>
                                        <th>Enrolled</th>
                                        <th>Classes</th>
                                        <th>Avg Attendance</th>
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
                                            <td>${report.enrolledStudents}</td>
                                            <td>${report.totalClasses}</td>
                                            <td>
                                                <span
                                                    style="font-weight: 600;
                                            color: ${report.avgAttendance >= 75 ? '#34d399' : report.avgAttendance >= 50 ? '#fbbf24' : '#f87171'};">
                                                    ${report.avgAttendance}%
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </body>

        </html>