
# request-ce-bundle-webpack

The *request-ce-bundle-webpack* bundle is a server-side Request CE bundle used to expose client-side bundles via webpack, such as those generated from the [kinetic-react-scripts](https://github.com/kineticdata/kinetic-react-scripts).  This bundle must exist on the Kinetic Request CE web server in order to use any client-side React bundles.

## Quickstart

To use the webpack bundle, first the bundle must be deployed to all Kinetic Request CE servers and then the Kapp must be configured to use the bundle.

### Deployment

In order to prepare a Request CE server to support client-side bundles, deploy this bundle to an appropriate Kinetic Request CE bundles directory (either web application's `app/bundles` directory or to the `app/shared-bundles/BASE` directory).

### Configuration

This bundle can be used to serve **separate client-side bundles** for the Space and kapps, or to serve a **single client-side bundle** responsible for handling the Space and one or more Kapps.

#### Space Configuration

- **Bundle Path:** (Required)  
  The name of the directory this bundle is deployed to.

    *Example*
    ```text
    request-ce-bundle-webpack
    ```

- **Space Display Page:** (Required)  
  The name of the JSP page used to render the basic Space information.  This should be set to `space.jsp` and takes additional parameters (in the format of `space.jsp?bundleName=foo`).

  - **bundleName** (Required for local development)  
  This parameter value should be set to the name specified by the client-side bundle that is being served by *request-ce-bundle-webpack*.  Typically this is based upon the git repository name, with values such as `request-ce-bundle-space` or `catalog`.
  - **location** or **path** (Required for typical use)  
  This parameter value can be omitted during initial development.  See the [Deployment Modes](#deployment-modes) section for more information.
       
  *Example: Single Client-Side Bundles*
  ```text
    space.jsp?bundleName=catalog
    space.jsp?bundleName=portal&location=https://s3.amazonaws.com/acme.com/bundles/portal
    space.jsp?bundleName=catalog&path=static
  ```

- **Login Page:**  
  The *Login Page* value can be set to blank, which means that the default application login page will be used.  The login page can be passed an optional `fragment` parameter.
  
  - **fragment**  
  Similar to when the *Login Page* value itself is blank, leaving the `fragment` parameter blank will cause the default application login page to be used.  When the parameter is specified, the server-side bundle will redirect to `/#/VALUE` (by convention, this is typically `/#/login`).
    
  *Example: Separate Client-Side Bundles*
   ```text
    login.jsp
    login.jsp?fragment=login
  ```
  *Example: Single Client-Side Bundles*
  ```text
    space.jsp?fragment=login
  ```

- **Reset Password Page:**  
  The *Reset Password Page* value can be set to blank, which means that the default application login page will be used.  The login page can be passed an optional `fragment` parameter.
  
  - **fragment**  
  Similar to when the *Reset Password Page* value itself is blank, leaving the `fragment` parameter blank will cause the default application login page to be used.  When the parameter is specified, the server-side bundle will redirect to `/#/VALUE` (by convention, this is typically `/#/reset-password`).
    
  *Example: Separate Client-Side Bundles*
  ```text
    resetPassword.jsp
    resetPassword.jsp?fragment=reset-password
  ```
  *Example: Single Client-Side Bundles*
  ```text
    space.jsp?fragment=reset-password
  ```

#### Kapp Configuration

- **Bundle Path:** (Required)  
  The name of the directory this bundle is deployed to.
  
    *Example*
    ```text
      request-ce-bundle-webpack
    ```

- **Kapp Display Page:** (Required)  
  The name of the JSP page used to render the basic Kapp information.  For **separate client-side bundles** this should be set to `kapp.jsp`.  For **single client-side bundles** this should be set to `space.jsp`.  Both of these display pages take additional parameters (in the format of `kapp.jsp?bundleName=foo` or `space.jsp?bundleName=foo`).

  - **bundleName** (Required for local development)  
  This parameter value should be set to the name specified by the client-side bundle that is being served by *request-ce-bundle-webpack*.  Typically this is based upon the git repository name, with values such as `request-ce-bundle-space` or `catalog`.
  - **location** or **path** (Required for typical use)  
  This parameter value can be omitted during initial development.  See the [Deployment Modes](#deployment-modes) section for more information.
       
   *Example: Separate Client-Side Bundles*
   ```text
     kapp.jsp?bundleName=catalog
     kapp.jsp?bundleName=catalog&location=https://s3.amazonaws.com/acme.com/bundles/catalog
     kapp.jsp?bundleName=catalog&path=static
   ```
    *Example: Single Client-Side Bundles*
   ```text
     space.jsp?bundleName=catalog
     space.jsp?bundleName=portal&location=https://s3.amazonaws.com/acme.com/bundles/portal
     space.jsp?bundleName=catalog&path=static
   ```

- **Form Display Page:**  
  The name of the JSP page used to render the basic Form information.  For **separate client-side bundles** this should be set to `form.jsp`.  For **single client-side bundles** this should be set to `space.jsp`.
       
   *Example: Separate Client-Side Bundles*
   ```text
     form.jsp
   ```
   *Example: Single Client-Side Bundles*
   ```text
     space.jsp
   ```

- **Form Confirmation Page:**  
  The name of the JSP page used to render the basic Form information.  For **separate client-side bundles** this should be set to `confirmation.jsp`.  For **single client-side bundles** this should be set to `space.jsp`.
       
   *Example: Separate Client-Side Bundles*
   ```text
     confirmation.jsp
   ```
   *Example: Single Client-Side Bundles*
   ```text
     space.jsp
   ```

- **Login Page:**  
  The *Login Page* value can be set to blank, which means that the default application login page will be used.  The login page can be passed an optional `fragment` parameter.
  
  - **fragment**  
  Similar to when the *Login Page* value itself is blank, leaving the `fragment` parameter blank will cause the default application login page to be used.  When the parameter is specified, the server-side bundle will redirect to `/#/VALUE` (by convention, this is typically `/#/login`).
    
  *Example: Separate Client-Side Bundles*
  ```text
    login.jsp
    login.jsp?fragment=login
  ```
  *Example: Single Client-Side Bundles*
  ```text
    space.jsp?fragment=login
  ```
  
- **Reset Password Page:**  
  The *Reset Password Page* value can be set to blank, which means that the default application login page will be used.  The login page can be passed an optional `fragment` parameter.
  
  - **fragment**  
  Similar to when the *Reset Password Page* value itself is blank, leaving the `fragment` parameter blank will cause the default application login page to be used.  When the parameter is specified, the server-side bundle will redirect to `/#/VALUE` (by convention, this is typically `/#/reset-password`).
    
  *Example: Separate Client-Side Bundles*
  ```text
    resetPassword.jsp
    resetPassword.jsp?fragment=reset-password
  ```
  *Example: Single Client-Side Bundles*
  ```text
    space.jsp?fragment=reset-password
  ```

## Deployment Modes

**Development Proxy Mode**
In this mode, a developer can configure a client-side webpack bundle on their own computer to use the remote Kinetic Request CE server. This allows the developer to develop bundles without running Kinetic Request CE locally.  This mode only requires that the *Space Display Page* and/or *Kapp Display Page* values be set with `?bundleName=NAME`.

**Production Mode**  
There are two options for deploying the client-side webpack bundles so that they can be used outside of development mode:

- **Option 1: External Asset Mode**  
In this mode, the distribution files (files created in the *dist* directory after running `yarn run build`) are made available from an external location (such as a company webserver or Amazon s3).  These files can then be served to users and changes to the client-side bundle can be applied at these locations without making changes to the Kinetic Request CE webserver.

  In order to configure a Space and/or Kapp to use the *request-ce-bundle-webpack* bundle in this mode, the `location` parameter should be specified.  The value of this parameter should be the fully qualified URL to the client-side dist files (such as `https://acme.com/bundles/catalog` or `https://s3.amazonaws.com/acme.com/bundles/catalog`).

- **Option 2: Embedded Asset Mode**  
  In this mode, the distribution files (files created in the *dist* directory after running `yarn run build`) are made available directly from the server-side bundle. These files can then be served directly by the Kinetic Request CE server, which must be modified directly whenever a change should be deployed.

  In order to configure a Space and/or Kapp to use the *request-ce-bundle-webpack* bundle in this mode, a new server-side bundle should be created using the content of this bundle as a starting point, the distribution files should be copied into a directory within the root of the bundle (by convention `static`), and the `path` parameter should be specified to match that directory.

## Client-side Bundle Developer Reference

### Separate Bundles Per Kapp
When using the `webpack.jsp` display page, the server-side bundle automatically redirects from Kinetic Request CE routes to predefined client-side bundle routes. Client-side bundles that are being served this bundle should implement support for the following routes:

1. `#/forms/${form.slug}`
1. `#/submissions/${submission.id}`
1. `#/login`
1. `#/reset-password`

### Single Bundle for Space and Kapps
When using the `space.jsp` display page, the server-side bundle automatically redirects from Kinetic Request CE routes to predefined client-side bundle routes. Client-side bundles that are intended to be used as a single Bundle should implement support for the following routes:

1. `#/kapps/${kapp.slug}`
1. `#/kapps/${kapp.slug}/forms/${form.slug}`
1. `#/kapps/${kapp.slug}/submissions/${submission.id}`
1. `#/login`
1. `#/reset-password`