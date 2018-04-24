
# request-ce-bundle-spa

The *request-ce-bundle-spa* bundle is a server-side Request CE bundle used to expose client-side bundles (such as those generated from the [kinetic-react-scripts](https://github.com/kineticdata/kinetic-react-scripts)).

This bundle is often extended when specific server-side customizations are required (such as exposing custom APIs and/or leveraging custom authorization logic for those APIs).  See the bundle/SampleHelper.md file for more information.

## Quickstart

To use the request-ce-bundle-spa bundle, the bundle must be deployed to all Kinetic Request CE servers and then the Space must be configured to use the bundle.

### Deployment

In order to prepare a Request CE server to support client-side bundles, deploy this bundle to an appropriate Kinetic Request CE bundles directory (either web application's `app/bundles` directory or to the `app/shared-bundles/BASE` directory).

### Configuration
From the Space

- **Bundle Path:** (Required)  
  The name of the directory this bundle is deployed to (for example `request-ce-bundle-spa`, or `request-ce-bundle-spa-mycompany` if customizations are made).

- **Display Type:** (Required)  
  In order to leverage this bundle, the *Display Type* must be set to `Single Page App`.
       
- **Location:**  
  This parameter value can be omitted during initial development (for example `https://s3.amazonaws.com/acme.com/bundles/catalog` or `static`).  See the [Deployment Modes](#deployment-modes) section for more information.

## Deployment Modes

**Development Proxy Mode**
In this mode, a developer can configure a client-side bundle on their own computer to use the remote Kinetic Request CE server. This allows the developer to develop bundles without running Kinetic Request CE locally.

**Production Mode**  
There are two options for deploying the client-side webpack bundles so that they can be used outside of development mode:

- **Option 1: External Asset Mode**  
In this mode, the distribution files (files created in the *dist* directory after running `yarn run build`) are made available from an external location (such as a company webserver or Amazon s3).  These files can then be served to users and changes to the client-side bundle can be applied at these locations without making changes to the Kinetic Request CE webserver.

  In order to configure a Space to use the *request-ce-bundle-spa* bundle in this mode, the `location` parameter should be specified.  The value of this parameter should be the fully qualified URL to the client-side dist files (such as `https://acme.com/bundles/catalog` or `https://s3.amazonaws.com/acme.com/bundles/catalog`).

- **Option 2: Embedded Asset Mode**  
  In this mode, the distribution files (files created in the *dist* directory after running `yarn run build`) are made available directly from the server-side bundle. These files can then be served directly by the Kinetic Request CE server, which must be modified directly whenever a change should be deployed.

  In order to configure a Space to use the *request-ce-bundle-spa* bundle in this mode, a new server-side bundle should be created using the content of this bundle as a starting point, the distribution files should be copied into a directory within the root of the bundle (by convention `static`), and the `location` parameter should be specified to match that directory.

## Client-side Bundle Developer Reference

When using this bundle with a Space configured with the `Single Page App` display type, the server-side bundle automatically redirects from Kinetic Request CE routes to predefined client-side bundle routes. Client-side bundles that are intended to be used as a single Bundle should implement support (which may be rendering or redirecting to more domain specific options) for the following routes:

1. `/#/`
2. `/#/datastore/forms/:slug`
3. `/#/datastore/forms/:slug/submissions/:id`
4. `/#/kapps/:slug/forms/:slug`
5. `/#/kapps/:slug/forms/:slug/submissions/:id`
6. `/#/kapps/:slug`

For a fully functional example of a client-side bundle, see the  [request-ce-bundle-kinops](https://github.com/kineticdata/request-ce-bundle-kinops) repository.