<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Student Dashboard - Attendance System</title>
                <meta name="description" content="Student Dashboard - View your attendance">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <!-- Navigation -->
                <nav class="navbar">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="navbar-brand">
                        <span class="icon">&#128218;</span>
                        Attendance System
                    </a>
                    <ul class="navbar-nav">
                        <li><a href="${pageContext.request.contextPath}/student/dashboard" class="active">Dashboard</a>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/student/attendance">My Attendance</a></li>
                    </ul>
                    <div class="navbar-user">
                        <div class="user-info">
                            <div class="user-name">${user.fullName}</div>
                            <div class="user-role">Student</div>
                        </div>
                        <div class="avatar">${user.fullName.substring(0,1)}</div>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
                    </div>
                </nav>

                <div class="container">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1>&#128075; Welcome, ${user.fullName}</h1>
                        <p>Track your attendance across all courses</p>
                    </div>

                    <!-- Stats -->
                    <div class="stats-grid">
                        <div class="stat-card purple">
                            <div class="stat-icon">&#128218;</div>
                            <div class="stat-value">${courses.size()}</div>
                            <div class="stat-label">Enrolled Courses</div>
                        </div>
                        <div class="stat-card blue">
                            <div class="stat-icon">&#128197;</div>
                            <div class="stat-value" id="todayDate"></div>
                            <div class="stat-label">Today's Date</div>
                        </div>
                    </div>

                    <!-- Course Attendance -->
                    <div class="card">
                        <div class="card-header">
                            <h2>&#128202; Course-wise Attendance</h2>
                        </div>

                        <c:choose>
                            <c:when test="${not empty courses}">
                                <div class="course-grid">
                                    <c:forEach var="course" items="${courses}">
                                        <div class="course-card">
                                            <span class="course-code">${course.courseCode}</span>
                                            <h3>${course.courseName}</h3>
                                            <p class="course-faculty">Faculty: ${course.faculty.fullName}</p>

                                            <c:set var="pct" value="${percentages[course.id]}" />
                                            <div style="margin: 0.8rem 0;">
                                                <div
                                                    style="display: flex; justify-content: space-between; margin-bottom: 4px;">
                                                    <span
                                                        style="font-size: 0.85rem; color: var(--text-secondary);">Attendance</span>
                                                    <span style="font-size: 0.85rem; font-weight: 600;
                                            color: ${pct >= 75 ? '#34d399' : pct >= 50 ? '#fbbf24' : '#f87171'}">
                                                        <fmt:formatNumber value="${pct}" maxFractionDigits="1" />%
                                                    </span>
                                                </div>
                                                <div class="percentage-bar">
                                                    <div class="percentage-fill ${pct >= 75 ? 'high' : pct >= 50 ? 'medium' : 'low'}"
                                                        style="width: ${pct}%"></div>
                                                </div>
                                            </div>

                                            <div class="course-actions">
                                                <a href="${pageContext.request.contextPath}/student/attendance?courseId=${course.id}"
                                                    class="btn btn-secondary btn-sm">
                                                    &#128202; View Details
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="icon">&#128218;</div>
                                    <h3>No Courses Found</h3>
                                    <p>You are not enrolled in any courses yet.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <script>
                    document.getElementById('todayDate').textContent = new Date().toLocaleDateString('en-IN', {
                        day: '2-digit', month: 'short'
                    });
                </script>
            </body>

            </html>