<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true" %>
<%@include file="bundle/initialization.jspf" %>
<bundle:layout page="layouts/layout.jsp">
  <c:set var="redirectUrl" value="${SpaRedirectHelper.getRedirectUrl()}" scope="page"/>
  <c:choose>
    <c:when test="${not empty hasSAML and hasSAML and empty idpDiscoReturnParam}">
        <c:redirect url="/${space.slug}/app/saml/login/alias/${space.slug}" />
    </c:when>
    <c:when test="${not empty idpDiscoReturnParam}">
        <h1>Identity Provider Selection</h1>
        <section>
            <form action="${idpDiscoReturnURL}" method="GET">
                <c:forEach var="idp" items="${idps}">
                    <div class="form-group">
                        <label>
                            <input type="radio" name="${idpDiscoReturnParam}" id="idp_${idp.value}" value="${idp.value}" />
                            ${idp.key}
                        </label>
                    </div>
                </c:forEach>
                <p>
                    <input type="submit" value="Login" class="btn btn-default"/>
                </p>
            </form>
        </section>
    </c:when>
  </c:choose>
</bundle:layout>