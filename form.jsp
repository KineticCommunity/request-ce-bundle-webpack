<%--
    DELEGATE RENDERING TO SPA.JSP

    This file is included to support the application default values, and will display the webpack
    configuration instructions if the display is not configured properly.
--%>
<%
    request.getRequestDispatcher("spa.jsp").forward(request, response);
%>
