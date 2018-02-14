<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="app" uri="http://kineticdata.com/taglibs/core/app" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 
    DETERMINE ROUTING

    Note: This JSP is used for "separated" bundles (ie the kapp has a different webpack bundle than
    the space and other kapps).  For implementations with a single bundle, the space.jsp should be
    used.
--%>
<c:choose>
    <%-- EMBEDDED FORM --%>
    <c:when test="${param.embedded != null}">
        <app:bodyContent/>
    </c:when>
    <%-- 
        SUBMISSION
        This will redirect to the "normalized" submission route.  If the hash-path is not desired
        for a particular webpack bundle, it will be responsible for redirecting to an appropriate
        route (ie from /#/submissions/:id to /#/requests/:id).
    --%>
    <c:when test="${submission != null}">
        <c:redirect url="${bundle.kappPath}/#/submissions/${submission.id}">
            <c:forEach items="${pageContext.request.parameterMap}" var="entry">
                <c:forEach items="${entry.value}" var="value">
                    <c:param name="${entry.key}" value="${value}" />
                </c:forEach>
            </c:forEach>
        </c:redirect>
    </c:when>
    <%-- 
        FORM
        This will redirect to the "normalized" form route.  If the hash-path is not desired
        for a particular webpack bundle, it will be responsible for redirecting to an appropriate
        route (ie from /#/forms/:slug to /#/services/:slug).
    --%>
    <c:otherwise>
        <c:redirect url="${bundle.kappPath}/#/forms/${form.slug}">
            <c:forEach items="${pageContext.request.parameterMap}" var="entry">
                <c:forEach items="${entry.value}" var="value">
                    <c:param name="${entry.key}" value="${value}" />
                </c:forEach>
            </c:forEach>
        </c:redirect>
    </c:otherwise>
</c:choose>
