<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Faculty Dashboard - Attendance System</title>
            <meta name="description" content="Faculty Dashboard - Manage student attendance">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <!-- Navigation -->
            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/faculty/dashboard" class="navbar-brand">
                    <span class="icon">&#128218;</span>
                    Attendance System
                </a>
                <ul class="navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/faculty/dashboard" class="active">Dashboard</a></li>
                </ul>
                <div class="navbar-user">
                    <div class="user-info">
                        <div class="user-name">${user.fullName}</div>
                        <div class="user-role">Faculty</div>
                    </div>
                    <div class="avatar">${user.fullName.substring(0,1)}</div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
                </div>
            </nav>

            <div class="container">
                <!-- Page Header -->
                <div class="page-header">
                    <h1>&#128075; Welcome, ${user.fullName}</h1>
                    <p>Manage attendance for your courses</p>
                </div>

                <!-- Stats -->
                <div class="stats-grid">
                    <div class="stat-card purple">
                        <div class="stat-icon">&#128218;</div>
                        <div class="stat-value">${courses.size()}</div>
                        <div class="stat-label">Total Courses</div>
                    </div>
                    <div class="stat-card blue">
                        <div class="stat-icon">&#128197;</div>
                        <div class="stat-value" id="todayDate"></div>
                        <div class="stat-label">Today's Date</div>
                    </div>
                    <div class="stat-card green">
                        <div class="stat-icon">&#9989;</div>
                        <div class="stat-value">Active</div>
                        <div class="stat-label">System Status</div>
                    </div>
                </div>

                <!-- Courses -->
                <div class="card">
                    <div class="card-header">
                        <h2>&#128218; Your Courses</h2>
                    </div>

                    <c:choose>
                        <c:when test="${not empty courses}">
                            <div class="course-grid">
                                <c:forEach var="course" items="${courses}">
                                    <div class="course-card">
                                        <span class="course-code">${course.courseCode}</span>
                                        <h3>${course.courseName}</h3>
                                        <p class="course-faculty">Faculty: ${course.faculty.fullName}</p>
                                        <div class="course-actions">
                                            <a href="${pageContext.request.contextPath}/faculty/attendance-form?courseId=${course.id}"
                                                class="btn btn-primary btn-sm">
                                                &#9997;&#65039; Mark Attendance
                                            </a>
                                            <a href="${pageContext.request.contextPath}/faculty/attendance-report?courseId=${course.id}"
                                                class="btn btn-secondary btn-sm">
                                                &#128202; View Report
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
                                <p>You haven't been assigned any courses yet.</p>
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