<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="app" uri="http://kineticdata.com/taglibs/core/app" %>

<%-- Here we check for a request header that tells us whether or not the request was made via webpack proxy server.
     If it is we do not want to use the bundle location in the static path because the webpack dev server will be
     serving resources from /static.  If the header is not present we want to prefix the /static path with the
     bundle location because that is where they will be served from the core web server. --%>
<c:set var="bundlePath" value="${empty pageContext.request.getHeader('X-From-Webpack-Proxy') ? bundle.location : '' }" />

<!doctype html>
<html>
<head>
    <app:headContent/>
</head>
<body>
<div id='root'></div>
<script src="${bundlePath}/static/bundle.js"></script>
</body>
</html>