require.config {
    baseUrl: "./"
    paths: {
        jquery: "vendor/jquery/dist/jquery"
        echarts: "vendor/echarts/build/dist/echarts-all"
    }
    shim: {
        echarts: {
            exports: "echarts"
        }
    }
}

