<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true" %>
<%@taglib prefix="app" uri="http://kineticdata.com/taglibs/core/app" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 
    DETERMINE ROUTING
    
    Note: When an implementation is using a single bundle (ie the kapps use the same webpack bundle
    as th espace), this JSP will also be used for the Kapp and Form display pages.
--%>
<c:choose>
    <%--
        EMBEDDED FORM 
        Render the form normally in embedded mode.
    --%>
    <c:when test="${param.embedded != null}">
        <app:bodyContent/>
    </c:when>
    <%-- 
        MANUAL REDIRECT
        queryString is set to the query string specified in the space/kapp/form display page 
        property and NOT from the actual page URL.  Therefore, the queryString can be used to ensure
        the location parameter was specified in the CE configuration and not by the page URL (which
        would potentially allow an attacker craft a URL that would load a malicious bundle).
    --%>
    <c:when test="${param.fragment != null && pageContext.request.queryString.contains(param.fragment)}">
        <c:redirect url="${bundle.spacePath}/#/${param.fragment}">
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
        SUBMISSION REDIRECT
        If the request is for a submission, redirect to the standardized fragment path.
    --%>
    <c:when test="${submission != null}">
        <c:redirect url="${bundle.spacePath}/#/kapps/${submission.form.kapp.slug}/submissions/${submission.id}">
            <c:forEach items="${pageContext.request.parameterMap}" var="entry">
                <c:forEach items="${entry.value}" var="value">
                    <c:param name="${entry.key}" value="${value}" />
                </c:forEach>
            </c:forEach>
        </c:redirect>
    </c:when>
    <%-- 
        FORM REDIRECT
        If the request is for a form, redirect to the standardized fragment path.
    --%>
    <c:when test="${form != null}">
        <c:redirect url="${bundle.spacePath}/#/kapps/${form.kapp.slug}/forms/${form.slug}">
            <c:forEach items="${pageContext.request.parameterMap}" var="entry">
                <c:forEach items="${entry.value}" var="value">
                    <c:param name="${entry.key}" value="${value}" />
                </c:forEach>
            </c:forEach>
        </c:redirect>
    </c:when>
    <%-- 
        KAPP REDIRECT
        If the request is for a kapp, redirect to the standardized fragment path.
    --%>
    <c:when test="${kapp != null}">
        <c:redirect url="${bundle.spacePath}/#/kapps/${kapp.slug}">
            <c:forEach items="${pageContext.request.parameterMap}" var="entry">
                <c:forEach items="${entry.value}" var="value">
                    <c:param name="${entry.key}" value="${value}" />
                </c:forEach>
            </c:forEach>
        </c:redirect>
    </c:when>
    <%-- 
        DELEGATE RENDERING TO WEBPACK.JSP 
        This renders the page that serves up the actual webpack bundle.
    --%>
    <c:otherwise>
        <% 
            request.getRequestDispatcher("webpack.jsp").forward(request, response); 
        %>
    </c:otherwise>
</c:choose>