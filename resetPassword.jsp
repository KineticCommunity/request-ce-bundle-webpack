<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"
        import="com.kineticdata.core.web.bundles.*,com.kineticdata.core.models.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 
    DETERMINE ROUTING
    
    Note: This JSP is used for "separated" bundles (ie the kapp has a different webpack bundle than
    the space and other kapps).  For implementations with a single bundle, the space.jsp should be
    used.
--%>
<c:choose>
    <%-- 
        REDIRECT TO WEBPACK BUNDLE
        If the kapp/space "Reset Password Page" is specified like 
        "resetPassword.jsp?fragment=reset-password", then redirect to the kapp/space webpack bundle
        (ie /acme/#/reset-password or /acme/services/#/reset-password).
    
        queryString is set to the query string specified in the space/kapp/form display page 
        property and NOT from the actual page URL.  Therefore, the queryString can be used to ensure
        the location parameter was specified in the CE configuration and not by the page URL (which
        would potentially allow an attacker craft a URL that would load a malicious bundle).
    --%>
    <c:when test="${param.fragment != null && pageContext.request.queryString.contains(param.fragment)}">
        <c:redirect url="${empty kapp ? bundle.spacePath : bundle.kappPath}/#/${param.fragment}">
            <c:forEach items="${pageContext.request.parameterMap}" var="entry">
                <c:if test="${entry.key != 'fragment'}">
                    <c:forEach items="${entry.value}" var="value">
                        <c:param name="${entry.key}" value="${value}" />
                    </c:forEach>
                </c:if>
            </c:forEach>
        </c:redirect>
    </c:when>
    <%-- 
        RENDER DEFAULT RESET PASSWORD PAGE
        If the kapp/space "Reset Password Page" is not specified or is specified like 
        "resetPassword.jsp" (implying the webpack bundle does not define a reset password page), 
        then render the default base bundle reset password page.
    --%>
    <c:otherwise>
        <% 
            Space space = (Space)request.getAttribute("space");
            Kapp kapp = (Kapp)request.getAttribute("kapp");
            DefaultBundle bundle = new DefaultBundle(request.getContextPath(), space, kapp);
            request.setAttribute("bundle", bundle);
            request.getRequestDispatcher("/WEB-INF/app/bundle/resetPassword.jsp").forward(request, response); 
        %>
    </c:otherwise>
</c:choose>

