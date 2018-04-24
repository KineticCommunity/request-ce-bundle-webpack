<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true" %>
<%@include file="bundle/initialization.jspf" %>
<%@include file="bundle/router.jspf" %>

<%--
    DETERMINE SPA ROUTING
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
        DATASTORE SUBMISSION REDIRECT
        If the request is for a datastore submission, redirect to the standardized fragment path.
    --%>
    <c:when test="${submission != null && kapp == null}">
        <c:redirect url="${bundle.spacePath}/#/datastore/forms/${submission.datastore.slug}/submissions/${submission.id}">
            <c:forEach items="${pageContext.request.parameterMap}" var="entry">
                <c:forEach items="${entry.value}" var="value">
                    <c:param name="${entry.key}" value="${value}" />
                </c:forEach>
            </c:forEach>
        </c:redirect>
    </c:when>
    <%--
        DATASTORE FORM REDIRECT
        If the request is for a form, redirect to the standardized fragment path.
    --%>
    <c:when test="${form != null && kapp == null}">
        <c:redirect url="${bundle.spacePath}/#/datastore/forms/${form.slug}">
            <c:forEach items="${pageContext.request.parameterMap}" var="entry">
                <c:forEach items="${entry.value}" var="value">
                    <c:param name="${entry.key}" value="${value}" />
                </c:forEach>
            </c:forEach>
        </c:redirect>
    </c:when>
    <%--
        SUBMISSION REDIRECT
        If the request is for a submission, redirect to the standardized fragment path.
    --%>
    <c:when test="${submission != null}">
        <c:redirect url="${bundle.spacePath}/#/kapps/${submission.form.kapp.slug}/forms/${submission.form.slug}/submissions/${submission.id}">
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
        SPACE REDIRECT (non-canonical)
        If the request is for a space, redirect to the standardized fragment path.
    --%>
    <c:when test="${
        !pageContext.request.getAttribute('javax.servlet.forward.request_uri').endsWith('/')
        || pageContext.request.getAttribute('javax.servlet.forward.query_string') != null
    }">
        <c:choose>
            <c:when test="${pageContext.request.getAttribute('javax.servlet.forward.query_string') == null}">
                <c:redirect url="${bundle.spacePath}/#/"/>
            </c:when>
            <c:otherwise>
                <c:redirect url="${bundle.spacePath}/#/?${pageContext.request.getAttribute('javax.servlet.forward.query_string')}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <%--
        RENDERING HTML AND CLIENTSIDE BUNDLE
        This renders the page that serves up the actual webpack bundle.
    --%>
    <c:otherwise>
        <%-- Determine the location of the static folder --%>
        <c:choose>
            <%-- DEVELOPMENT PROXY MODE --%>
            <c:when test="${
                (param.bundleName != null && param.bundleName == pageContext.request.getHeader('X-Webpack-Bundle-Name'))
                ||
                (param.bundleName == null && pageContext.request.getHeader('X-Webpack-Kinetic-Webserver') != null)
            }">
                <c:set var="staticLocation" value="/static"/>
            </c:when>
            <%--
                EXTERNAL ASSET MODE
                queryString is set to the query string specified in the space/kapp/form display page
                property and NOT from the actual page URL.  Therefore, the queryString can be used 
                to ensure the location parameter was specified in the CE configuration and not by 
                the page URL (which would potentially allow an attacker craft a URL that would load
                a malicious bundle).
            --%>
            <c:when test="${param.location != null && fn:startsWith(param.location, 'http') && pageContext.request.queryString.contains(param.location)}">
                <c:set var="staticLocation" value="${param.location}"/>
            </c:when>
            <%--
                EMBEDDED ASSET MODE
                queryString is set to the query string specified in the space/kapp/form display page
                property and NOT from the actual page URL.  Therefore, the queryString can be used 
                to ensure the location parameter was specified in the CE configuration and not by 
                the page URL (which would potentially allow an attacker craft a URL that would load 
                a malicious bundle).
            --%>
            <c:when test="${param.location != null && pageContext.request.queryString.contains(param.location)}">
                <c:set var="staticLocation" value="${bundle.location}/${param.location}"/>
            </c:when>
        </c:choose>

        <!doctype html>
        <html>
            <head>
                <app:headContent/>
            </head>
            <body>
                <%-- Determine what to render --%>
                <c:choose>
                    <%-- WEBPACK BUNDLE SCAFFOLDING --%>
                    <c:when test="${staticLocation != null}">
                        <div id='root'></div>
                        <script>
                            bundle.config = bundle.config || {};
                            bundle.config.staticLocation = '${text.escapeJs(staticLocation)}';
                        </script>
                        <script src="${text.escape(staticLocation)}/bundle.js"></script>
                    </c:when>
                    <%-- MISSING DEVELOPMENT MODE HEADER --%>
                    <c:when test="${param.bundleName != null && pageContext.request.getHeader('X-Webpack-Bundle-Name') == null}">
                        The display page has been configured to support development mode with the 
                        bundleName "${text.escape(param.bundleName)}", but your request is not 
                        passing a value with for the X-Webpack-Bundle-Name header.
                        <br/><br/>
                        This is most often caused by connecting directly to the Kinetic Request CE
                        webserver rather than to the local webpack server.
                    </c:when>
                    <%-- MISMATCHED BUNDLE NAME --%>
                    <c:when test="${param.bundleName != null && pageContext.request.getHeader('X-Webpack-Bundle-Name') != param.bundleName}">
                        The display page has been configured to support development mode with the
                        bundleName "${text.escape(param.bundleName)}", but your request is passing
                        an X-Webpack-Bundle-Name header value of
                        "${text.escape(pageContext.request.getHeader('X-Webpack-Bundle-Name'))}".
                    </c:when>
                    <%-- MISCONFIGURATION --%>
                    <c:otherwise>
                        The display page for this space has not been configured properly.
                        <br/><br/>
                        To render this page in deployed mode, you must set the <b>location</b> 
                        parameter.
                        <br/><br/>
                        If you are intending to render this in local development mode, your 
                        clientside bundle is not properly setting the 'X-Webpack-Kinetic-Webserver' 
                        header (or you are accidentally connecting directly to the Kinetic Request 
                        CE webserver rather than to the local development webpack server).
                    </c:otherwise>
                </c:choose>
            </body>
        </html>
    </c:otherwise>
</c:choose>
