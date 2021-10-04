const { environment } = require('@rails/webpacker');
const wp_merge = require('webpack-merge');
const webpack = require('webpack');

function customizeSassModuleLoader() {
    const myCssLoaderOptions = {
        modules: {
            localIdentName: "[name]__[local]___[hash:base64:5]",
        },
        sourceMap: true
    };

    const sassLoader = environment.loaders.get('moduleSass')
    sassLoader.test = /\.module\.(css|scss)$/i
    const CSSLoader = sassLoader.use.find(el => el.loader === 'css-loader');
    CSSLoader.options = wp_merge.merge(CSSLoader.options, myCssLoaderOptions);
}

function customizeSassLoader() {
    // Get the actual sass-loader config
    const sassLoader = environment.loaders.get('sass')
    const sassLoaderConfig = sassLoader.use.find(element => {
        return element.loader === 'sass-loader'
    })
    // Use Dart-implementation of Sass (default is node-sass; doesn't support sass modules yet)
    const options = sassLoaderConfig.options
    options.implementation = require('sass')
}

customizeSassModuleLoader()
customizeSassLoader()

// Ignore all locale files of moment.js
environment.plugins.insert(
    'IgnorePlugin',
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
)

module.exports = environment;
