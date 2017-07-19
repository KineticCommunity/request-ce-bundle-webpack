# request-ce-bundle-webpack

The *request-ce-bundle-webpack* bundle is a server-side Request CE bundle used to expose client-side bundles via webpack, such as [request-ce-bundle-react-boilerplate](https://github.com/KineticCommunity/request-ce-bundle-react-boilerplate).  This bundle must exist on the Kinetic Request CE web server in order to use any client-side React bundles.

## Quickstart

To use the webpack bundle, first the bundle must be deployed to all Kinetic Request CE servers and then the Kapp must be configured to use the bundle.

### Deployment

In order to prepare a Request CE server to support client-side bundles, deploy this bundle to an appropriate Kinetic Reqeust CE bundles directory.  Bundles must be deployed to either a Kapp specific bundle directory located in the deployed web application's `app/bundles` directory, or to the shared bundle directory located in the deployed web application's `app/shared-bundles` directory.

If deploying to a Kapp specific directory, the location would be `app/bundles/SPACE_SLUG/KAPP_SLUG` where SPACE_SLUG is the value of the space slug, and KAPP_SLUG is the value of the kapp slug that will be using this bundle.

### Kapp Configuration

Once this bundle is deployed to all web servers in the cluster, configure the Kapp with the following settings:

- **Bundle Path:** (Required)

  The name of the directory this bundle is deployed to.

    ```text
    Example: request-ce-bundle-webpack
    ```

- **Kapp Display Page:** (Required)

  The name of the JSP page used to render the basic Kapp information.  Since this bundle is meant as a generic base framework which is meant to be extended by other React bundles, this value should always be `webpack.jsp`.  In order to allow this server-side page to use the desired client-side React bundle, this JSP page utilizes two URL parameters:

  - **bundleName** (Required)

  This parameter value should be set to the name specified by the client-side bundle that is being served by *request-ce-bundle-webpack*.  Typically this is based upon the git repository name, with values such as `react-boilerplate` or `catalog`.

  - **location** (Optional)

  This parameter value can be omitted during initial development.  See the [Deployment Modes](#deployment-modes) section for more information.

    ```text
    Example: webpack.jsp?bundleName=catalog
    Example: webpack.jsp?bundleName=catalog&location=https://s3.amazonaws.com/acme.com/bundles/catalog
    ```

- **Form Display Page:** (Required)

  The name of the JSP page used to render a form. This value should always be `form.jsp`.

    ```text
    Example: form.jsp
    ```

- **Form Confirmation Page:** (Required)

  The name of the JSP page used to render the confirmation page of a submission.  This value should always be `confirmation.jsp`.

    ```text
    Example: confirmation.jsp
    ```

- **Login Page:** (Optional)

  The name of the JSP page used to render the login page to the user.  If the Kapp should use the same login page as all the other Kapps in the Space, then this value can be omitted, otherwise it should be set to `login.jsp`.

    ```text
    Example: login.jsp
    ```

- **Reset Password Page:** (Optional)

  The name of the JSP page for users to reset their password. If the Kapp should use the same password reset page as all the other Kapps in the Space, then this value can be omitted, otherwise it should be set to `resetPassword.jsp`.

    ```text
    Example: resetPassword.jsp
    ```

## Deployment Modes

This bundle can be used in three different modes:

- **Development Proxy Mode**

  In this mode, a developer can configure a client-side webpack bundle on their own computer to use the remote Kinetic Request CE server. This allows the developer to develop bundles without running Kinetic Request CE locally.  This mode only requires that the *Kapp Display Page* be set to `webpack.jsp?bundleName=NAME`.

- **External Asset Mode**

  In this mode, the distribution files (files created in the *dist* directory after running `yarn run build`) are made available from an external location (such as a company webserver or Amazon s3).  These files can then be served to users and changes to the client-side bundle can be applied at these locations without making changes to the Kinetic Request CE webserver.

  In order to configure a Kapp to use the *request-ce-bundle-webpack* bundle in this mode, the `location` parameter **must be provided** to the Kapp Display Page kapp setting.  The value of this parameter should be the fully qualified URL to the client-side dist files (such as `https://acme.com/bundles/catalog` or `https://s3.amazonaws.com/acme.com/bundles/catalog`).

- **Embedded Asset Mode**

  In this mode, the distribution files (files created in the *dist* directory after running `yarn run build`) are made available directly from the server-side bundle. These files can then be served directly by the Kinetic Request CE server, which must be modified directly whenever a change should be deployed.

  In order to configure a Kapp to use the *request-ce-bundle-webpack* bundle in this mode, a new bundle should be created using the content of the *request-ce-bundle-webpack* bundle as a starting point, the distribution files should be copied into a `static` directory within the root of the bundle, and the `location` parameter **must be omitted** from the Kapp Display Page kapp setting.

## Client-side Bundle Developer Reference

This bundle automatically redirects from Kinetic Request CE routes to client-side bundle routes. Client-side bundles that are being served by the *request-ce-bundle-webpack* server-side bundle should implement support for the following routes:

1. `#/forms/${form.slug}`
1. `#/submissions/${submission.id}`
1. `#/login`
1. `#/reset-password`
