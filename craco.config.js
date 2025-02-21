const { getLoader, getPlugin } = require('@craco/craco')
const path = require('path')
const { DefinePlugin } = require('webpack')

module.exports = {
  webpack: {
    alias: {
      '@': path.resolve(__dirname, './src')
    }
    // configure: (webpackConfig, { env, paths }) => {
    //   const forkTsPlugInInstances = webpackConfig.plugins.find(
    //     (p) => p.constructor.name === "ForkTsCheckerWebpackPlugin"
    //   );
    //   if (!forkTsPlugInInstances) return webpackConfig;

    //   forkTsPlugInInstances.options.typescript.build = true;

    //   return webpackConfig;
    // },
  },
  plugins: [
    {
      plugin: require('craco-less'),
      options: {
        noIeCompat: true
      }
    },
    {
      plugin: {
        overrideWebpackConfig: ({ context, webpackConfig }) => {
          const { isFound, match: fileLoaderMatch } = getLoader(
            webpackConfig,
            (rule) => rule.type === 'asset/resource'
          )

          if (!isFound) {
            throw {
              message: `Can't find file-loader in the ${context.env} webpack config!`
            }
          }

          fileLoaderMatch.loader.exclude.push(/\.ya?ml$/)

          const yamlLoader = {
            use: ['yaml-loader'],
            test: /\.(ya?ml)$/
          }
          const svgrLoader = {
            test: /\.svg$/,
            use: ['@svgr/webpack']
          }
          webpackConfig.module.rules.push(...[yamlLoader, svgrLoader])

          const isLibrary = process.argv.includes('--library')
          if (isLibrary) {
            webpackConfig.entry = './src/Library.ts'
            webpackConfig.output.path = path.resolve(__dirname, 'dist')
            webpackConfig.output.filename = '[name].js'
            webpackConfig.output.publicPath = ''
            webpackConfig.output.chunkFilename = '[name].[contenthash:8].chunk.js'
            // webpackConfig.output
            webpackConfig.output.assetModuleFilename = 'static/media/[name].[hash][ext]'
            webpackConfig.output.library = { name: 'canvas-designer', type: 'umd' }
            webpackConfig.output.libraryTarget = 'umd'
            getLoader(webpackConfig, (rule) => {
              if (rule.test && rule.test.test && rule.test.test('index.css') && rule.use) {
                rule.use[0].options.publicPath = '../../'
              }
            })
            getPlugin(webpackConfig, (plugin) => {
              if (
                plugin.options &&
                plugin.options.filename === 'static/css/[name].[contenthash:8].css'
              ) {
                plugin.options.filename = 'static/[name].css'
              }
            })
            webpackConfig.externals = [
              {
                'react': 'react',
                'react-dom': 'react-dom',
                'react-router-dom': 'react-router-dom'
              }
            ]
            webpackConfig.plugins.push(
              new DefinePlugin({
                'process.env.NPM_LIBRARY': JSON.stringify(true)
              })
            )
          }
          return webpackConfig
        }
      }
    }
  ],
  devServer: (devServerConfig, { env, paths, proxy, allowedHost }) => {
    devServerConfig.proxy = devServerConfig.proxy || {}
    devServerConfig.proxy['/codesandbox'] = {
      target: 'https://codesandbox.io',
      pathRewrite: {
        '^/codesandbox': ''
      },
      changeOrigin: true
    }
    return devServerConfig
  }
}
