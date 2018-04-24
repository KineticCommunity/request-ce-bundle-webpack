<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true" %>
<%@include file="bundle/initialization.jspf" %>

<%-- 
    RENDER DEFAULT RESET PASSWORD PAGE

    This JSP won't be rendered when using a clientside bundle (unless a user goes directly to the
    serverside login url).
--%>
<% 
    Space space = (Space)request.getAttribute("space");
    Kapp kapp = (Kapp)request.getAttribute("kapp");
    DefaultBundle bundle = new DefaultBundle(request.getContextPath(), space, kapp);
    request.setAttribute("bundle", bundle);
    request.getRequestDispatcher("/WEB-INF/app/bundle/resetPassword.jsp").forward(request, response); 
%>

