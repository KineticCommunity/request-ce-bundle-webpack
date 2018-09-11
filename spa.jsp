<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true" %>
<%@page import="java.net.*"%>
<%@page import="java.util.*"%>
<%@include file="bundle/initialization.jspf" %>
<%@include file="bundle/router.jspf" %>

<%-- 
    DETERMINE ROUTING
    
    Note: When an implementation is using a single bundle (ie the kapps use the same webpack bundle
    as th espace), this JSP will also be used for the Kapp and Form display pages.
--%>
<%
    StringBuilder spaClientParams = new StringBuilder();
    StringBuilder spaServerParams = new StringBuilder();
    String encoding = response.getCharacterEncoding();

    // Build the map of parameters specified by the Display Page value (ie the parameters not 
    // specified by the originating request, such as location=https://s3.amazonaws.com/...).
    // These values should not be included as server-side or client-side parameters.
    Set<String> systemParameters = new HashSet<>();
    // If there is a query string, and that string is different than the forwarded query string
    // (in which case request.getQueryString() will be the query string defined by the Display
    // Page value)
    if (
        request.getQueryString() != null
        && !request.getQueryString().equals(request.getAttribute("javax.servlet.forward.query_string"))
    ) {
        String[] parameterTuples = request.getQueryString().split("&");
        for (int i=0;i<parameterTuples.length;i++) {
            String[] parameterSegment = parameterTuples[i].split("=", 2);
            systemParameters.add(parameterSegment[0]);
        }
    }

    for (Map.Entry<String,String[]> entry : request.getParameterMap().entrySet()) {
        if (systemParameters.contains(entry.getKey())) {
            // No-op
        } else if ("debugjs".equals(entry.getKey())) {
            if (entry.getValue() == null || entry.getValue().length == 0 || entry.getValue()[0] == "") {
                spaServerParams.append((spaServerParams.length() == 0) ? "?" : "&");
                spaServerParams.append(URLEncoder.encode(entry.getKey(), encoding));
            } else {
                for (int i=0;i<entry.getValue().length;i++) {
                    spaServerParams.append((spaServerParams.length() == 0) ? "?" : "&");
                    spaServerParams.append(URLEncoder.encode(entry.getKey(), encoding));
                    spaServerParams.append("=");
                    spaServerParams.append(URLEncoder.encode(entry.getValue()[i], encoding));
                }
            }
        } else {
            if (entry.getValue() == null || entry.getValue().length == 0 || entry.getValue()[0] == "") {
                spaClientParams.append((spaClientParams.length() == 0) ? "?" : "&");
                spaClientParams.append(URLEncoder.encode(entry.getKey(), encoding));
            } else {
                for (int i=0;i<entry.getValue().length;i++) {
                    spaClientParams.append((spaClientParams.length() == 0) ? "?" : "&");
                    spaClientParams.append(URLEncoder.encode(entry.getKey(), encoding));
                    spaClientParams.append("=");
                    spaClientParams.append(URLEncoder.encode(entry.getValue()[i], encoding));
                }
            }
        }
    }
    request.setAttribute("spaClientParams", spaClientParams.toString());
    request.setAttribute("spaServerParams", spaServerParams.toString());
%>
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
        <c:redirect url="${bundle.spacePath}/${spaServerParams}#/datastore/forms/${submission.datastore.slug}/submissions/${submission.id}${spaClientParams}"/>
    </c:when>
    <%-- 
        DATASTORE FORM REDIRECT
        If the request is for a form, redirect to the standardized fragment path.
    --%>
    <c:when test="${form != null && kapp == null}">
        <c:redirect url="${bundle.spacePath}/${spaServerParams}#/datastore/forms/${form.slug}${spaClientParams}"/>
    </c:when>
    <%-- 
        SUBMISSION REDIRECT
        If the request is for a submission, redirect to the standardized fragment path.
    --%>
    <c:when test="${submission != null && kapp != null}">
        <c:redirect url="${bundle.spacePath}/${spaServerParams}#/kapps/${submission.form.kapp.slug}/forms/${submission.form.slug}/submissions/${submission.id}${spaClientParams}"/>
    </c:when>
    <%-- 
        FORM REDIRECT
        If the request is for a form, redirect to the standardized fragment path.
    --%>
    <c:when test="${form != null && kapp != null}">
        <c:redirect url="${bundle.spacePath}/${spaServerParams}#/kapps/${form.kapp.slug}/forms/${form.slug}${spaClientParams}"/>
    </c:when>
    <%-- 
        KAPP REDIRECT
        If the request is for a kapp, redirect to the standardized fragment path.
    --%>
    <c:when test="${kapp != null}">
        <c:redirect url="${bundle.spacePath}/${spaServerParams}#/kapps/${kapp.slug}${spaClientParams}"/>
    </c:when>
    <%-- 
        SPACE REDIRECT (non-canonical)
        If the request is for a space, redirect to the standardized fragment path.
    --%>
    <c:when test="${
        !pageContext.request.getAttribute('javax.servlet.forward.request_uri').endsWith('/')
        || spaClientParams != ''
    }">
        <c:redirect url="${bundle.spacePath}/${spaServerParams}#/${spaClientParams}"/>
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
                    <%-- FORCE SSO LOGIN REDIRECT WHEN SAML IS ENABLED AND USER IS NOT AUTHENTICATED --%>
                    <c:when test="${identity.authenticated eq false && hasSAML eq true}">
                        <script>
                            window.location.href = "app/oauth/authorize?grant_type=implicit&response_type=token&client_id=bundle-ui&state=" 
                                + encodeURIComponent(window.location.hash.replace(/^#/, ""));
                        </script>
                    </c:when>
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
