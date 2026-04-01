<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Manage Faculty - Admin</title>
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
                    <li><a href="${pageContext.request.contextPath}/admin/faculty" class="active">Faculty</a></li>
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
                    <h1>&#128104;&#8205;&#127891; Manage Faculty</h1>
                    <p>Add, update faculty and assign courses</p>
                </div>

                <c:if test="${param.success != null}">
                    <div class="alert alert-success">&#9989; ${param.success}</div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger">&#9888;&#65039; ${param.error}</div>
                </c:if>

                <!-- Add New Faculty -->
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div class="card-header">
                        <h3>&#10133; Add New Faculty</h3>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/faculty/add" method="post">
                        <div class="filter-form">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" class="form-control" name="fullName"
                                    placeholder="e.g. Dr. John Smith" required>
                            </div>
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" class="form-control" name="username" placeholder="e.g. jsmith"
                                    required>
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" class="form-control" name="email" placeholder="e.g. john@univ.edu"
                                    required>
                            </div>
                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" class="form-control" name="password" placeholder="Set password"
                                    required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-sm">&#10133; Add Faculty</button>
                        </div>
                    </form>
                </div>

                <!-- Faculty-Subject Mapping -->
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div class="card-header">
                        <h3>&#128279; Faculty-Subject Mapping</h3>
                    </div>
                    <p style="color: var(--text-secondary); margin-bottom: 1rem; font-size: 0.9rem;">
                        Assign available courses to faculty members.
                    </p>
                    <form action="${pageContext.request.contextPath}/admin/faculty/assign-course" method="post">
                        <div class="filter-form">
                            <div class="form-group">
                                <label>Faculty</label>
                                <select class="form-control" name="facultyId" required>
                                    <option value="">-- Select Faculty --</option>
                                    <c:forEach var="fac" items="${facultyList}">
                                        <option value="${fac.id}">${fac.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Course</label>
                                <select class="form-control" name="courseId" required>
                                    <option value="">-- Select Course --</option>
                                    <c:forEach var="course" items="${courses}">
                                        <option value="${course.id}">${course.courseCode} - ${course.courseName}
                                            <c:choose>
                                                <c:when test="${course.faculty != null}">
                                                    (Assigned to: ${course.faculty.fullName})
                                                </c:when>
                                                <c:otherwise>
                                                    (Unassigned)
                                                </c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success btn-sm">&#128279; Update Assignment</button>
                        </div>
                    </form>
                </div>

                <!-- Faculty List -->
                <div class="card">
                    <div class="card-header">
                        <h3>&#128203; All Faculty Members</h3>
                        <span class="badge badge-faculty">${facultyList.size()} faculty</span>
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
                                <c:forEach var="fac" items="${facultyList}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td style="font-weight: 500;">${fac.fullName}</td>
                                        <td style="color: var(--text-secondary);">${fac.username}</td>
                                        <td style="color: var(--text-secondary);">${fac.email}</td>
                                        <td>
                                            <button type="button" class="btn btn-secondary btn-sm" data-id="${fac.id}"
                                                data-name="${fac.fullName}" data-username="${fac.username}"
                                                data-email="${fac.email}" onclick="editFaculty(this)">
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
                        <h2 style="margin-bottom: 1rem;">&#9998; Edit Faculty</h2>
                        <form action="${pageContext.request.contextPath}/admin/faculty/update" method="post">
                            <input type="hidden" name="userId" id="editUserId">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" class="form-control" name="fullName" id="editFullName" required>
                            </div>
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" class="form-control" name="username" id="editUsername" required>
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
                function editFaculty(button) {
                    const ds = button.dataset;
                    document.getElementById('editUserId').value = ds.id;
                    document.getElementById('editFullName').value = ds.name;
                    document.getElementById('editUsername').value = ds.username;
                    document.getElementById('editEmail').value = ds.email;
                    document.getElementById('editModal').style.display = 'flex';
                }
                function closeModal() {
                    document.getElementById('editModal').style.display = 'none';
                }
            </script>
        </body>

        </html>