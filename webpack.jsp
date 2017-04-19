<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="app" uri="http://kineticdata.com/taglibs/core/app" %>
<% request.setAttribute("text", new com.kineticdata.bundles.Text()); %>

<%-- Determine the location of the static folder --%>
<c:choose>
    <%-- DEVELOPMENT PROXY MODE --%>
    <c:when test="${pageContext.request.getHeader('X-Webpack-Bundle-Name') == param.bundleName}">
        <c:set var="staticLocation" value="/static"/>
    </c:when>
    <%-- DEVELOPMENT PROXY MODE (LEGACY) --%>
    <c:when test="${pageContext.request.getHeader('X-From-Webpack-Proxy') == 'X-From-Webpack-Proxy'}">
        <c:set var="staticLocation" value="/static"/>
    </c:when>
    <%-- 
        EXTERNAL ASSET MODE
        queryString is set to the query string specified in the space/kapp/form display page 
        property and NOT from the actual page URL.  Therefore, the queryString can be used to ensure
        the location parameter was specified in the CE configuration and not by the page URL (which
        would potentially allow an attacker craft a URL that would load a malicious bundle).
    --%>
    <c:when test="${param.location != null && pageContext.request.queryString.contains(param.location)}">
        <c:set var="staticLocation" value="${param.location}"/>
    </c:when>
    <%-- EMBEDDED ASSET MODE --%>
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
        ${pageContext.request.getParameterMap()}
        <div id='root'></div>
        <script>
            bundle.config = bundle.config || {};
            bundle.config.staticLocation = '${text.escapeJs(staticLocation)}';
        </script>
        <script src="${text.escape(staticLocation)}/bundle.js"></script>
    </body>
</html>