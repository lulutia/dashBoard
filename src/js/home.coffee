require.config {
    baseUrl: "./"
    waitSeconds:0
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

