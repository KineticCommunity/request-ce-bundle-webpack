<%-- 
    DELEGATE RENDERING TO WEBPACK.JSP

    This file is included to support the application default values, and will display the webpack
    configuration instructions if the kapp is not configured properly.
--%>
<% 
    request.getRequestDispatcher("webpack.jsp").forward(request, response); 
%>