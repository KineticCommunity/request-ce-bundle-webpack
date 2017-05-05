<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="app" uri="http://kineticdata.com/taglibs/core/app" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${param.embedded != null}">
        <app:bodyContent/>
    </c:when>
    <c:when test="${submission == null}">
        <c:redirect url="${bundle.kappPath}#/forms/${form.slug}"/>
    </c:when>
    <c:otherwise>
        <c:redirect url="${bundle.kappPath}#/submissions/${submission.id}"/>
    </c:otherwise>
</c:choose>
