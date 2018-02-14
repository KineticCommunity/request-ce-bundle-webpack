<%-- 
    DELEGATE RENDERING TO FORM.JSP

    This file is included to support the application default values, but form.jsp should contain
    all of the logic to render an embedded form page (whether it is a confirmation page or not).
--%>
<% 
    request.getRequestDispatcher("form.jsp").forward(request, response); 
%>