process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

module.exports = environment.toWebpackConfig()

// Uncomment to see bundle size visualization
// module.exports = { ...module.exports, plugins: [...module.exports.plugins, new BundleAnalyzerPlugin()]}
