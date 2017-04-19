<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="app" uri="http://kineticdata.com/taglibs/core/app" %>
<% request.setAttribute("text", new com.kineticdata.bundles.Text()); %>

<%-- Determine the location of the static folder --%>
<c:choose>
    <%-- Development mode --%>
    <c:when test="${pageContext.request.getHeader('X-Webpack-Bundle-Name') == param.bundleName}">
        <c:set var="staticLocation" value="/static"/>
    </c:when>
    <%-- Development mode (legacy) --%>
    <c:when test="${pageContext.request.getHeader('X-From-Webpack-Proxy') == 'X-From-Webpack-Proxy'}">
        <c:set var="staticLocation" value="/static"/>
    </c:when>
    <%-- External assets --%>
    <c:when test="${param.location != null}">
        <c:set var="staticLocation" value="${param.location}"/>
    </c:when>
    <%-- Embedded assets --%>
    <c:otherwise>
        <c:set var="staticLocation" value="${bundle.location}/static"/>
    </c:otherwise>
</c:choose>

<!doctype html>
<html>
    <head>
        <app:headContent/>
    </head>
    <body>
        <div id='root'></div>
        <script>
            bundle.config = bundle.config || {};
            bundle.config.staticLocation = '${text.escapeJs(staticLocation)}';
        </script>
        <script src="${text.escape(staticLocation)}/bundle.js"></script>
    </body>
</html>