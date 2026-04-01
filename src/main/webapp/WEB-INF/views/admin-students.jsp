<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Manage Students - Admin</title>
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
                    <li><a href="${pageContext.request.contextPath}/admin/students" class="active">Students</a></li>
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
                    <h1>&#127891; Manage Students</h1>
                    <p>Add, update students and enroll in courses</p>
                </div>

                <c:if test="${param.success != null}">
                    <div class="alert alert-success">&#9989; ${param.success}</div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger">&#9888;&#65039; ${param.error}</div>
                </c:if>

                <!-- Add New Student -->
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div class="card-header">
                        <h3>&#10133; Add New Student</h3>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/students/add" method="post">
                        <div class="filter-form">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" class="form-control" name="fullName" placeholder="e.g. Ravi Kumar"
                                    required>
                            </div>
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" class="form-control" name="username" placeholder="e.g. ravi01"
                                    required>
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" class="form-control" name="email"
                                    placeholder="e.g. ravi@student.edu" required>
                            </div>
                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" class="form-control" name="password" placeholder="Set password"
                                    required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-sm">&#10133; Add Student</button>
                        </div>
                    </form>
                </div>

                <!-- Enroll Student in Course -->
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div class="card-header">
                        <h3>&#128279; Enroll Student in Course</h3>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/students/enroll" method="post">
                        <div class="filter-form">
                            <div class="form-group">
                                <label>Student</label>
                                <select class="form-control" name="studentId" required>
                                    <option value="">-- Select Student --</option>
                                    <c:forEach var="stu" items="${studentList}">
                                        <option value="${stu.id}">${stu.fullName} (${stu.username})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Course</label>
                                <select class="form-control" name="courseId" required>
                                    <option value="">-- Select Course --</option>
                                    <c:forEach var="course" items="${courses}">
                                        <option value="${course.id}">${course.courseCode} - ${course.courseName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success btn-sm">&#128279; Enroll</button>
                        </div>
                    </form>
                </div>

                <!-- Student List -->
                <div class="card">
                    <div class="card-header">
                        <h3>&#128203; All Students</h3>
                        <span class="badge badge-student">${studentList.size()} students</span>
                    </div>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="stu" items="${studentList}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td style="font-weight: 500;">${stu.fullName}</td>
                                        <td style="color: var(--text-secondary);">${stu.username}</td>
                                        <td style="color: var(--text-secondary);">${stu.email}</td>
                                        <td>
                                            <button type="button" class="btn btn-secondary btn-sm"
                                                onclick="editStudent(${stu.id}, '${stu.fullName}', '${stu.email}')">
                                                &#9998; Edit
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Edit Modal -->
                <div id="editModal"
                    style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.7); z-index:200; align-items:center; justify-content:center;">
                    <div class="auth-card" style="max-width: 500px;">
                        <h2 style="margin-bottom: 1rem;">&#9998; Edit Student</h2>
                        <form action="${pageContext.request.contextPath}/admin/students/update" method="post">
                            <input type="hidden" name="userId" id="editUserId">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" class="form-control" name="fullName" id="editFullName" required>
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" class="form-control" name="email" id="editEmail" required>
                            </div>
                            <div class="form-group">
                                <label>New Password (leave blank to keep)</label>
                                <input type="password" class="form-control" name="password"
                                    placeholder="Leave blank to keep current">
                            </div>
                            <div style="display:flex; gap:1rem;">
                                <button type="submit" class="btn btn-success">&#128190; Save</button>
                                <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                function editStudent(id, name, email) {
                    document.getElementById('editUserId').value = id;
                    document.getElementById('editFullName').value = name;
                    document.getElementById('editEmail').value = email;
                    document.getElementById('editModal').style.display = 'flex';
                }
                function closeModal() {
                    document.getElementById('editModal').style.display = 'none';
                }
            </script>
        </body>

        </html>