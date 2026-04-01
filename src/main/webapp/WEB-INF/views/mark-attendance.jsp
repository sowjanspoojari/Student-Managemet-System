<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Mark Attendance - ${course.courseName}</title>
            <meta name="description" content="Mark student attendance for ${course.courseName}">
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
                    <li><a href="${pageContext.request.contextPath}/faculty/dashboard">Dashboard</a></li>
                    <li><a class="active">Mark Attendance</a></li>
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
                    <h1>&#9997;&#65039; Mark Attendance</h1>
                    <p>${course.courseCode} - ${course.courseName}</p>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        &#9989; ${success}
                    </div>
                </c:if>

                <div class="card">
                    <!-- Date Selection -->
                    <div class="card-header">
                        <h3>&#128197; Select Date</h3>
                    </div>
                    <form method="get" action="${pageContext.request.contextPath}/faculty/attendance-form"
                        class="filter-form">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <div class="form-group">
                            <label for="date">Date</label>
                            <input type="date" class="form-control" id="date" name="date" value="${date}">
                        </div>
                        <button type="submit" class="btn btn-secondary btn-sm">&#128269; Load Students</button>
                    </form>

                    <!-- Attendance Form -->
                    <form action="${pageContext.request.contextPath}/faculty/mark-attendance" method="post"
                        id="attendanceForm">
                        <input type="hidden" name="courseId" value="${course.id}">
                        <input type="hidden" name="date" value="${date}">

                        <div class="attendance-list">
                            <c:choose>
                                <c:when test="${not empty students}">
                                    <div
                                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                        <span style="font-size: 0.9rem; color: var(--text-secondary);">
                                            ${students.size()} students enrolled
                                        </span>
                                        <div style="display: flex; gap: 6px;">
                                            <button type="button" class="btn btn-sm btn-secondary"
                                                onclick="markAll('PRESENT')">
                                                &#9989; All Present
                                            </button>
                                            <button type="button" class="btn btn-sm btn-secondary"
                                                onclick="markAll('ABSENT')">
                                                &#10060; All Absent
                                            </button>
                                        </div>
                                    </div>

                                    <c:forEach var="student" items="${students}" varStatus="loop">
                                        <div class="attendance-item">
                                            <div class="student-info">
                                                <div class="student-avatar">${student.fullName.substring(0,1)}</div>
                                                <div>
                                                    <div class="student-name">${student.fullName}</div>
                                                    <div style="font-size: 0.8rem; color: var(--text-muted);">
                                                        ${student.username}</div>
                                                </div>
                                            </div>
                                            <input type="hidden" name="studentId" value="${student.id}">
                                            <div class="status-options">
                                                <input type="radio" name="status_${student.id}" value="PRESENT"
                                                    id="present_${student.id}" class="status-radio status-present"
                                                    ${existingStatuses[student.id]=='PRESENT' ? 'checked' : '' } ${empty
                                                    existingStatuses[student.id] ? 'checked' : '' }>
                                                <label for="present_${student.id}" class="status-label present">&#9989;
                                                    Present</label>

                                                <input type="radio" name="status_${student.id}" value="ABSENT"
                                                    id="absent_${student.id}" class="status-radio status-absent"
                                                    ${existingStatuses[student.id]=='ABSENT' ? 'checked' : '' }>
                                                <label for="absent_${student.id}" class="status-label absent">&#10060;
                                                    Absent</label>

                                              <!-- <input type="radio" name="status_${student.id}" value="LATE"
                                                    id="late_${student.id}" class="status-radio status-late"
                                                    ${existingStatuses[student.id]=='LATE' ? 'checked' : '' }>
                                                <label for="late_${student.id}" class="status-label late">&#9200;
                                                    Late</label> -->
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <div style="margin-top: 1.5rem; display: flex; gap: 1rem;">
                                        <button type="submit" class="btn btn-success">
                                            &#128190; Save Attendance
                                        </button>
                                        <a href="${pageContext.request.contextPath}/faculty/dashboard"
                                            class="btn btn-secondary">
                                            &#8592; Back to Dashboard
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="icon">&#128100;</div>
                                        <h3>No Students Enrolled</h3>
                                        <p>No students are enrolled in this course yet.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function markAll(status) {
                    const radios = document.querySelectorAll('.status-' + status.toLowerCase());
                    radios.forEach(radio => radio.checked = true);
                }
            </script>
        </body>

        </html>