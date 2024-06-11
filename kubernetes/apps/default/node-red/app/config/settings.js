module.exports = {
    flowFile: 'flows.json',
    credentialSecret: process.env.NODE_RED_SECRET,
    flowFilePretty: true,
    /*adminAuth: {
        type: "strategy",
        strategy: {
          name: "openidconnect",
          autoLogin: true,
          label: "Sign in",
          icon: "fa-cloud",
          strategy: require("passport-openidconnect").Strategy,
          options: {
            issuer: "https://auth.cluster.dnhrrs.xyz/application/o/node-red/",
            authorizationURL: "https://auth.cluster.dnhrrs.xyz/application/o/authorize/",
            tokenURL: "https://auth.cluster.dnhrrs.xyz/application/o/token/",
            userInfoURL: "https://auth.cluster.dnhrrs.xyz/application/o/userinfo/",
            clientID: process.env.AUTHENTIK_CLIENT_ID,
            clientSecret: process.env.AUTHENTIK_CLIENT_SECRET,
            callbackURL: "https://nodered.cluster.dnhrrs.xyz/auth/strategy/callback",
            scope: ["email", "profile", "openid"],
            proxy: true,
            verify: function (issuer, profile, done) {
              done(null, profile)
            },
          },
        },
        users: [{username: "dan", permissions: ["*"]}],
    },*/
    uiPort: process.env.PORT || 1880,
    diagnostics: {
        enabled: true,
        ui: true,
    },
    runtimeState: {
        enabled: false,
        ui: false,
    },
    logging: {
        console: {
            level: "debug",
            metrics: false,
            audit: false
        }
    },
    exportGlobalContextKeys: false,
    externalModules: {},
    editorTheme: {
        palette: {},
        projects: {
            enabled: false,
            workflow: {
                mode: "manual"
            }
        },

        codeEditor: {
            lib: "monaco",
            options: {}
        },

        markdownEditor: {
            mermaid: {
                enabled: true
            }
        },

    },
    functionExternalModules: true,
    functionTimeout: 0,
    functionGlobalContext: {},
    debugMaxLength: 1000,
    mqttReconnectTime: 15000,
    serialReconnectTime: 15000,
}
