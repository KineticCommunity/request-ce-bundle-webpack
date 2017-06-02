# request-ce-bundle-webpack

The *request-ce-bundle-webpack* bundle is a server-side Request CE bundle used to expose client-side
bundles via webpack (such as
[request-ce-bundle-react-boilerplate](https://github.com/KineticCommunity/request-ce-bundle-react-boilerplate)).

## Quickstart
In order to prepare a Request CE server to support client-side bundles, deploy this bundle to an
appropriate Kinetic Reqeust CE bundles directory, and configure a Kapp with the following settings:

**Bundle Path:** `request-ce-bundle-webpack`  
**Kapp Display Page:** `webpack.jsp?bundleName=NAME&location=LOCATION`  
**Form Display Page:** `form.jsp`  
**Form Confirmation Page:** `confirmation.jsp`  
**Login Page:** `login.jsp`  
**Reset Password Page:** `resetPassword.jsp`  

The **Bundle Path** value should be set to the name of the directory this bundle is deployed to.

The **Kapp Display Page** `NAME` parameter value should be set to the name specified by the
client-side bundle that is being served by *request-ce-bundle-webpack*.  Typically this is based
upon the git repository name, with values such as `react-boilerplate` or `react-catalog`.

The **Kapp Display Page** `LOCATION` valid can be omitted during initial development.  See the
***Deployment Modes*** section for more information.

The **Login Page** and **Reset Password Page** can be omitted to use the default application pages.

## Deployment Modes
This bundle can be used in three different modes:

**Development Proxy Mode**  
In this mode, a developer can configure a client-side webpack bundle on their own computer to use
the remote Kinetic Request CE server.  This allows the developer to develop bundles without running
Kinetic Request CE locally.  This mode only requires that the *Kapp Display Page* be set to
`webpack.jsp?bundleName=NAME`.

**External Asset Mode**  
In this mode, the distribution files (files created in the *dist* directory after running
`yarn run build`) are made available from an external location (such as a company
webserver or Amazon s3).  These files can then be served to users and changes to the client-side
bundle can be applied at these locations without making changes to the Kinetic Request CE webserver.

In order to configure a Kapp to use the *request-ce-bundle-webpack* bundle in this mode, the
`location` parameter **must be provided** to the Kapp Display Page kapp setting.  The value of this
parameter should be the fully qualified URL to the client-side dist files (such as
`https://acme.com/bundles/catalog` or `https://s3.amazonaws.com/acme.com/bundles/catalog`).

**Embedded Asset Mode**  
In this mode, the distribution files (files created in the *dist* directory after running
`yarn run build`) are made available directly from the server-side bundle.  These files can then be
served directly by the Kinetic Request CE server, which must be modified directly whenever a change
should be deployed.

In order to configure a Kapp to use the *request-ce-bundle-webpack* bundle in this mode, a new
bundle should be created using the content of the *request-ce-bundle-webpack* bundle as a starting
point, the distribution files should be copied into a `static` directory within the root of the
bundle, and the `location` parameter **must be omitted** from the Kapp Display Page kapp setting.

## Client-side Bundle Developer Reference
This bundle automatically redirects from Kinetic Request CE routes to client-side bundle routes.  
Client-side bundles that are being served by the *request-ce-bundle-webpack* server-side bundle
should implement support for the following routes:

1. `#/forms/${form.slug}`
2. `#/submissions/${submission.id}`
3. `#/login`
4. `#/reset-password`
